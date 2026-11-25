import 'dart:async';

import 'package:logger/logger.dart';

import 'log_redactor.dart';

enum LogLevel { debug, info, warning, error }

/// One log event, already redacted by `LoggerService`.
final class LogEntry {
  const LogEntry({
    required this.level,
    required this.message,
    required this.time,
    this.name,
    this.error,
    this.stackTrace,
  });

  final LogLevel level;
  final String message;
  final DateTime time;
  final String? name;
  final Object? error;
  final StackTrace? stackTrace;

  /// The error's description, redacted (error objects may embed secrets).
  String? get redactedError =>
      error == null ? null : LogRedactor.redact(error.toString());
}

/// Destination for log entries (console, crash reporter, ...).
abstract interface class LogSink {
  void write(LogEntry entry);
}

/// Pretty console output. Intended for debug builds only.
class ConsoleLogSink implements LogSink {
  ConsoleLogSink({Logger? logger})
    : _logger =
          logger ??
          Logger(
            filter: ProductionFilter(),
            printer: PrettyPrinter(methodCount: 0),
            level: Level.trace,
          );

  final Logger _logger;

  @override
  void write(LogEntry entry) {
    final message = entry.name == null
        ? entry.message
        : '[${entry.name}] ${entry.message}';
    final error = entry.redactedError;
    switch (entry.level) {
      case LogLevel.debug:
        _logger.d(message, error: error, stackTrace: entry.stackTrace);
      case LogLevel.info:
        _logger.i(message, error: error, stackTrace: entry.stackTrace);
      case LogLevel.warning:
        _logger.w(message, error: error, stackTrace: entry.stackTrace);
      case LogLevel.error:
        _logger.e(message, error: error, stackTrace: entry.stackTrace);
    }
  }
}

/// Bridge to a crash/error reporting service.
///
/// The template ships without a vendor SDK. To wire one up, implement this
/// interface and pass it to `LoggerService.platformDefault(crashReporter: …)`
/// in `bootstrap.dart`, e.g. for Firebase Crashlytics:
///
/// ```dart
/// class CrashlyticsReporter implements CrashReporter {
///   @override
///   void log(String message) => FirebaseCrashlytics.instance.log(message);
///
///   @override
///   Future<void> recordError(Object error, StackTrace? stackTrace,
///       {String? reason, bool fatal = false}) =>
///       FirebaseCrashlytics.instance
///           .recordError(error, stackTrace, reason: reason, fatal: fatal);
/// }
/// ```
///
/// Sentry: `Sentry.addBreadcrumb(Breadcrumb(message: message))` for [log] and
/// `Sentry.captureException(error, stackTrace: stackTrace)` for [recordError].
abstract interface class CrashReporter {
  /// Breadcrumb / non-fatal context message (already redacted).
  void log(String message);

  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  });
}

class NoopCrashReporter implements CrashReporter {
  const NoopCrashReporter();

  @override
  void log(String message) {}

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {}
}

/// Forwards **warnings and errors only** to a [CrashReporter].
class CrashReporterSink implements LogSink {
  CrashReporterSink(this.reporter);

  final CrashReporter reporter;

  @override
  void write(LogEntry entry) {
    final reason = entry.name == null
        ? entry.message
        : '[${entry.name}] ${entry.message}';
    switch (entry.level) {
      case LogLevel.debug:
      case LogLevel.info:
        return;
      case LogLevel.warning:
        reporter.log(reason);
      case LogLevel.error:
        final error = entry.error;
        if (error == null) {
          reporter.log(reason);
        } else {
          unawaited(
            reporter
                .recordError(error, entry.stackTrace, reason: reason)
                .catchError((Object _) {}),
          );
        }
    }
  }
}
