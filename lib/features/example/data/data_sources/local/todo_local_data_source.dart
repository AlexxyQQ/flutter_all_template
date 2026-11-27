import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../../../../../core/generic/domain/entities/page.dart';
import '../../../../../core/services/logger/data/app_logger.dart';
import '../../../../../core/session/session_scope.dart';
import '../../../../../core/storage/key_value_stores.dart';
import '../../../domain/params/todo_params.dart';
import '../../models/todo_model.dart';

/// Offline cache of the **last first page** the server returned. Throws
/// `StorageException` when the store fails.
///
/// One entry only: the answer to the most recent first-page request, tagged
/// with the query and page size it answers. It is served back only for that
/// exact query and page size, so the cache can never approximate one query
/// from another's data. Anything unreadable is treated as empty.
abstract interface class ITodoLocalDataSource {
  /// The cached first page for [query] and [limit], or `null` when the cache
  /// holds another query's page (or nothing).
  Future<PageResult<TodoModel>?> getFirstPage({
    required TodoQuery query,
    required int limit,
  });

  /// Replaces the cache with the server's first page for [query].
  Future<void> saveFirstPage({
    required TodoQuery query,
    required int limit,
    required PageResult<TodoModel> result,
  });

  /// Drops the cached page (it no longer reflects the server).
  Future<void> clear();
}

@LazySingleton(as: ITodoLocalDataSource)
class TodoLocalDataSource implements ITodoLocalDataSource {
  TodoLocalDataSource({required IPreferencesStore store}) : _store = store;

  /// Under [SessionScope.keyPrefix]: sign-out removes every key with that
  /// prefix, so the next user can never be served this user's to-dos.
  static const String storageKey = '${SessionScope.keyPrefix}todo.first_page';

  final IPreferencesStore _store;

  @override
  Future<PageResult<TodoModel>?> getFirstPage({
    required TodoQuery query,
    required int limit,
  }) async {
    final raw = _store.getString(key: storageKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      if (json['search'] != query.search ||
          json['only_open'] != query.onlyOpen ||
          json['limit'] != limit) {
        return null;
      }
      return PageResult(
        items: [
          for (final item in json['items'] as List<dynamic>)
            TodoModel.fromJson(item as Map<String, dynamic>),
        ],
        hasMore: json['has_more'] as bool,
        nextCursor: json['next_cursor'] as String?,
      );
    } on FormatException catch (error, stackTrace) {
      return _discardCorrupt(error, stackTrace);
    } on TypeError catch (error, stackTrace) {
      return _discardCorrupt(error, stackTrace);
    }
  }

  @override
  Future<void> saveFirstPage({
    required TodoQuery query,
    required int limit,
    required PageResult<TodoModel> result,
  }) => _store.setString(
    key: storageKey,
    value: jsonEncode({
      'search': query.search,
      'only_open': query.onlyOpen,
      'limit': limit,
      'items': [for (final item in result.items) item.toJson()],
      'has_more': result.hasMore,
      'next_cursor': result.nextCursor,
    }),
  );

  @override
  Future<void> clear() => _store.remove(key: storageKey);

  /// A corrupt entry can never be read again, so it is removed (the next
  /// successful load rewrites it) and reported as a miss.
  Future<PageResult<TodoModel>?> _discardCorrupt(
    Object error,
    StackTrace stackTrace,
  ) async {
    AppLogger.warning(
      'Discarding unreadable to-do cache',
      error: error,
      stackTrace: stackTrace,
      name: 'TodoLocalDataSource',
    );
    await _store.remove(key: storageKey);
    return null;
  }
}
