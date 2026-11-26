import 'package:flutter_all_template/core/session/secure_token_store.dart';
import 'package:flutter_all_template/core/session/session.dart';
import 'package:flutter_all_template/core/storage/key_value_stores.dart';
import 'package:flutter_test/flutter_test.dart';

class _InMemorySecureStore implements SecureStore {
  final Map<String, String> values = {};
  int reads = 0;

  @override
  Future<String?> read(String key) async {
    reads++;
    return values[key];
  }

  @override
  Future<void> write(String key, String value) async => values[key] = value;

  @override
  Future<void> delete(String key) async => values.remove(key);

  @override
  Future<void> deleteAll() async => values.clear();
}

void main() {
  late _InMemorySecureStore secure;
  late SecureTokenStore store;

  setUp(() {
    secure = _InMemorySecureStore();
    store = SecureTokenStore(secureStore: secure);
  });

  test('persists the complete pair in one record', () async {
    await store.save(
      tokens: const AuthTokens(accessToken: 'a', refreshToken: 'r'),
    );
    expect(secure.values, {
      SecureTokenStore.pairKey: '{"access":"a","refresh":"r"}',
    });
  });

  test('read returns null when nothing is stored', () async {
    expect(await store.read(), isNull);
  });

  test('read restores tokens from storage and caches them', () async {
    secure.values[SecureTokenStore.accessTokenKey] = 'a';
    secure.values[SecureTokenStore.refreshTokenKey] = 'r';

    final tokens = await store.read();
    await store.read();

    expect(tokens?.accessToken, 'a');
    expect(tokens?.refreshToken, 'r');
    expect(secure.reads, 3);
    expect(secure.values.keys, [SecureTokenStore.pairKey]);
  });

  test('saving without refresh token removes the old one', () async {
    await store.save(
      tokens: const AuthTokens(accessToken: 'a', refreshToken: 'r'),
    );
    await store.save(tokens: const AuthTokens(accessToken: 'b'));
    expect(secure.values.containsKey(SecureTokenStore.refreshTokenKey), false);
    expect((await store.read())?.accessToken, 'b');
  });

  test('clear removes both keys', () async {
    await store.save(
      tokens: const AuthTokens(accessToken: 'a', refreshToken: 'r'),
    );
    await store.clear();
    expect(secure.values, isEmpty);
    expect(await store.read(), isNull);
  });

  test('AuthTokens.toString never prints tokens', () {
    expect(
      const AuthTokens(accessToken: 'secret').toString(),
      isNot(contains('secret')),
    );
  });
}
