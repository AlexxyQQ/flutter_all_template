import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../config/constants/api/api_constants.dart';
import '../../common/domain/services/logger/logger_service.dart';
import '../../error/app_exception.dart';
import '../../session/session.dart';
import '../network_constants.dart';
import '../token_refresher.dart';

/// Handles `401` responses from the API host:
///
/// 1. Refreshes the token pair **once** even if many requests fail at the
///    same time (`QueuedInterceptor` serialises `onError`, and requests that
///    were sent with an outdated token reuse the already-refreshed token).
/// 2. Retries the original request once with the new token, using a separate
///    Dio without these interceptors (no recursion / deadlock).
/// 3. If the refresh fails, signs the user out and rejects with
///    [UnauthorizedException].
@lazySingleton
class RefreshTokenInterceptor extends QueuedInterceptor {
  RefreshTokenInterceptor(
    this._tokenStore,
    this._sessionManager,
    this._refresher,
    @Named(NetworkNames.refreshDio) this._retryDio,
    @Named(NetworkNames.apiBaseUrl) String baseUrl,
  ) : _hostMatcher = ApiHostMatcher(baseUrl);

  final TokenStore _tokenStore;
  final SessionManager _sessionManager;
  final TokenRefresher _refresher;
  final Dio _retryDio;
  final ApiHostMatcher _hostMatcher;

  Future<AuthTokens?>? _inFlight;

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

    final AuthTokens? current;
    try {
      current = await _tokenStore.read();
    } catch (_) {
      handler.next(err);
      return;
    }
    if (current == null) {
      // Not signed in: a plain 401, nothing to refresh.
      handler.next(err);
      return;
    }

    final sentToken = _bearerOf(options);
    final AuthTokens? fresh =
        sentToken != null && sentToken != current.accessToken
        // Another request already refreshed while this one was in flight.
        ? current
        : await _refreshOnce(current);

    if (fresh == null) {
      await _sessionManager.signOut();
      handler.reject(
        DioException(
          requestOptions: options,
          response: err.response,
          type: DioExceptionType.badResponse,
          error: const UnauthorizedException(
            debugMessage: 'Token refresh failed; signed out',
          ),
        ),
      );
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

  Future<AuthTokens?> _refreshOnce(AuthTokens current) {
    return _inFlight ??= _refresh(current).whenComplete(() => _inFlight = null);
  }

  Future<AuthTokens?> _refresh(AuthTokens current) async {
    final refreshToken = current.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }
    try {
      final tokens = await _refresher.refresh(refreshToken);
      await _tokenStore.save(tokens);
      return tokens;
    } catch (e) {
      AppLogger.warning(
        'Token refresh failed (${e.runtimeType})',
        name: 'RefreshTokenInterceptor',
      );
      return null;
    }
  }

  static String? _bearerOf(RequestOptions options) {
    final header = options.headers['Authorization'];
    if (header is String && header.startsWith('Bearer ')) {
      return header.substring('Bearer '.length);
    }
    return null;
  }
}
