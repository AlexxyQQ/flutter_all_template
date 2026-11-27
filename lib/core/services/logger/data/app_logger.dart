import '../domain/logger_service.dart';
import 'log_redactor.dart';
import 'logger_service.dart';

export '../domain/logger_service.dart';
export 'log_sinks.dart' show ICrashReporter, LogLevel, NoopCrashReporter;

/// Static logging facade used across the codebase.
///
/// ```dart
/// AppLogger.info('Loaded 12 items', name: 'TodoRepository');
/// AppLogger.error('Sync failed', error: e, stackTrace: s);
/// ```
///
/// Never log secrets (tokens, passwords, storage values, route arguments,
/// push tokens). Messages are additionally passed through [LogRedactor].
abstract final class AppLogger {
  static ILoggerService _service = LoggerService.platformDefault();

  /// The active logger (also registered in DI as [ILoggerService]).
  static ILoggerService get service => _service;

  /// Replaces the active logger, e.g. to add a crash reporter in bootstrap or
  /// a recording logger in tests.
  static void configure(ILoggerService service) => _service = service;

  static void debug(String message, {String? name}) =>
      _service.debug(message, name: name);

  static void info(String message, {String? name}) =>
      _service.info(message, name: name);

  static void warning(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? name,
  }) => _service.warning(
    message,
    error: error,
    stackTrace: stackTrace,
    name: name,
  );

  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? name,
  }) =>
      _service.error(message, error: error, stackTrace: stackTrace, name: name);
}
