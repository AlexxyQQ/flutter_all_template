import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provides the platform storage plugins to DI.
@module
abstract class StorageModule {
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage(
    // Default Android options: AES-GCM data encryption with an RSA-OAEP
    // wrapped key in the Android Keystore. (The deprecated
    // `encryptedSharedPreferences` option is intentionally not used.)
    // iOS: readable after first unlock so background tasks (e.g. push
    // handling, token refresh) can access tokens.
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  /// Preferences are loaded once at startup so reads are synchronous.
  @preResolve
  @singleton
  Future<SharedPreferencesWithCache> get sharedPreferences =>
      SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(),
      );
}
