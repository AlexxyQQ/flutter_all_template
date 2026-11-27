import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../services/logger/data/app_logger.dart';
import '../../session/session.dart';
import '../../session/session_authority.dart';
import '../network_constants.dart';

/// Attaches `Authorization: Bearer <access token>` **only** to requests whose
/// URL matches the API base URL (scheme + host + port). Requests to any other
/// host never receive the token.
///
/// Also records which session generation the token belongs to
/// ([RequestExtras.sessionGeneration]) so `RefreshTokenInterceptor` can ignore
/// a 401 that arrives after the session changed.
@lazySingleton
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required ISessionAuthority authority,
    required ITokenStore tokenStore,
    @Named(NetworkNames.apiBaseUrl) required String baseUrl,
  }) : _authority = authority,
       _tokenStore = tokenStore,
       _hostMatcher = ApiHostMatcher(baseUrl: baseUrl);

  final ISessionAuthority _authority;
  final ITokenStore _tokenStore;
  final ApiHostMatcher _hostMatcher;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Only this interceptor may say which session a request belongs to.
    options.extra.remove(RequestExtras.sessionGeneration);
    final wantsToken =
        options.extra[RequestExtras.skipAuth] != true &&
        _hostMatcher.matches(options.uri) &&
        !options.headers.containsKey(AuthHeader.name);
    if (wantsToken) {
      await _attachToken(options);
    }
    handler.next(options);
  }

  Future<void> _attachToken(RequestOptions options) async {
    final generation = _authority.generation;
    final AuthTokens? tokens;
    try {
      tokens = await _tokenStore.read();
    } catch (e, s) {
      // Send the request unauthenticated; the server's 401 is then returned to
      // the caller unchanged.
      AppLogger.warning(
        'Could not read tokens; sending request without Authorization',
        error: e,
        stackTrace: s,
        name: 'AuthInterceptor',
      );
      return;
    }
    // A sign-out/sign-in while reading means these tokens may not belong to
    // the current session.
    if (tokens == null ||
        tokens.accessToken.isEmpty ||
        generation != _authority.generation) {
      return;
    }
    options.extra[RequestExtras.sessionGeneration] = generation;
    options.headers[AuthHeader.name] = AuthHeader.bearer(
      token: tokens.accessToken,
    );
  }
}
