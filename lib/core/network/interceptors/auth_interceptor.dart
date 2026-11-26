import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../session/session.dart';
import '../network_constants.dart';

/// Attaches `Authorization: Bearer <access token>` **only** to requests whose
/// URL matches the API base URL (scheme + host + port). Requests to any other
/// host never receive the token.
@lazySingleton
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.sessionManager,
    required TokenStore tokenStore,
    @Named(NetworkNames.apiBaseUrl) required String baseUrl,
  }) : _tokenStore = tokenStore,
       _hostMatcher = ApiHostMatcher(baseUrl: baseUrl);

  static const identityKey = 'auth.sessionIdentity';
  final SessionManager sessionManager;
  final TokenStore _tokenStore;
  final ApiHostMatcher _hostMatcher;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.extra.remove(identityKey);
    final skip = options.extra[RequestExtras.skipAuth] == true;
    if (!skip &&
        _hostMatcher.matches(options.uri) &&
        !options.headers.containsKey('Authorization')) {
      try {
        final identity = sessionManager.identity;
        final tokens = await _tokenStore.read();
        if (tokens != null &&
            tokens.accessToken.isNotEmpty &&
            identical(identity, sessionManager.identity)) {
          if (identity != null) {
            options.extra[identityKey] = identity;
          }
          options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
        }
      } catch (_) {
        // Token storage failure: send the request unauthenticated; the
        // server's 401 is handled by RefreshTokenInterceptor/ApiClient.
      }
    }
    handler.next(options);
  }
}
