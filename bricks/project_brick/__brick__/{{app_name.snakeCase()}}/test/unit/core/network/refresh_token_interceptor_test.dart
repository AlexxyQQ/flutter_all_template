import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_all_template/core/error/app_exception.dart';
import 'package:flutter_all_template/core/network/api_client.dart';
import 'package:flutter_all_template/core/network/dio_api_client.dart';
import 'package:flutter_all_template/core/network/interceptors/auth_interceptor.dart';
import 'package:flutter_all_template/core/network/interceptors/refresh_token_interceptor.dart';
import 'package:flutter_all_template/core/network/network_constants.dart';
import 'package:flutter_all_template/core/network/token_refresher.dart';
import 'package:flutter_all_template/core/session/session.dart';
import 'package:flutter_all_template/core/session/session_manager_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/in_memory_preferences_store.dart';
import 'helpers/fake_http_adapter.dart';

class _MockRefresher extends Mock implements ITokenRefresher {}

class _InMemoryTokenStore implements ITokenStore {
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
  late SessionManagerImpl sessionManager;
  late _MockRefresher refresher;
  late IApiClient client;

  Future<void> Function()? beforeResponse;

  setUp(() {
    beforeResponse = null;
    // Only the "new" token is accepted by the fake server.
    adapter = FakeHttpAdapter((options) async {
      await beforeResponse?.call();
      final auth = options.headers[AuthHeader.name];
      return auth == 'Bearer new'
          ? jsonBody({'ok': true}, 200)
          : jsonBody({'message': 'expired'}, 401);
    });
    tokenStore = _InMemoryTokenStore(
      const AuthTokens(accessToken: 'old', refreshToken: 'r1'),
    );
    sessionManager = SessionManagerImpl(
      tokenStore: tokenStore,
      preferences: InMemoryPreferencesStore(),
    );
    addTearDown(sessionManager.dispose);
    refresher = _MockRefresher();

    final retryDio = Dio(BaseOptions(baseUrl: _baseUrl))
      ..httpClientAdapter = adapter;
    final dio = Dio(BaseOptions(baseUrl: _baseUrl))
      ..httpClientAdapter = adapter
      ..interceptors.addAll([
        AuthInterceptor(
          authority: sessionManager,
          tokenStore: tokenStore,
          baseUrl: _baseUrl,
        ),
        RefreshTokenInterceptor(
          tokenStore: tokenStore,
          authority: sessionManager,
          refresher: refresher,
          retryDio: retryDio,
        ),
      ]);
    client = DioApiClient(dio: dio);
  });

  test('refreshes once for concurrent 401s and retries each request', () async {
    final refreshStarted = Completer<void>();
    final refreshGate = Completer<AuthTokens>();
    when(() => refresher.refresh(refreshToken: 'r1')).thenAnswer((_) {
      refreshStarted.complete();
      return refreshGate.future;
    });

    final results = Future.wait([
      for (var i = 0; i < 3; i++)
        client.get('items/$i', decode: Decoders.object),
    ]);
    // Hold the refresh until every request had the chance to fail with 401.
    await refreshStarted.future;
    await pumpEventQueue();
    refreshGate.complete(
      const AuthTokens(accessToken: 'new', refreshToken: 'r2'),
    );

    expect(await results, everyElement({'ok': true}));
    verify(() => refresher.refresh(refreshToken: 'r1')).called(1);
    expect(tokenStore.tokens?.accessToken, 'new');
    expect(tokenStore.tokens?.refreshToken, 'r2');
  });

  test('late 401 never replays under a replacement account', () async {
    final sent = Completer<void>();
    final release = Completer<void>();
    beforeResponse = () {
      if (!sent.isCompleted) {
        sent.complete();
      }
      return release.future;
    };
    final request = expectLater(
      client.get('items', decode: Decoders.object),
      throwsA(isA<UnauthorizedException>()),
    );
    await sent.future;
    await sessionManager.signIn(tokens: const AuthTokens(accessToken: 'new'));
    release.complete();
    await request;
    expect(adapter.requests, hasLength(1));
    verifyNever(
      () => refresher.refresh(refreshToken: any(named: 'refreshToken')),
    );
  });

  for (final rejected in [true, false]) {
    test(
      'account switch during refresh preserves new session (rejected=$rejected)',
      () async {
        final started = Completer<void>();
        final result = Completer<AuthTokens>();
        when(() => refresher.refresh(refreshToken: 'r1')).thenAnswer((_) {
          started.complete();
          return result.future;
        });
        final request = expectLater(
          client.get('items', decode: Decoders.object),
          throwsA(isA<UnauthorizedException>()),
        );
        await started.future;
        await sessionManager.signIn(
          tokens: const AuthTokens(accessToken: 'replacement'),
        );
        if (rejected) {
          result.completeError(const UnauthorizedException());
        } else {
          result.complete(const AuthTokens(accessToken: 'stale'));
        }
        await request;
        expect(tokenStore.tokens?.accessToken, 'replacement');
        expect(sessionManager.status, SessionStatus.authenticated);
        expect(adapter.requests, hasLength(1));
      },
    );
  }

  test('transient refresh failure preserves tokens', () async {
    when(
      () => refresher.refresh(refreshToken: 'r1'),
    ).thenThrow(const NetworkException());
    await expectLater(
      client.get('items', decode: Decoders.object),
      throwsA(isA<NetworkException>()),
    );
    expect(tokenStore.tokens?.accessToken, 'old');
  });

  test('refresh failure signs out and throws UnauthorizedException', () async {
    when(
      () => refresher.refresh(refreshToken: any(named: 'refreshToken')),
    ).thenThrow(const UnauthorizedException());

    await expectLater(
      client.get('items', decode: Decoders.object),
      throwsA(isA<UnauthorizedException>()),
    );
    expect(sessionManager.status, SessionStatus.unauthenticated);
    expect(tokenStore.tokens, isNull);
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
    expect(sessionManager.status, SessionStatus.unauthenticated);
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

  test('a request marked as the refresh request is never refreshed', () async {
    final dio = Dio(BaseOptions(baseUrl: _baseUrl))
      ..httpClientAdapter = adapter
      ..interceptors.addAll([
        AuthInterceptor(
          authority: sessionManager,
          tokenStore: tokenStore,
          baseUrl: _baseUrl,
        ),
        RefreshTokenInterceptor(
          tokenStore: tokenStore,
          authority: sessionManager,
          refresher: refresher,
          retryDio: Dio(),
        ),
      ]);

    await expectLater(
      dio.post<Object?>(
        'auth/refresh',
        options: Options(extra: {RequestExtras.isRefreshRequest: true}),
      ),
      throwsA(isA<DioException>()),
    );
    verifyNever(
      () => refresher.refresh(refreshToken: any(named: 'refreshToken')),
    );
  });
}
