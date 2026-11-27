import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'encrypted_hive_store.dart';
import 'flutter_secure_store.dart';
import 'key_value_stores.dart';

/// Provides the platform storage plugins to DI.
@module
abstract class StorageModule {
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage(
    // Default Android options: AES-GCM data encryption with an RSA-OAEP
    // wrapped key in the Android Keystore. (The deprecated
    // `encryptedSharedPreferences` option is intentionally not used.)
    iOptions: IOSOptions(accessibility: FlutterSecureStore.accessibility),
    mOptions: MacOsOptions(accessibility: FlutterSecureStore.accessibility),
  );

  /// Hive's separate key vault remains available across session resets.
  @Named(EncryptedHiveStore.keyVaultName)
  @lazySingleton
  FlutterSecureStorage get hiveKeyVaultStorage => const FlutterSecureStorage(
    aOptions: AndroidOptions(
      resetOnError: false,
      storageNamespace: 'encrypted_hive',
    ),
    iOptions: IOSOptions(
      accountName: 'encrypted_hive',
      accessibility: FlutterSecureStore.accessibility,
    ),
    mOptions: MacOsOptions(
      accountName: 'encrypted_hive',
      accessibility: FlutterSecureStore.accessibility,
    ),
  );

  @Named(EncryptedHiveStore.keyVaultName)
  @lazySingleton
  ISecureStore hiveKeyVault(
    @Named(EncryptedHiveStore.keyVaultName) FlutterSecureStorage storage,
  ) => FlutterSecureStore(storage: storage);

  /// Preferences are loaded once at startup so reads are synchronous.
  @preResolve
  @singleton
  Future<SharedPreferencesWithCache> get sharedPreferences =>
      SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(),
      );
}
