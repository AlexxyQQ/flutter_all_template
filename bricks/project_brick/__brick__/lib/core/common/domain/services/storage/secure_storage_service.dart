import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../logger/logger_service.dart';

class SecureStorageService {
  /// {@macro secure_storage}
  SecureStorageService([FlutterSecureStorage? secureStorage])
    : _secureStorage =
          secureStorage ??
          // This now correctly calls the static method
          FlutterSecureStorage(aOptions: _getAndroidOptions());
  // Made this static so it can be used in the constructor initializer
  static AndroidOptions _getAndroidOptions() =>
      const AndroidOptions(encryptedSharedPreferences: true);

  final FlutterSecureStorage _secureStorage;

  Future<String?> read({required String key}) async {
    try {
      AppLogger.debug('Read: $key', name: 'Secure Storage Service');
      return await _secureStorage.read(key: key);
    } on Exception catch (e, s) {
      AppLogger.error(
        '❌ Failed to Read $key',
        error: e,
        stackTrace: s,
        name: 'Secure Storage Service',
      );
      Error.throwWithStackTrace(e, s);
    }
  }

  Future<void> write({required String key, required String value}) async {
    try {
      AppLogger.debug('Wrote $key: $value', name: 'Secure Storage Service');
      await _secureStorage.write(key: key, value: value);
    } on Exception catch (e, s) {
      AppLogger.error(
        '❌ Failed to Write $key: $value',
        error: e,
        stackTrace: s,
        name: 'Secure Storage Service',
      );
      Error.throwWithStackTrace(e, s);
    }
  }

  Future<void> delete({required String key}) async {
    try {
      AppLogger.debug('Deleted $key', name: 'Secure Storage Service');
      await _secureStorage.delete(key: key);
    } on Exception catch (e, s) {
      AppLogger.error(
        '❌ Failed to delete $key',
        error: e,
        stackTrace: s,
        name: 'Secure Storage Service',
      );
      Error.throwWithStackTrace(e, s);
    }
  }

  Future<void> clear() async {
    try {
      AppLogger.debug('Cleared', name: 'Secure Storage Service');
      await _secureStorage.deleteAll();
    } on Exception catch (e, s) {
      AppLogger.error(
        '❌ Failed to clear',
        error: e,
        stackTrace: s,
        name: 'Secure Storage Service',
      );
      Error.throwWithStackTrace(e, s);
    }
  }
}
