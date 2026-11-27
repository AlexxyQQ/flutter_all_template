/// Converts a decoded JSON body (`Map`, `List`, primitive or `null`) into [T].
typedef JsonDecoder<T> = T Function(Object? json);

/// Transport-agnostic HTTP client used by **remote data sources**.
///
/// Contract:
/// * Paths are relative to the configured API base URL. Absolute URLs to other
///   hosts must NOT go through this client (auth headers are only attached for
///   the API host).
/// * Any 2xx response is a success. `204`/empty bodies call [decode] with `null`.
/// * Failures are thrown as `AppException` subtypes (see
///   `lib/core/error/app_exception.dart`) — never as Dio/HTTP types.
/// * Decoding errors inside [decode] are rethrown as `ParseException`.
abstract interface class IApiClient {
  Future<T> get<T>(
    String path, {
    required JsonDecoder<T> decode,
    Map<String, Object?>? query,
    Map<String, String>? headers,
  });

  Future<T> post<T>(
    String path, {
    required JsonDecoder<T> decode,
    Object? body,
    Map<String, Object?>? query,
    Map<String, String>? headers,
  });

  Future<T> put<T>(
    String path, {
    required JsonDecoder<T> decode,
    Object? body,
    Map<String, Object?>? query,
    Map<String, String>? headers,
  });

  Future<T> patch<T>(
    String path, {
    required JsonDecoder<T> decode,
    Object? body,
    Map<String, Object?>? query,
    Map<String, String>? headers,
  });

  Future<T> delete<T>(
    String path, {
    required JsonDecoder<T> decode,
    Object? body,
    Map<String, Object?>? query,
    Map<String, String>? headers,
  });
}

/// Convenience decoders.
abstract final class Decoders {
  /// Ignores the body (for 204 / fire-and-forget endpoints).
  static void ignore(Object? _) {}

  /// Expects a JSON object.
  static Map<String, dynamic> object(Object? json) =>
      json! as Map<String, dynamic>;

  /// Expects a JSON array of objects and maps each with [fromJson].
  static List<T> Function(Object? json) listOf<T>(
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    return (json) => (json! as List<dynamic>)
        .map((e) => fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
