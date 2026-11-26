/// Exceptions thrown by the **data layer** (data sources, API client, storage).
///
/// Data sources throw these; repositories convert them exactly once into a
/// domain `Failure` via `guard()` (see `guard.dart`). Nothing above the
/// repository layer should ever catch an [AppException] directly.
///
/// [debugMessage] is for logs only (it must still be free of secrets) and is
/// never shown to users.
sealed class AppException implements Exception {
  const AppException({this.debugMessage, this.cause});

  final String? debugMessage;
  final Object? cause;

  @override
  String toString() => '$runtimeType(${debugMessage ?? ''})';
}

/// Device is offline or the host is unreachable.
final class NetworkException extends AppException {
  const NetworkException({super.debugMessage, super.cause});
}

/// Connect/send/receive timeout.
final class RequestTimeoutException extends AppException {
  const RequestTimeoutException({super.debugMessage, super.cause});
}

/// Request was cancelled (e.g. via a cancel token or a restartable bloc event).
final class RequestCancelledException extends AppException {
  const RequestCancelledException({super.debugMessage, super.cause});
}

/// HTTP 401 — session missing/expired and could not be refreshed.
final class UnauthorizedException extends AppException {
  const UnauthorizedException({super.debugMessage, super.cause});
}

/// HTTP 403.
final class ForbiddenException extends AppException {
  const ForbiddenException({super.debugMessage, super.cause});
}

/// HTTP 404.
final class NotFoundException extends AppException {
  const NotFoundException({super.debugMessage, super.cause});
}

/// HTTP 400/422 with optional server-provided, user-safe message and field errors.
final class ValidationException extends AppException {
  const ValidationException({
    this.serverMessage,
    this.fieldErrors = const {},
    super.debugMessage,
    super.cause,
  });

  /// A message the backend explicitly marked as safe to display, if any.
  final String? serverMessage;
  final Map<String, String> fieldErrors;
}

/// Any other non-2xx HTTP response.
final class ServerException extends AppException {
  const ServerException({
    required this.statusCode,
    this.serverMessage,
    super.debugMessage,
    super.cause,
  });

  final int statusCode;

  /// A message the backend explicitly marked as safe to display, if any.
  final String? serverMessage;
}

/// Response body could not be decoded into the expected model.
final class ParseException extends AppException {
  const ParseException({super.debugMessage, super.cause});
}

/// Local storage (secure storage, preferences, database) failure.
final class StorageException extends AppException {
  const StorageException({super.debugMessage, super.cause});
}

/// Requested item does not exist in a local cache/store.
final class CacheMissException extends AppException {
  const CacheMissException({super.debugMessage, super.cause});
}

/// OS permission related failure.
final class PermissionException extends AppException {
  const PermissionException({super.debugMessage, super.cause});
}

/// Anything else. Prefer a specific subtype.
final class UnknownException extends AppException {
  const UnknownException({super.debugMessage, super.cause});
}
