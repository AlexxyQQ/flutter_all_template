import 'package:flutter_all_template/core/network/api_client.dart';

/// A recorded [ApiClient] call.
typedef ApiCall = ({
  String method,
  String path,
  Object? body,
  Map<String, Object?>? query,
});

/// [ApiClient] fake: records calls and feeds [respond]'s raw JSON through the
/// caller's `decode`, so data-source decoding is exercised too.
class FakeApiClient implements ApiClient {
  FakeApiClient(this.respond);

  /// Returns the raw JSON body for a call, or throws an `AppException`.
  Object? Function(ApiCall call) respond;

  final calls = <ApiCall>[];

  Future<T> _send<T>(
    String method,
    String path,
    JsonDecoder<T> decode, {
    Object? body,
    Map<String, Object?>? query,
  }) async {
    final call = (method: method, path: path, body: body, query: query);
    calls.add(call);
    return decode(respond(call));
  }

  @override
  Future<T> get<T>(
    String path, {
    required JsonDecoder<T> decode,
    Map<String, Object?>? query,
    Map<String, String>? headers,
  }) => _send('GET', path, decode, query: query);

  @override
  Future<T> post<T>(
    String path, {
    required JsonDecoder<T> decode,
    Object? body,
    Map<String, Object?>? query,
    Map<String, String>? headers,
  }) => _send('POST', path, decode, body: body, query: query);

  @override
  Future<T> put<T>(
    String path, {
    required JsonDecoder<T> decode,
    Object? body,
    Map<String, Object?>? query,
    Map<String, String>? headers,
  }) => _send('PUT', path, decode, body: body, query: query);

  @override
  Future<T> patch<T>(
    String path, {
    required JsonDecoder<T> decode,
    Object? body,
    Map<String, Object?>? query,
    Map<String, String>? headers,
  }) => _send('PATCH', path, decode, body: body, query: query);

  @override
  Future<T> delete<T>(
    String path, {
    required JsonDecoder<T> decode,
    Object? body,
    Map<String, Object?>? query,
    Map<String, String>? headers,
  }) => _send('DELETE', path, decode, body: body, query: query);
}

Map<String, Object?> todoJson(
  String id, {
  String title = 'Title',
  bool isDone = false,
  String updatedAt = '2026-01-01T00:00:00.000Z',
}) => {'id': id, 'title': title, 'is_done': isDone, 'updated_at': updatedAt};
