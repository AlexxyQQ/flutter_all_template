import 'package:equatable/equatable.dart';

/// Category of a [Failure]. Lets the UI react to *kinds* of errors
/// (e.g. redirect to login on [unauthorized]) without string matching.
enum FailureType {
  network,
  certificate,
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
/// Two separate text fields, so the UI never has to guess what it holds:
/// * [messageKey] is **always** a localization key.
/// * [serverMessage] is an optional text the backend marked as safe to show;
///   it is displayed verbatim (never translated).
///
/// Neither may contain raw exception text, stack traces, tokens or other
/// internal details — put those in logs (redacted) instead. Widgets show
/// `failure.displayText` (`lib/core/presentation/failure_text.dart`).
final class Failure extends Equatable {
  const Failure({
    required this.messageKey,
    this.serverMessage,
    this.type = FailureType.unknown,
    this.statusCode,
    this.fieldErrors = const {},
  });

  const Failure.unknown()
    : messageKey = unknownMessageKey,
      serverMessage = null,
      type = FailureType.unknown,
      statusCode = null,
      fieldErrors = const {};

  /// A failed input check (client-side or from a 400/422 response).
  const Failure.validation({
    required this.messageKey,
    this.serverMessage,
    this.statusCode,
    this.fieldErrors = const {},
  }) : type = FailureType.validation;

  /// Localization key of the generic "something went wrong" message.
  ///
  /// The domain cannot import the generated `LocaleKeys`, so the key is spelled
  /// out here; `failure_test.dart` keeps it equal to
  /// `LocaleKeys.common_errors_somethingWentWrong`.
  static const String unknownMessageKey = 'common.errors.somethingWentWrong';

  /// Localization key of the user-facing text.
  final String messageKey;

  /// Backend-provided text that is safe to display as-is, if any.
  final String? serverMessage;

  final FailureType type;

  /// HTTP status code when the failure originated from an HTTP response.
  final int? statusCode;

  /// Field-level validation errors (field name -> localization key/message).
  final Map<String, String> fieldErrors;

  @override
  List<Object?> get props => [
    messageKey,
    serverMessage,
    type,
    statusCode,
    fieldErrors,
  ];

  @override
  String toString() =>
      'Failure(type: $type, statusCode: $statusCode, messageKey: $messageKey)';
}
