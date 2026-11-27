import 'dart:convert';

import '../../error/app_exception.dart';
import '../../storage/key_value_stores.dart';
import 'async_lock.dart';

/// A small, id-keyed collection of JSON objects persisted under a single
/// [IPreferencesStore] key.
///
/// Meant for **non-secret, small** offline caches (a few hundred items at
/// most), e.g. the last fetched page of a list. For large or queryable data
/// use a real database (drift/sqflite); for secrets use `ISecureStore`.
///
/// Store **user-owned** data under a key starting with `SessionScope.keyPrefix`
/// so sign-out wipes it.
///
/// * Items are identified by [idOf], so lookups/updates/deletes can never hit
///   the wrong item (no hand-written predicates).
/// * Every operation runs under an [AsyncLock], so concurrent writes can't
///   lose each other's changes.
/// * Errors are thrown as [AppException]s: [StorageException] for unreadable
///   data or store failures, [CacheMissException] for unknown ids. Stored
///   values are never included in exception messages.
class JsonCollectionStore<T> {
  JsonCollectionStore({
    required IPreferencesStore store,
    required this.key,
    required this.idOf,
    required this.toJson,
    required this.fromJson,
  }) : _store = store;

  final IPreferencesStore _store;
  final AsyncLock _lock = AsyncLock();

  /// The preferences key the collection is stored under.
  final String key;
  final String Function(T item) idOf;
  final Map<String, dynamic> Function(T item) toJson;
  final T Function(Map<String, dynamic> json) fromJson;

  /// All items, in insertion order. Empty if nothing was stored yet.
  Future<List<T>> readAll() =>
      _lock.synchronized(() => _read().values.toList());

  /// The item with [id]. Throws [CacheMissException] if absent.
  Future<T> read({required String id}) => _lock.synchronized(() {
    final item = _read()[id];
    if (item == null) {
      throw CacheMissException(debugMessage: '$key: no item with requested id');
    }
    return item;
  });

  /// Inserts [item], or replaces the stored item with the same id.
  Future<void> upsert({required T item}) => upsertAll(items: [item]);

  /// Inserts or replaces every item of [items] in one write.
  Future<void> upsertAll({required Iterable<T> items}) =>
      _lock.synchronized(() async {
        final current = _read();
        for (final item in items) {
          current[idOf(item)] = item;
        }
        await _write(current);
      });

  /// Replaces the whole collection with [items].
  Future<void> replaceAll({required Iterable<T> items}) => _lock.synchronized(
    () => _write({for (final item in items) idOf(item): item}),
  );

  /// Removes the item with [id]. Returns `false` if it wasn't stored.
  Future<bool> delete({required String id}) => _lock.synchronized(() async {
    final current = _read();
    if (current.remove(id) == null) {
      return false;
    }
    await _write(current);
    return true;
  });

  /// Removes the whole collection.
  Future<void> clear() => _lock.synchronized(() => _store.remove(key: key));

  // Must only be called while holding [_lock].
  Map<String, T> _read() {
    final raw = _store.getString(key: key);
    if (raw == null || raw.isEmpty) {
      return {};
    }
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final items = decoded.map((e) => fromJson(e as Map<String, dynamic>));
      return {for (final item in items) idOf(item): item};
    } on FormatException catch (e) {
      throw _unreadable(e);
    } on TypeError catch (e) {
      throw _unreadable(e);
    }
  }

  // Must only be called while holding [_lock].
  Future<void> _write(Map<String, T> items) {
    final String encoded;
    try {
      encoded = jsonEncode(items.values.map(toJson).toList());
    } on JsonUnsupportedObjectError catch (e) {
      throw StorageException(
        debugMessage: '$key: item could not be encoded',
        cause: e,
      );
    }
    return _store.setString(key: key, value: encoded);
  }

  // Never put the raw value in the message: it may contain user data. The
  // cause (a decoder error) is kept for the logs.
  StorageException _unreadable(Object cause) => StorageException(
    debugMessage: '$key: stored collection is unreadable',
    cause: cause,
  );
}
