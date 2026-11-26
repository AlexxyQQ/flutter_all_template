import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../error/app_exception.dart';
import 'key_value_stores.dart';

/// [SecureStore] backed by Keychain (iOS) / Keystore-wrapped AES-GCM (Android).
///
/// Never logs keys' values. Platform errors are wrapped in [StorageException]
/// whose `debugMessage` contains only the operation and key name.
@LazySingleton(as: SecureStore)
class FlutterSecureStore implements SecureStore {
  FlutterSecureStore({required FlutterSecureStorage storage})
    : _storage = storage;

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) =>
      _guard('read', key, () => _storage.read(key: key));

  @override
  Future<void> write(String key, String value) =>
      _guard('write', key, () => _storage.write(key: key, value: value));

  @override
  Future<void> delete(String key) =>
      _guard('delete', key, () => _storage.delete(key: key));

  @override
  Future<void> deleteAll() =>
      _guard('deleteAll', null, () => _storage.deleteAll());

  Future<T> _guard<T>(
    String operation,
    String? key,
    Future<T> Function() body,
  ) async {
    try {
      return await body();
    } catch (e) {
      throw StorageException(
        debugMessage:
            'SecureStore.$operation${key == null ? '' : '($key)'} failed '
            '(${e.runtimeType})',
        cause: e,
      );
    }
  }
}
