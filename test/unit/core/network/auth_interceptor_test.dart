import 'package:dio/dio.dart';
import 'package:flutter_all_template/core/network/interceptors/auth_interceptor.dart';
import 'package:flutter_all_template/core/network/network_constants.dart';
import 'package:flutter_all_template/core/services/logger/data/app_logger.dart';
import 'package:flutter_all_template/core/session/session.dart';
import 'package:flutter_all_template/core/session/session_authority.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers/fake_http_adapter.dart';

class _MockTokenStore extends Mock implements ITokenStore {}

class _FakeAuthority implements ISessionAuthority {
  @override
  int generation = 7;

  @override
  Future<bool> saveRefreshedTokens({
    required int generation,
    required AuthTokens tokens,
  }) async => true;

  @override
  Future<void> expire({required int generation}) async {}
}

class _RecordingLogger implements ILoggerService {
  int warnings = 0;

  @override
  void debug(String message, {String? name}) {}

  @override
  void info(String message, {String? name}) {}

  @override
  void warning(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? name,
  }) => warnings++;

  @override
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? name,
  }) {}
}

void main() {
  late FakeHttpAdapter adapter;
  late _MockTokenStore tokenStore;
  late _FakeAuthority authority;
  late Dio dio;

  setUp(() {
    tokenStore = _MockTokenStore();
    authority = _FakeAuthority();
    when(
      tokenStore.read,
    ).thenAnswer((_) async => const AuthTokens(accessToken: 'secret-token'));
    adapter = FakeHttpAdapter((_) async => jsonBody({}, 200));
    dio = Dio(BaseOptions(baseUrl: 'https://api.example.com/v1/'))
      ..httpClientAdapter = adapter
      ..interceptors.add(
        AuthInterceptor(
          authority: authority,
          tokenStore: tokenStore,
          baseUrl: 'https://api.example.com/v1/',
        ),
      );
  });

  String? authHeaderOfLastRequest() =>
      adapter.requests.last.headers[AuthHeader.name] as String?;

  test('attaches the bearer token for the API host', () async {
    await dio.get<Object?>('users/me');
    expect(authHeaderOfLastRequest(), 'Bearer secret-token');
  });

  test('tags the request with the session generation it was sent in', () async {
    await dio.get<Object?>('users/me');
    expect(adapter.requests.last.extra[RequestExtras.sessionGeneration], 7);
  });

  test('ignores a session generation supplied by the caller', () async {
    await dio.get<Object?>(
      'public',
      options: Options(
        extra: {
          RequestExtras.skipAuth: true,
          RequestExtras.sessionGeneration: 7,
        },
      ),
    );
    expect(
      adapter.requests.last.extra.containsKey(RequestExtras.sessionGeneration),
      isFalse,
    );
  });

  test('does NOT send the token to a foreign host', () async {
    await dio.get<Object?>('https://evil.example.org/collect');
    expect(authHeaderOfLastRequest(), isNull);
  });

  test('does NOT send the token to a look-alike subdomain', () async {
    await dio.get<Object?>('https://api.example.com.evil.org/x');
    expect(authHeaderOfLastRequest(), isNull);
  });

  test('does NOT send the token over a different scheme or port', () async {
    await dio.get<Object?>('http://api.example.com/v1/x');
    expect(authHeaderOfLastRequest(), isNull);
    await dio.get<Object?>('https://api.example.com:8443/v1/x');
    expect(authHeaderOfLastRequest(), isNull);
  });

  test('skipAuth extra suppresses the token', () async {
    await dio.get<Object?>(
      'public',
      options: Options(extra: {RequestExtras.skipAuth: true}),
    );
    expect(authHeaderOfLastRequest(), isNull);
  });

  test('sends no token when signed out', () async {
    when(tokenStore.read).thenAnswer((_) async => null);
    await dio.get<Object?>('users/me');
    expect(authHeaderOfLastRequest(), isNull);
  });

  test('sends no token when the session changed while reading', () async {
    when(tokenStore.read).thenAnswer((_) async {
      authority.generation++;
      return const AuthTokens(accessToken: 'old-session');
    });
    await dio.get<Object?>('users/me');
    expect(authHeaderOfLastRequest(), isNull);
  });

  test('a token storage failure is logged and the request goes out', () async {
    final logger = _RecordingLogger();
    AppLogger.configure(logger);
    when(tokenStore.read).thenThrow(Exception('keystore'));

    await dio.get<Object?>('users/me');

    expect(authHeaderOfLastRequest(), isNull);
    expect(logger.warnings, 1);
  });

  test('never attaches a token when no base URL is configured', () {
    expect(
      ApiHostMatcher(baseUrl: '').matches(Uri.parse('https://api.example.com')),
      isFalse,
    );
  });
}
