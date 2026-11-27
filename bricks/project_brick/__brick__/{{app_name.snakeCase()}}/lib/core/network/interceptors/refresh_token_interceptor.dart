import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../error/app_exception.dart';
import '../../session/session.dart';
import '../../session/session_authority.dart';
import '../network_constants.dart';
import '../token_refresher.dart';

/// Handles `401` responses to requests that carried a session token:
///
/// 1. Refreshes the token pair **once** even if many requests fail at the
///    same time (`QueuedInterceptor` serialises `onError`; requests sent with
///    an outdated token just reuse the already-refreshed one).
/// 2. Retries the original request once with the new token, using a separate
///    Dio without these interceptors (no recursion / deadlock).
/// 3. If the refresh credential is rejected, signs the session out and fails
///    the request with [UnauthorizedException].
///
/// Only requests tagged by `AuthInterceptor` are handled, and only while their
/// session is still the current one.
@lazySingleton
class RefreshTokenInterceptor extends QueuedInterceptor {
  RefreshTokenInterceptor({
    required ITokenStore tokenStore,
    required ISessionAuthority authority,
    required ITokenRefresher refresher,
    @Named(NetworkNames.refreshDio) required Dio retryDio,
  }) : _tokenStore = tokenStore,
       _authority = authority,
       _refresher = refresher,
       _retryDio = retryDio;

  final ITokenStore _tokenStore;
  final ISessionAuthority _authority;
  final ITokenRefresher _refresher;
  final Dio _retryDio;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final generation = _refreshableGeneration(err);
    if (generation == null) {
      handler.next(err);
      return;
    }
    try {
      final tokens = await _tokensForRetry(
        options: options,
        generation: generation,
      );
      if (tokens == null) {
        // The session ended or changed meanwhile: a plain 401.
        handler.next(err);
        return;
      }
      options
        ..headers[AuthHeader.name] = AuthHeader.bearer(
          token: tokens.accessToken,
        )
        ..extra[RequestExtras.retried] = true;
      handler.resolve(await _retryDio.fetch<Object?>(options));
    } on DioException catch (e) {
      handler.reject(e);
    } catch (error) {
      handler.reject(DioException(requestOptions: options, error: error));
    }
  }

  /// The session generation to refresh for, or `null` when [err] is not a 401
  /// that refreshing could fix.
  int? _refreshableGeneration(DioException err) {
    final extra = err.requestOptions.extra;
    final generation = extra[RequestExtras.sessionGeneration];
    final handled =
        err.response?.statusCode == 401 &&
        generation is int &&
        generation == _authority.generation &&
        extra[RequestExtras.retried] != true &&
        extra[RequestExtras.isRefreshRequest] != true;
    return handled ? generation : null;
  }

  /// The tokens to retry with, or `null` when the session is gone.
  Future<AuthTokens?> _tokensForRetry({
    required RequestOptions options,
    required int generation,
  }) async {
    final current = await _tokenStore.read();
    if (current == null || generation != _authority.generation) {
      return null;
    }
    final sentToken = AuthHeader.tokenOf(headers: options.headers);
    if (sentToken != current.accessToken) {
      // An earlier queued request already refreshed the pair.
      return current;
    }

    final AuthTokens refreshed;
    try {
      final refreshToken = current.refreshToken;
      if (refreshToken == null || refreshToken.isEmpty) {
        throw const UnauthorizedException();
      }
      refreshed = await _refresher.refresh(refreshToken: refreshToken);
    } on UnauthorizedException {
      await _authority.expire(generation: generation);
      rethrow;
    }
    final saved = await _authority.saveRefreshedTokens(
      generation: generation,
      tokens: refreshed,
    );
    return saved ? refreshed : null;
  }
}
