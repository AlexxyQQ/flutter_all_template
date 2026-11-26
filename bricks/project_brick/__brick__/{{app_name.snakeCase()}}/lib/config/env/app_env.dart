/// Compile-time configuration supplied with
/// `flutter run --dart-define-from-file=env/<flavor>.json`.
///
/// Everything here ships inside the binary and is readable by anyone who has
/// the app. NEVER put secrets (private API keys, signing keys, passwords) here.
abstract final class AppEnv {
  /// `dev`, `staging` or `prod`.
  static const String flavor = String.fromEnvironment(
    'FLAVOR',
    defaultValue: 'dev',
  );

  /// API base URL, e.g. `https://api.example.com/v1/`.
  static const String baseUrl = String.fromEnvironment('BASE_URL');

  /// Opt-in remote log upload (disabled unless explicitly enabled).
  static const bool enableLogUpload = bool.fromEnvironment('ENABLE_LOG_UPLOAD');
  static const String logUploadUrl = String.fromEnvironment('LOG_UPLOAD_URL');

  /// Debug-only escape hatches. Ignored in release builds.
  static const String devProxy = String.fromEnvironment('DEV_PROXY');
  static const bool devTrustSelfSignedCerts = bool.fromEnvironment(
    'DEV_TRUST_SELF_SIGNED_CERTS',
  );

  static bool get isProd => flavor == 'prod';
  static bool get isDev => flavor == 'dev';
}
