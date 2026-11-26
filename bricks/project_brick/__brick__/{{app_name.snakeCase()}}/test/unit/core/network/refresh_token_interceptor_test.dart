import 'package:dio/dio.dart';
import 'package:flutter_all_template/core/error/app_exception.dart';
import 'package:flutter_all_template/core/network/api_client.dart';
import 'package:flutter_all_template/core/network/dio_api_client.dart';
import 'package:flutter_all_template/core/network/interceptors/auth_interceptor.dart';
import 'package:flutter_all_template/core/network/interceptors/refresh_token_interceptor.dart';
import 'package:flutter_all_template/core/network/token_refresher.dart';
import 'package:flutter_all_template/core/session/session.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers/fake_http_adapter.dart';

class _MockSessionManager extends Mock implements SessionManager {}

class _MockRefresher extends Mock implements TokenRefresher {}

class _InMemoryTokenStore implements TokenStore {
  _InMemoryTokenStore(this.tokens);

  AuthTokens? tokens;

  @override
  Future<AuthTokens?> read() async => tokens;

  @override
  Future<void> save({required AuthTokens tokens}) async => this.tokens = tokens;

  @override
  Future<void> clear() async => tokens = null;
}

const _baseUrl = 'https://api.example.com/';

void main() {
  late FakeHttpAdapter adapter;
  late _InMemoryTokenStore tokenStore;
  late _MockSessionManager sessionManager;
  late _MockRefresher refresher;
  late ApiClient client;

  setUp(() {
    // Only the "new" token is accepted by the fake server.
    adapter = FakeHttpAdapter((options) async {
      final auth = options.headers['Authorization'];
      return auth == 'Bearer new'
          ? jsonBody({'ok': true}, 200)
          : jsonBody({'message': 'expired'}, 401);
    });
    tokenStore = _InMemoryTokenStore(
      const AuthTokens(accessToken: 'old', refreshToken: 'r1'),
    );
    sessionManager = _MockSessionManager();
    when(sessionManager.signOut).thenAnswer((_) async {});
    refresher = _MockRefresher();

    final retryDio = Dio(BaseOptions(baseUrl: _baseUrl))
      ..httpClientAdapter = adapter;
    final dio = Dio(BaseOptions(baseUrl: _baseUrl))
      ..httpClientAdapter = adapter
      ..interceptors.addAll([
        AuthInterceptor(tokenStore: tokenStore, baseUrl: _baseUrl),
        RefreshTokenInterceptor(
          tokenStore: tokenStore,
          sessionManager: sessionManager,
          refresher: refresher,
          retryDio: retryDio,
          baseUrl: _baseUrl,
        ),
      ]);
    client = DioApiClient(dio: dio);
  });

  test('refreshes once for concurrent 401s and retries each request', () async {
    when(() => refresher.refresh(refreshToken: 'r1')).thenAnswer((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 20));
      return const AuthTokens(accessToken: 'new', refreshToken: 'r2');
    });

    final results = await Future.wait([
      for (var i = 0; i < 3; i++)
        client.get('items/$i', decode: Decoders.object),
    ]);

    expect(results, everyElement({'ok': true}));
    verify(() => refresher.refresh(refreshToken: 'r1')).called(1);
    expect(tokenStore.tokens?.accessToken, 'new');
    expect(tokenStore.tokens?.refreshToken, 'r2');
    verifyNever(sessionManager.signOut);
  });

  test('refresh failure signs out and throws UnauthorizedException', () async {
    when(
      () => refresher.refresh(refreshToken: any(named: 'refreshToken')),
    ).thenThrow(const UnauthorizedException());

    await expectLater(
      client.get('items', decode: Decoders.object),
      throwsA(isA<UnauthorizedException>()),
    );
    verify(sessionManager.signOut).called(1);
  });

  test('no refresh token -> sign out without calling the refresher', () async {
    tokenStore.tokens = const AuthTokens(accessToken: 'old');

    await expectLater(
      client.get('items', decode: Decoders.object),
      throwsA(isA<UnauthorizedException>()),
    );
    verifyNever(
      () => refresher.refresh(refreshToken: any(named: 'refreshToken')),
    );
    verify(sessionManager.signOut).called(1);
  });

  test('signed-out user gets a plain UnauthorizedException', () async {
    tokenStore.tokens = null;

    await expectLater(
      client.get('items', decode: Decoders.object),
      throwsA(isA<UnauthorizedException>()),
    );
    verifyNever(
      () => refresher.refresh(refreshToken: any(named: 'refreshToken')),
    );
    verifyNever(sessionManager.signOut);
  });

  test('401 from a foreign host is not refreshed', () async {
    await expectLater(
      client.get('https://other.example.org/x', decode: Decoders.object),
      throwsA(isA<UnauthorizedException>()),
    );
    verifyNever(
      () => refresher.refresh(refreshToken: any(named: 'refreshToken')),
    );
  });
}
