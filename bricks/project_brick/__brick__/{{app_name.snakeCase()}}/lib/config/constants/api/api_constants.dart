/// Static, non-secret HTTP configuration shared by the network layer.
///
/// The base URL itself comes from `AppEnv.baseUrl`
/// (`--dart-define-from-file=env/<flavor>.json`).
abstract final class ApiConstants {
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const Map<String, String> defaultHeaders = {
    'Accept': 'application/json',
  };

  /// Endpoint (relative to the base URL) that exchanges a refresh token for a
  /// new token pair. Called by `RefreshTokenInterceptor` via its own Dio.
  static const String refreshTokenPath = 'auth/refresh';

  /// JSON field names used by the refresh endpoint. Adjust to your backend.
  static const String refreshRequestField = 'refresh_token';
  static const String accessTokenField = 'access_token';
  static const String refreshTokenField = 'refresh_token';
}
