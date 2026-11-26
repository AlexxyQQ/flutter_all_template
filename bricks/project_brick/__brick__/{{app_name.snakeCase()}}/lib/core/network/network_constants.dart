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

  /// Internal: marks a request already retried after a token refresh.
  static const String retried = 'authRetried';
}

/// Decides whether a request targets the configured API host.
///
/// Credentials are only ever attached to / refreshed for requests where
/// scheme, host and port all match the base URL (fixes token leakage to
/// third-party hosts).
final class ApiHostMatcher {
  ApiHostMatcher(String baseUrl)
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
