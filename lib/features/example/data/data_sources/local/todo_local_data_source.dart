import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../../../../../core/error/app_exception.dart';
import '../../../../../core/generic/data/async_lock.dart';
import '../../../../../core/generic/domain/entities/page.dart';
import '../../../../../core/storage/key_value_stores.dart';
import '../../../domain/params/todo_params.dart';
import '../../models/todo_model.dart';

/// Offline cache of to-do **pages**. Throws `StorageException` /
/// `CacheMissException`.
///
/// The cache is *authoritative per query*: it only ever replays a page exactly
/// as the server returned it for the same query, page number and page size.
/// It never answers a query by filtering other cached data, so deleted or
/// renamed items can't leak into results the server never produced.
abstract interface class ITodoLocalDataSource {
  /// The cached answer for [page] of [query], or `null` when none is cached.
  Future<PageResult<TodoModel>?> getPage({
    required PageRequest page,
    required TodoQuery query,
  });

  /// Stores the server's answer for [page] of [query]. A first page replaces
  /// every other cached page of the same query (they may be stale).
  Future<void> savePage({
    required PageRequest page,
    required TodoQuery query,
    required PageResult<TodoModel> result,
  });

  /// Throws `CacheMissException` if [id] isn't in any cached page.
  Future<TodoModel> getTodo({required String id});

  /// Applies a created/updated [todo] to the cached pages: replaces it where
  /// it still matches the page's query, removes it where it no longer does,
  /// and drops the queries it newly belongs to (its position is unknown).
  Future<void> saveTodo({required TodoModel todo});

  /// Removes [id] from every cached page.
  Future<void> deleteTodo({required String id});

  /// Removes everything (logout / account switch).
  Future<void> clear();
}

@LazySingleton(as: ITodoLocalDataSource)
class TodoLocalDataSource implements ITodoLocalDataSource {
  TodoLocalDataSource({required PreferencesStore store}) : _store = store;

  static const String storageKey = 'cache.todo_pages';

  /// At most this many pages are kept; the least recently used go first.
  static const int maxPages = 20;

  /// At most this many items are kept per page.
  static const int maxItemsPerPage = 100;

  /// Searches longer than this are not cached (bounds the key size).
  static const int maxSearchLength = 80;

  static const int _version = 1;

  final PreferencesStore _store;
  final AsyncLock _lock = AsyncLock();

  @override
  Future<PageResult<TodoModel>?> getPage({
    required PageRequest page,
    required TodoQuery query,
  }) => _lock.synchronized(() async {
    final entries = await _load();
    final index = entries.indexWhere((e) => e.isPage(page: page, query: query));
    if (index < 0) {
      return null;
    }
    final entry = entries[index];
    // Reads refresh recency, so the pages a user keeps visiting survive.
    entries
      ..removeAt(index)
      ..add(entry);
    await _persistBestEffort(entries);
    return PageResult(
      items: entry.items,
      hasMore: entry.hasMore,
      nextCursor: entry.nextCursor,
    );
  });

  @override
  Future<void> savePage({
    required PageRequest page,
    required TodoQuery query,
    required PageResult<TodoModel> result,
  }) => _lock.synchronized(() async {
    if (query.search.length > maxSearchLength) {
      return;
    }
    final entries = await _load();
    if (page.isFirst) {
      entries.removeWhere((e) => e.sameGroup(page: page, query: query));
    } else {
      entries.removeWhere((e) => e.isPage(page: page, query: query));
    }
    entries.add(
      _Entry(
        search: query.search,
        onlyOpen: query.onlyOpen,
        limit: page.limit,
        page: page.page,
        items: result.items.take(maxItemsPerPage).toList(),
        hasMore: result.hasMore,
        nextCursor: result.nextCursor,
      ),
    );
    await _persist(_bounded(entries));
  });

  @override
  Future<TodoModel> getTodo({required String id}) =>
      _lock.synchronized(() async {
        final entries = await _load();
        for (final entry in entries.reversed) {
          for (final item in entry.items) {
            if (item.id == id) {
              return item;
            }
          }
        }
        throw const CacheMissException(debugMessage: 'todo is not cached');
      });

