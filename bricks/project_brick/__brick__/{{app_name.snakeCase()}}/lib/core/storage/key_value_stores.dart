/// Encrypted key/value storage (Keychain / Android Keystore-backed).
///
/// Use ONLY for secrets (tokens, credentials, encryption keys). It is slow and
/// size-limited — never use it as a general-purpose database.
/// Implementations must never log values. Failures throw `StorageException`.
abstract interface class SecureStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
  Future<void> deleteAll();
}

/// Plain, non-secret preferences (theme, locale, onboarding flags, cached
/// non-sensitive JSON). Values are pre-loaded so reads are synchronous.
/// Failures throw `StorageException`.
abstract interface class PreferencesStore {
  String? getString(String key);
  Future<void> setString(String key, String value);

  bool? getBool(String key);
  Future<void> setBool(String key, {required bool value});

  int? getInt(String key);
  Future<void> setInt(String key, int value);

  Future<void> remove(String key);

  /// Removes every key owned by the app.
  Future<void> clear();
}
