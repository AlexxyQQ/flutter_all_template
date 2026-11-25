import 'dart:convert';

import '../../error/app_exception.dart';
import '../../storage/key_value_stores.dart';
import 'async_lock.dart';

/// A small, id-keyed collection of JSON objects persisted under a single
/// [PreferencesStore] key.
///
/// Meant for **non-secret, small** offline caches (a few hundred items at
/// most), e.g. the last fetched page of a list. For large or queryable data
/// use a real database (drift/sqflite); for secrets use `SecureStore`.
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
    required PreferencesStore store,
    required this.key,
    required this.idOf,
    required this.toJson,
    required this.fromJson,
  }) : _store = store;

  final PreferencesStore _store;
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
  Future<T> read(String id) => _lock.synchronized(() {
    final item = _read()[id];
    if (item == null) {
      throw CacheMissException(debugMessage: '$key: no item with requested id');
    }
    return item;
  });

  /// Inserts [item], or replaces the stored item with the same id.
  Future<void> upsert(T item) => upsertAll([item]);

  /// Inserts or replaces every item of [items] in one write.
  Future<void> upsertAll(Iterable<T> items) => _lock.synchronized(() async {
    final current = _read();
    for (final item in items) {
      current[idOf(item)] = item;
    }
    await _write(current);
  });

  /// Replaces the whole collection with [items].
  Future<void> replaceAll(Iterable<T> items) => _lock.synchronized(
    () => _write({for (final item in items) idOf(item): item}),
  );

  /// Removes the item with [id]. Returns `false` if it wasn't stored.
  Future<bool> delete(String id) => _lock.synchronized(() async {
    final current = _read();
    if (current.remove(id) == null) {
      return false;
    }
    await _write(current);
    return true;
  });

  /// Removes the whole collection.
  Future<void> clear() => _lock.synchronized(() => _store.remove(key));

  // Must only be called while holding [_lock].
  Map<String, T> _read() {
    final raw = _store.getString(key);
    if (raw == null || raw.isEmpty) {
      return {};
    }
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final items = decoded.map((e) => fromJson(e as Map<String, dynamic>));
      return {for (final item in items) idOf(item): item};
    } catch (e) {
      // Never put the raw value in the message: it may contain user data.
      throw StorageException(
        debugMessage: '$key: stored collection is unreadable',
        cause: e.runtimeType,
      );
    }
  }

  // Must only be called while holding [_lock].
  Future<void> _write(Map<String, T> items) {
    final String encoded;
    try {
      encoded = jsonEncode(items.values.map(toJson).toList());
    } catch (e) {
      throw StorageException(
        debugMessage: '$key: item could not be encoded',
        cause: e.runtimeType,
      );
    }
    return _store.setString(key, encoded);
  }
}