  @override
  Future<void> saveTodo({required TodoModel todo}) =>
      _lock.synchronized(() async {
        final entries = await _load();
        final stale = <_Entry>[];
        for (final entry in entries) {
          final at = entry.items.indexWhere((t) => t.id == todo.id);
          final matches = entry.matches(todo);
          if (at >= 0 && matches) {
            entry.items[at] = todo;
          } else if (at >= 0) {
            entry.items.removeAt(at);
          } else if (matches) {
            stale.add(entry); // Newly belongs here; position unknown.
          }
        }
        entries.removeWhere((e) => stale.any((s) => s.groupKey == e.groupKey));
        await _persist(entries);
      });

  @override
  Future<void> deleteTodo({required String id}) => _lock.synchronized(() async {
    final entries = await _load();
    for (final entry in entries) {
      entry.items.removeWhere((t) => t.id == id);
    }
    await _persist(entries);
  });

  @override
  Future<void> clear() => _lock.synchronized(() => _store.remove(storageKey));

  static List<_Entry> _bounded(List<_Entry> entries) =>
      entries.length > maxPages
      ? entries.sublist(entries.length - maxPages)
      : entries;

  /// Reads the cache. Anything unreadable is **repaired**: undecodable
  /// entries are dropped, and a wholly corrupt value is removed, so one bad
  /// write can never wedge the cache (reads *and* writes) for good.
  // Must only be called while holding [_lock].
  Future<List<_Entry>> _load() async {
    final raw = _store.getString(storageKey);
    if (raw == null || raw.isEmpty) {
      return [];
    }
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      if (decoded['v'] != _version) {
        throw const FormatException('unsupported cache version');
      }
      final entries = <_Entry>[];
      var repaired = false;
      for (final json in decoded['entries'] as List<dynamic>) {
        try {
          entries.add(_Entry.fromJson(json as Map<String, dynamic>));
        } on Object {
          repaired = true; // Drop just this entry.
        }
      }
      if (repaired) {
        await _persistBestEffort(entries);
      }
      return entries;
    } on Object {
      await _discardCorrupt();
      return [];
    }
  }

  Future<void> _discardCorrupt() async {
    try {
      await _store.remove(storageKey);
    } on AppException {
      // Still unreadable; the next write replaces it.
    }
  }

  Future<void> _persistBestEffort(List<_Entry> entries) async {
    try {
      await _persist(entries);
    } on AppException {
      // Recency/repair bookkeeping only.
    }
  }

  Future<void> _persist(List<_Entry> entries) {
    if (entries.isEmpty) {
      return _store.remove(storageKey);
    }
    final String encoded;
    try {
      encoded = jsonEncode({
        'v': _version,
        'entries': [for (final e in entries) e.toJson()],
      });
    } on Object catch (e) {
      throw StorageException(
        debugMessage: '$storageKey: cache could not be encoded',
        cause: e.runtimeType,
      );
    }
    return _store.setString(storageKey, encoded);
  }
}

/// One cached page of one query.
class _Entry {
  _Entry({
    required this.search,
    required this.onlyOpen,
    required this.limit,
    required this.page,
    required this.items,
    required this.hasMore,
    required this.nextCursor,
  });

  factory _Entry.fromJson(Map<String, dynamic> json) => _Entry(
    search: json['search'] as String,
    onlyOpen: json['only_open'] as bool,
    limit: json['limit'] as int,
    page: json['page'] as int,
    items: [
      for (final item in json['items'] as List<dynamic>)
        TodoModel.fromJson(item as Map<String, dynamic>),
    ],
    hasMore: json['has_more'] as bool,
    nextCursor: json['next_cursor'] as String?,
  );

  final String search;
  final bool onlyOpen;
  final int limit;
  final int page;
  final List<TodoModel> items;
  final bool hasMore;
  final String? nextCursor;

  /// Pages of the same query and page size belong together.
  String get groupKey => '$onlyOpen|$limit|$search';

  bool isPage({required PageRequest page, required TodoQuery query}) =>
      sameGroup(page: page, query: query) && this.page == page.page;

  bool sameGroup({required PageRequest page, required TodoQuery query}) =>
      onlyOpen == query.onlyOpen &&
      limit == page.limit &&
      search == query.search;

  /// Same rule the server applies for [TodoQuery].
  bool matches(TodoModel todo) {
    if (onlyOpen && todo.isDone) {
      return false;
    }
    final needle = search.trim().toLowerCase();
    return needle.isEmpty || todo.title.toLowerCase().contains(needle);
  }

  Map<String, dynamic> toJson() => {
    'search': search,
    'only_open': onlyOpen,
    'limit': limit,
    'page': page,
    'items': [for (final item in items) item.toJson()],
    'has_more': hasMore,
    'next_cursor': nextCursor,
  };
}
