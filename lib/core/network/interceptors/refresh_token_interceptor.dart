import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../config/constants/api/api_constants.dart';
import '../../error/app_exception.dart';
import '../../session/session.dart';
import '../network_constants.dart';
import '../token_refresher.dart';
import 'auth_interceptor.dart';

/// Handles `401` responses from the API host:
///
/// 1. Refreshes the token pair **once** even if many requests fail at the
///    same time (`QueuedInterceptor` serialises `onError`, and requests that
///    were sent with an outdated token reuse the already-refreshed token).
/// 2. Retries the original request once with the new token, using a separate
///    Dio without these interceptors (no recursion / deadlock).
/// 3. If the refresh credential expires, signs the originating session out with
///    [UnauthorizedException].
@lazySingleton
class RefreshTokenInterceptor extends QueuedInterceptor {
  RefreshTokenInterceptor({
    required TokenStore tokenStore,
    required SessionManager sessionManager,
    required TokenRefresher refresher,
    @Named(NetworkNames.refreshDio) required Dio retryDio,
    @Named(NetworkNames.apiBaseUrl) required String baseUrl,
  }) : _tokenStore = tokenStore,
       _sessionManager = sessionManager,
       _refresher = refresher,
       _retryDio = retryDio,
       _hostMatcher = ApiHostMatcher(baseUrl: baseUrl);

  final TokenStore _tokenStore;
  final SessionManager _sessionManager;
  final TokenRefresher _refresher;
  final Dio _retryDio;
  final ApiHostMatcher _hostMatcher;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    if (!_shouldHandle(err)) {
      handler.next(err);
      return;
    }

    final Object? identity = options.extra[AuthInterceptor.identityKey];
    if (identity == null || !identical(identity, _sessionManager.identity)) {
      handler.next(err);
      return;
    }
    final AuthTokens? current;
    try {
      current = await _tokenStore.read();
    } catch (_) {
      handler.next(err);
      return;
    }
    if (current == null || !identical(identity, _sessionManager.identity)) {
      // Not signed in: a plain 401, nothing to refresh.
      handler.next(err);
      return;
    }

    final sentToken = _bearerOf(options);
    var fresh = current;
    try {
      if (sentToken == current.accessToken) {
        final refresh = current.refreshToken;
        if (refresh == null || refresh.isEmpty) {
          throw const UnauthorizedException();
        }
        fresh = await _refresher.refresh(refreshToken: refresh);
        if (!await _sessionManager.saveRefresh(identity, fresh)) {
          handler.next(err);
          return;
        }
      }
    } catch (error) {
      if (error is UnauthorizedException) {
        try {
          await _sessionManager.expire(identity);
        } catch (storageError) {
          handler.reject(
            DioException(requestOptions: options, error: storageError),
          );
          return;
        }
      }
      handler.reject(DioException(requestOptions: options, error: error));
      return;
    }
    if (!identical(identity, _sessionManager.identity)) {
      handler.next(err);
      return;
    }
    options
      ..headers['Authorization'] = 'Bearer ${fresh.accessToken}'
      ..extra[RequestExtras.retried] = true;
    try {
      handler.resolve(await _retryDio.fetch<Object?>(options));
    } on DioException catch (e) {
      handler.reject(e);
    }
  }

  bool _shouldHandle(DioException err) {
    final options = err.requestOptions;
    return err.response?.statusCode == 401 &&
        _hostMatcher.matches(options.uri) &&
        options.extra[RequestExtras.skipAuth] != true &&
        options.extra[RequestExtras.retried] != true &&
        !options.uri.path.endsWith(ApiConstants.refreshTokenPath);
  }

  static String? _bearerOf(RequestOptions options) {
    final header = options.headers['Authorization'];
    if (header is String && header.startsWith('Bearer ')) {
      return header.substring('Bearer '.length);
    }
    return null;
  }
}
