import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../error/app_exception.dart';
import 'key_value_stores.dart';

/// [ISecureStore] backed by Keychain (iOS) / Keystore-wrapped AES-GCM (Android).
///
/// Never logs keys' values. Platform errors are wrapped in [StorageException]
/// whose `debugMessage` contains only the operation and key name.
@LazySingleton(as: ISecureStore)
class FlutterSecureStore implements ISecureStore {
  FlutterSecureStore({required FlutterSecureStorage storage})
    : _storage = storage;

  /// Keychain accessibility for every secure store: readable after the first
  /// unlock (so background tasks such as push handling can use tokens) and
  /// never migrated to another device through backups.
  static const KeychainAccessibility accessibility =
      KeychainAccessibility.first_unlock_this_device;

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read({required String key}) =>
      _guard('read', key, () => _storage.read(key: key));

  @override
  Future<void> write({required String key, required String value}) =>
      _guard('write', key, () => _storage.write(key: key, value: value));

  @override
  Future<void> delete({required String key}) =>
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
    } catch (e, s) {
      // Keep the platform error as `cause` and its stack as the stack.
      Error.throwWithStackTrace(
        StorageException(
          debugMessage:
              'ISecureStore.$operation${key == null ? '' : '($key)'} failed '
              '(${e.runtimeType})',
          cause: e,
        ),
        s,
      );
    }
  }
}
