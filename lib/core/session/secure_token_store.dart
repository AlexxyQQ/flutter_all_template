import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../generic/data/async_lock.dart';
import '../storage/key_value_stores.dart';
import 'session.dart';

/// [ITokenStore] persisting the token pair under one [ISecureStore] key.
///
/// Keeps an in-memory copy after the first read so the auth interceptor does
/// not hit the Keychain/Keystore on every request.
@LazySingleton(as: ITokenStore)
class SecureTokenStore implements ITokenStore {
  SecureTokenStore({required ISecureStore secureStore})
    : _secureStore = secureStore;

  static const String pairKey = 'auth.token_pair';

  final ISecureStore _secureStore;
  final AsyncLock _lock = AsyncLock();

  AuthTokens? _cache;
  bool _loaded = false;

  @override
  Future<AuthTokens?> read() => _lock.synchronized(() async {
    if (_loaded) {
      return _cache;
    }
    final pair = await _secureStore.read(key: pairKey);
    if (pair != null) {
      final data = jsonDecode(pair) as Map<String, dynamic>;
      _cache = AuthTokens(
        accessToken: data['access'] as String,
        refreshToken: data['refresh'] as String?,
      );
    }
    _loaded = true;
    return _cache;
  });

  @override
  Future<void> save({required AuthTokens tokens}) =>
      _lock.synchronized(() async {
        // Drop the cache first so a failed write cannot leave stale tokens.
        _loaded = false;
        await _secureStore.write(
          key: pairKey,
          value: jsonEncode({
            'access': tokens.accessToken,
            'refresh': tokens.refreshToken,
          }),
        );
        _cache = tokens;
        _loaded = true;
      });

  @override
  Future<void> clear() => _lock.synchronized(() async {
    await _secureStore.delete(key: pairKey);
    _cache = null;
    _loaded = true;
  });
}
