/// DI instance names used by the network layer.
abstract final class NetworkNames {
  /// The API base URL (`AppEnv.baseUrl`), injectable so tests can override it.
  static const String apiBaseUrl = 'apiBaseUrl';

  /// A bare Dio (no auth/refresh interceptors) used for token refresh and for
  /// retrying the original request after a refresh.
  static const String refreshDio = 'refreshDio';
}

/// Keys for `RequestOptions.extra`.
abstract final class RequestExtras {
  /// Set to `true` to never attach the bearer token to this request.
  static const String skipAuth = 'skipAuth';

  /// Internal: set on the token-refresh request so it is never itself
  /// refreshed.
  static const String isRefreshRequest = 'isRefreshRequest';

  /// Internal: marks a request already retried after a token refresh.
  static const String retried = 'authRetried';

  /// Internal: the `ISessionAuthority.generation` whose token this request
  /// carries. Absent when no token was attached.
  static const String sessionGeneration = 'sessionGeneration';
}

/// The `Authorization: Bearer <token>` header, in one place.
abstract final class AuthHeader {
  static const String name = 'Authorization';
  static const String _scheme = 'Bearer ';

  static String bearer({required String token}) => '$_scheme$token';

  /// The token of the request's bearer header, or `null` if it has none.
  static String? tokenOf({required Map<String, Object?> headers}) {
    final value = headers[name];
    if (value is String && value.startsWith(_scheme)) {
      return value.substring(_scheme.length);
    }
    return null;
  }
}

/// Decides whether a request targets the configured API host.
///
/// Credentials are only ever attached to / refreshed for requests where
/// scheme, host and port all match the base URL (fixes token leakage to
/// third-party hosts).
final class ApiHostMatcher {
  ApiHostMatcher({required String baseUrl})
    : _base = baseUrl.trim().isEmpty ? null : Uri.tryParse(baseUrl.trim());

  final Uri? _base;

  bool matches(Uri uri) {
    final base = _base;
    if (base == null || base.host.isEmpty) {
      return false;
    }
    return uri.scheme.toLowerCase() == base.scheme.toLowerCase() &&
        uri.host.toLowerCase() == base.host.toLowerCase() &&
        uri.port == base.port;
  }
}
