import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../error/app_exception.dart';
import 'api_client.dart';
import 'dio_exception_mapper.dart';

/// [ApiClient] backed by the app-wide [Dio] (configured in `NetworkModule`).
@LazySingleton(as: ApiClient)
class DioApiClient implements ApiClient {
  DioApiClient({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<T> get<T>(
    String path, {
    required JsonDecoder<T> decode,
    Map<String, Object?>? query,
    Map<String, String>? headers,
  }) => _request('GET', path, decode, query: query, headers: headers);

  @override
  Future<T> post<T>(
    String path, {
    required JsonDecoder<T> decode,
    Object? body,
    Map<String, Object?>? query,
    Map<String, String>? headers,
  }) => _request(
    'POST',
    path,
    decode,
    body: body,
    query: query,
    headers: headers,
  );

  @override
  Future<T> put<T>(
    String path, {
    required JsonDecoder<T> decode,
    Object? body,
    Map<String, Object?>? query,
    Map<String, String>? headers,
  }) =>
      _request('PUT', path, decode, body: body, query: query, headers: headers);

  @override
  Future<T> patch<T>(
    String path, {
    required JsonDecoder<T> decode,
    Object? body,
    Map<String, Object?>? query,
    Map<String, String>? headers,
  }) => _request(
    'PATCH',
    path,
    decode,
    body: body,
    query: query,
    headers: headers,
  );

  @override
  Future<T> delete<T>(
    String path, {
    required JsonDecoder<T> decode,
    Object? body,
    Map<String, Object?>? query,
    Map<String, String>? headers,
  }) => _request(
    'DELETE',
    path,
    decode,
    body: body,
    query: query,
    headers: headers,
  );

  Future<T> _request<T>(
    String method,
    String path,
    JsonDecoder<T> decode, {
    Object? body,
    Map<String, Object?>? query,
    Map<String, String>? headers,
  }) async {
    final Response<Object?> response;
    try {
      response = await _dio.request<Object?>(
        path,
        data: body,
        queryParameters: query,
        options: Options(method: method, headers: headers),
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }

    final status = response.statusCode ?? 0;
    // Dio's default validateStatus already rejects non-2xx, but a custom
    // validateStatus on a request must not turn errors into "successes".
    if (status < 200 || status >= 300) {
      throw mapStatusCode(
        status,
        response.data,
        debugMessage: 'HTTP $status: $method $path',
      );
    }

    final data = _normalise(response.data);
    try {
      return decode(data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ParseException(
        debugMessage: 'Failed to decode $method $path (${e.runtimeType})',
        cause: e,
      );
    }
  }

  /// Empty bodies (204, or 200/201 with no content) are decoded as `null`.
  static Object? _normalise(Object? data) {
    if (data is String && data.trim().isEmpty) {
      return null;
    }
    return data;
  }
}
