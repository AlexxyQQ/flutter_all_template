import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../storage/key_value_stores.dart';
import 'session.dart';

/// [TokenStore] persisting the token pair under one [SecureStore] key.
///
/// Keeps an in-memory copy after the first read so the auth interceptor does
/// not hit the Keychain/Keystore on every request.
@LazySingleton(as: TokenStore)
class SecureTokenStore implements TokenStore {
  SecureTokenStore({required SecureStore secureStore})
    : _secureStore = secureStore;

  static const String accessTokenKey = 'auth.access_token';
  static const String refreshTokenKey = 'auth.refresh_token';

  static const pairKey = 'auth.token_pair';
  final SecureStore _secureStore;

  AuthTokens? _cache;
  bool _loaded = false;

  Future<void> _pending = Future<void>.value();

  Future<T> _serialize<T>(Future<T> Function() action) {
    final result = _pending.then((_) => action());
    _pending = result.then<void>((_) {}, onError: (Object _) {});
    return result;
  }

  @override
  Future<AuthTokens?> read() => _serialize(() async {
    if (_loaded) {
      return _cache;
    }
    final pair = await _secureStore.read(pairKey);
    if (pair != null) {
      final data = jsonDecode(pair) as Map<String, dynamic>;
      _cache = AuthTokens(
        accessToken: data['access'] as String,
        refreshToken: data['refresh'] as String?,
      );
    } else {
      final access = await _secureStore.read(accessTokenKey);
      if (access != null && access.isNotEmpty) {
        final tokens = AuthTokens(
          accessToken: access,
          refreshToken: await _secureStore.read(refreshTokenKey),
        );
        await _write(tokens);
        _cache = tokens;
      }
    }
    _loaded = true;
    return _cache;
  });

  Future<void> _write(AuthTokens tokens) async {
    await _secureStore.write(
      pairKey,
      jsonEncode({
        'access': tokens.accessToken,
        'refresh': tokens.refreshToken,
      }),
    );
    await _secureStore.delete(accessTokenKey);
    await _secureStore.delete(refreshTokenKey);
  }

  @override
  Future<void> save({required AuthTokens tokens}) => _serialize(() async {
    _loaded = false;
    await _write(tokens);
    _cache = tokens;
    _loaded = true;
  });

  @override
  Future<void> clear() => _serialize(() async {
    await _secureStore.delete(accessTokenKey);
    await _secureStore.delete(refreshTokenKey);
    await _secureStore.delete(pairKey);
    _cache = null;
    _loaded = true;
  });
}
