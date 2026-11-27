/// Encrypted key/value storage (Keychain / Android Keystore-backed).
///
/// Use ONLY for secrets (tokens, credentials, encryption keys). It is slow and
/// size-limited — never use it as a general-purpose database.
/// Implementations must never log values. Failures throw `StorageException`.
abstract interface class ISecureStore {
  Future<String?> read({required String key});
  Future<void> write({required String key, required String value});
  Future<void> delete({required String key});
  Future<void> deleteAll();
}

/// Plain, non-secret preferences (theme, locale, onboarding flags, cached
/// non-sensitive JSON). Values are pre-loaded so reads are synchronous.
/// Failures throw `StorageException`.
///
/// Keys that belong to the signed-in user must start with
/// `SessionScope.keyPrefix`; they are removed on sign-out.
abstract interface class IPreferencesStore {
  /// `null` when the key is absent or holds a value of another type.
  String? getString({required String key});
  Future<void> setString({required String key, required String value});

  /// `null` when the key is absent or holds a value of another type.
  bool? getBool({required String key});
  Future<void> setBool({required String key, required bool value});

  Future<void> remove({required String key});

  /// Removes every key that starts with [prefix].
  Future<void> removeByPrefix({required String prefix});

  /// Removes every key owned by the app.
  Future<void> clear();
}
