import 'package:equatable/equatable.dart';

import '../../../../config/constants/gen/locale_keys.g.dart';

/// Category of a [Failure]. Lets the UI react to *kinds* of errors
/// (e.g. redirect to login on [unauthorized]) without string matching.
enum FailureType {
  network,
  timeout,
  unauthorized,
  forbidden,
  notFound,
  validation,
  server,
  parse,
  storage,
  cancelled,
  permission,
  cache,
  unknown,
}

/// Domain-level error returned in the `Left` side of a `ResultFuture`.
///
/// Pure Dart: it must never depend on Flutter, Dio, auto_route or any other
/// infrastructure package.
///
/// [message] is a **localization key** (or an already-safe, user-facing
/// string). It must never contain raw exception text, stack traces, tokens
/// or other internal details — put those in logs (redacted) instead.
final class Failure extends Equatable {
  const Failure({
    required this.message,
    this.type = FailureType.unknown,
    this.statusCode,
    this.fieldErrors = const {},
  });

  const Failure.unknown()
    : message = LocaleKeys.common_errors_somethingWentWrong,
      type = FailureType.unknown,
      statusCode = null,
      fieldErrors = const {};

  /// Localization key or safe user-facing message.
  final String message;

  final FailureType type;

  /// HTTP status code when the failure originated from an HTTP response.
  final int? statusCode;

  /// Field-level validation errors (field name -> localization key/message).
  final Map<String, String> fieldErrors;

  Failure copyWith({
    String? message,
    FailureType? type,
    int? statusCode,
    Map<String, String>? fieldErrors,
  }) {
    return Failure(
      message: message ?? this.message,
      type: type ?? this.type,
      statusCode: statusCode ?? this.statusCode,
      fieldErrors: fieldErrors ?? this.fieldErrors,
    );
  }

  @override
  List<Object?> get props => [message, type, statusCode, fieldErrors];

  @override
  String toString() =>
      'Failure(type: $type, statusCode: $statusCode, message: $message)';
}
