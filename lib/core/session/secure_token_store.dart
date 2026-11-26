import 'package:injectable/injectable.dart';

import '../storage/key_value_stores.dart';
import 'session.dart';

/// [TokenStore] persisting each token under its own [SecureStore] key.
///
/// Keeps an in-memory copy after the first read so the auth interceptor does
/// not hit the Keychain/Keystore on every request.
@LazySingleton(as: TokenStore)
class SecureTokenStore implements TokenStore {
  SecureTokenStore(this._secureStore);

  static const String accessTokenKey = 'auth.access_token';
  static const String refreshTokenKey = 'auth.refresh_token';

  final SecureStore _secureStore;

  AuthTokens? _cache;
  bool _loaded = false;

  @override
  Future<AuthTokens?> read() async {
    if (_loaded) {
      return _cache;
    }
    final access = await _secureStore.read(accessTokenKey);
    final refresh = await _secureStore.read(refreshTokenKey);
    _cache = access == null || access.isEmpty
        ? null
        : AuthTokens(accessToken: access, refreshToken: refresh);
    _loaded = true;
    return _cache;
  }

  @override
  Future<void> save(AuthTokens tokens) async {
    // Invalidate first so a failed write never leaves a stale cache.
    _loaded = false;
    await _secureStore.write(accessTokenKey, tokens.accessToken);
    final refresh = tokens.refreshToken;
    if (refresh == null) {
      await _secureStore.delete(refreshTokenKey);
    } else {
      await _secureStore.write(refreshTokenKey, refresh);
    }
    _cache = tokens;
    _loaded = true;
  }

  @override
  Future<void> clear() async {
    _cache = null;
    _loaded = true;
    await _secureStore.delete(accessTokenKey);
    await _secureStore.delete(refreshTokenKey);
  }
}
