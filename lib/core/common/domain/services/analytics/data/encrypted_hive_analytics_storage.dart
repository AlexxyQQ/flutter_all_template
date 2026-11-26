import 'package:injectable/injectable.dart';

import '../../../../../storage/encrypted_hive_store.dart';
import '../domain/analytics_storage.dart';

/// [IAnalyticsStorage] backed by the app's [EncryptedHiveStore], so queued
/// events and the analytics identity are encrypted at rest.
@LazySingleton(as: IAnalyticsStorage)
class EncryptedHiveAnalyticsStorage implements IAnalyticsStorage {
  EncryptedHiveAnalyticsStorage({required EncryptedHiveStore store})
    : _store = store;

  final EncryptedHiveStore _store;

  @override
  Future<String?> read({required String key}) => _store.read(key: key);

  @override
  Future<void> write({required String key, required String value}) =>
      _store.write(key: key, value: value);

  @override
  Future<void> delete({required String key}) => _store.delete(key: key);

  @override
  Future<List<String>> keys() => _store.keys();
}
