import 'package:dio/dio.dart';
import 'package:flutter_all_template/core/network/interceptors/auth_interceptor.dart';
import 'package:flutter_all_template/core/network/network_constants.dart';
import 'package:flutter_all_template/core/session/session.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers/fake_http_adapter.dart';

class _MockTokenStore extends Mock implements TokenStore {}

class _MockSession extends Mock implements SessionManager {}

void main() {
  late FakeHttpAdapter adapter;
  late Dio dio;

  setUp(() {
    final tokenStore = _MockTokenStore();
    when(
      tokenStore.read,
    ).thenAnswer((_) async => const AuthTokens(accessToken: 'secret-token'));
    adapter = FakeHttpAdapter((_) async => jsonBody({}, 200));
    dio = Dio(BaseOptions(baseUrl: 'https://api.example.com/v1/'))
      ..httpClientAdapter = adapter
      ..interceptors.add(
        AuthInterceptor(
          sessionManager: _MockSession(),
          tokenStore: tokenStore,
          baseUrl: 'https://api.example.com/v1/',
        ),
      );
  });

  String? authHeaderOfLastRequest() =>
      adapter.requests.last.headers['Authorization'] as String?;

  test('attaches the bearer token for the API host', () async {
    await dio.get<Object?>('users/me');
    expect(authHeaderOfLastRequest(), 'Bearer secret-token');
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

  test('never attaches a token when no base URL is configured', () {
    expect(
      ApiHostMatcher(baseUrl: '').matches(Uri.parse('https://api.example.com')),
      isFalse,
    );
  });
}
