import 'package:dio/dio.dart';

import '../error/app_exception.dart';

/// Converts a [DioException] into the matching [AppException].
///
/// Never copies response bodies into `debugMessage` (they may contain PII);
/// only the method, path and status code are kept for logs.
AppException mapDioException(DioException e) {
  final inner = e.error;
  if (inner is AppException) {
    return inner;
  }

  final where = '${e.requestOptions.method} ${e.requestOptions.uri.path}';

  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return RequestTimeoutException(debugMessage: 'Timeout: $where', cause: e);
    case DioExceptionType.cancel:
      return RequestCancelledException(
        debugMessage: 'Cancelled: $where',
        cause: e,
      );
    case DioExceptionType.connectionError:
      return NetworkException(
        debugMessage: 'Connection error: $where',
        cause: e,
      );
    case DioExceptionType.badCertificate:
      return NetworkException(
        debugMessage: 'Bad certificate: $where',
        cause: e,
      );
    case DioExceptionType.badResponse:
      return mapStatusCode(
        e.response?.statusCode ?? 0,
        e.response?.data,
        debugMessage: 'HTTP ${e.response?.statusCode}: $where',
        cause: e,
      );
    case DioExceptionType.unknown:
      return UnknownException(debugMessage: 'Unknown: $where', cause: e);
  }
}

/// Maps a non-2xx HTTP status (+ optional decoded body) to an [AppException].
AppException mapStatusCode(
  int statusCode,
  Object? body, {
  String? debugMessage,
  Object? cause,
}) {
  return switch (statusCode) {
    400 || 422 => ValidationException(
      serverMessage: _safeMessage(body),
      fieldErrors: _fieldErrors(body),
      debugMessage: debugMessage,
      cause: cause,
    ),
    401 => UnauthorizedException(debugMessage: debugMessage, cause: cause),
    403 => ForbiddenException(debugMessage: debugMessage, cause: cause),
    404 => NotFoundException(debugMessage: debugMessage, cause: cause),
    _ => ServerException(
      statusCode: statusCode,
      debugMessage: debugMessage,
      cause: cause,
    ),
  };
}

/// Reads a top-level `message` string from a validation error body. The
/// backend contract must guarantee this field is user-safe.
String? _safeMessage(Object? body) {
  if (body is Map<String, dynamic>) {
    final message = body['message'];
    if (message is String && message.trim().isNotEmpty) {
      return message;
    }
  }
  return null;
}

/// Reads `errors: {field: "msg"}` or `errors: {field: ["msg", ...]}`.
Map<String, String> _fieldErrors(Object? body) {
  if (body is! Map<String, dynamic>) {
    return const {};
  }
  final errors = body['errors'];
  if (errors is! Map<String, dynamic>) {
    return const {};
  }
  final result = <String, String>{};
  for (final entry in errors.entries) {
    final value = entry.value;
    if (value is String) {
      result[entry.key] = value;
    } else if (value is List<dynamic> && value.isNotEmpty) {
      final first = value.first;
      if (first is String) {
        result[entry.key] = first;
      }
    }
  }
  return result;
}
