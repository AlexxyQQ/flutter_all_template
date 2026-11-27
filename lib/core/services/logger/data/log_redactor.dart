/// Strips secrets from text before it reaches any log sink.
///
/// This is a safety net, not a licence to log secrets: call sites must still
/// avoid logging tokens, passwords, storage values or route arguments.
abstract final class LogRedactor {
  static const String mask = '<redacted>';

  static const List<String> _secretKeys = [
    'password',
    'passwd',
    'pwd',
    'token',
    'access_token',
    'accessToken',
    'refresh_token',
    'refreshToken',
    'id_token',
    'secret',
    'client_secret',
    'api_key',
    'apikey',
    'apiKey',
    'authorization',
    'otp',
    'pin',
  ];

  /// Header names whose values must never be logged.
  static const Set<String> sensitiveHeaders = {
    'authorization',
    'proxy-authorization',
    'cookie',
    'set-cookie',
    'x-api-key',
  };

  static final RegExp _bearer = RegExp(
    r'(Bearer|Basic)\s+[A-Za-z0-9\-._~+/]+=*',
    caseSensitive: false,
  );

  static final RegExp _jwt = RegExp(
    r'eyJ[A-Za-z0-9_-]{5,}\.[A-Za-z0-9_-]{5,}\.[A-Za-z0-9_-]*',
  );

  static final String _keyAlternation = _secretKeys.join('|');

  /// `password=...`, `token: ...` (query strings, form bodies, plain text).
  static final RegExp _keyValue = RegExp(
    '\\b($_keyAlternation)\\s*[=:]\\s*(?!")([^&\\s,;"]+)',
    caseSensitive: false,
  );

  /// `"password": "..."` (JSON).
  static final RegExp _jsonKeyValue = RegExp(
    '"($_keyAlternation)"\\s*:\\s*"[^"]*"',
    caseSensitive: false,
  );

  static String redact(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input
        .replaceAllMapped(_bearer, (m) => '${m.group(1)} $mask')
        .replaceAll(_jwt, mask)
        .replaceAllMapped(_jsonKeyValue, (m) => '"${m.group(1)}":"$mask"')
        .replaceAllMapped(_keyValue, (m) => '${m.group(1)}=$mask');
  }

  /// Returns a copy of [headers] with sensitive values masked.
  static Map<String, Object?> redactHeaders(Map<String, Object?> headers) {
    return {
      for (final entry in headers.entries)
        entry.key: sensitiveHeaders.contains(entry.key.toLowerCase())
            ? mask
            : entry.value,
    };
  }
}
