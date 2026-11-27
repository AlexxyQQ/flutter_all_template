import 'package:dio/dio.dart';

import '../error/app_exception.dart';

/// Converts a [DioException] into the matching [AppException].
///
/// The `switch` over [DioExceptionType] is deliberately exhaustive and
/// `pubspec.yaml` requires a dio version that has every value: a future dio
/// that adds an enum value fails to compile here instead of being mapped wrong.
///
/// Never copies response bodies into `debugMessage` (they may contain PII);
/// only the method, path and status code are kept for logs.
AppException mapDioException({required DioException exception}) {
  final inner = exception.error;
  if (inner is AppException) {
    return inner;
  }

  final where =
      '${exception.requestOptions.method} ${exception.requestOptions.uri.path}';

  return switch (exception.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.transformTimeout => RequestTimeoutException(
      debugMessage: 'Timeout: $where',
      cause: exception,
    ),
    DioExceptionType.cancel => RequestCancelledException(
      debugMessage: 'Cancelled: $where',
      cause: exception,
    ),
    DioExceptionType.connectionError => NetworkException(
      debugMessage: 'Connection error: $where',
      cause: exception,
    ),
    DioExceptionType.badCertificate => BadCertificateException(
      debugMessage: 'Bad certificate: $where',
      cause: exception,
    ),
    DioExceptionType.badResponse => mapStatusCode(
      statusCode: exception.response?.statusCode ?? 0,
      body: exception.response?.data,
      debugMessage: 'HTTP ${exception.response?.statusCode}: $where',
      cause: exception,
    ),
    DioExceptionType.unknown => UnknownException(
      debugMessage: 'Unknown: $where',
      cause: exception,
    ),
  };
}

/// Maps a non-2xx HTTP status (+ optional decoded body) to an [AppException].
AppException mapStatusCode({
  required int statusCode,
  required Object? body,
  String? debugMessage,
  Object? cause,
}) {
  return switch (statusCode) {
    400 || 422 => ValidationException(
      statusCode: statusCode,
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
      // Only 4xx bodies are actionable for the user; 5xx bodies come from
      // gateways/frameworks and are never shown.
      serverMessage: statusCode >= 400 && statusCode < 500
          ? _safeMessage(body)
          : null,
      debugMessage: debugMessage,
      cause: cause,
    ),
  };
}

/// Reads a top-level `message` string from an error body. The
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
