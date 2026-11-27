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

  /// API base URL, e.g. `https://api.example.com/v1/`. Checked at startup by
  /// [validate]; without it no request would ever get an auth header.
  static const String baseUrl = String.fromEnvironment('BASE_URL');

  /// Analytics master switch (default off). Enabling it retains events
  /// locally and sends them to the configured remote destinations.
  static const bool analyticsEnabled = bool.fromEnvironment(
    'ANALYTICS_ENABLED',
  );

  /// Absolute URL of a custom analytics batch endpoint (empty = off).
  static const String analyticsApiUrl = String.fromEnvironment(
    'ANALYTICS_API_URL',
  );

  /// Also send events to Firebase Analytics. Requires a Firebase build.
  static const bool analyticsFirebaseEnabled = bool.fromEnvironment(
    'ANALYTICS_FIREBASE_ENABLED',
  );

  /// Debug-only escape hatches. Ignored in release builds.
  static const String devProxy = String.fromEnvironment('DEV_PROXY');
  static const bool devTrustSelfSignedCerts = bool.fromEnvironment(
    'DEV_TRUST_SELF_SIGNED_CERTS',
  );

  /// Fails fast, with a message that says how to fix it, when the build was
  /// started without a usable `BASE_URL` (a missing
  /// `--dart-define-from-file=env/<flavor>.json`). Called once by `Bootstrap`;
  /// [url] exists so tests can check other values.
  static void validate({String url = baseUrl}) {
    final uri = Uri.tryParse(url.trim());
    final valid =
        uri != null &&
        uri.host.isNotEmpty &&
        (uri.scheme == 'https' || uri.scheme == 'http');
    if (!valid) {
      throw StateError(
        'BASE_URL is missing or not an absolute http(s) URL (got "$url"). '
        'Run with --dart-define-from-file=env/<flavor>.json and set BASE_URL '
        '(see env/dev.example.json).',
      );
    }
  }
}
