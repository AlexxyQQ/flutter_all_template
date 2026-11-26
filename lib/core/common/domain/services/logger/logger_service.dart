import 'package:flutter/foundation.dart';

import 'log_redactor.dart';
import 'log_sinks.dart';

export 'log_sinks.dart' show CrashReporter, LogLevel, NoopCrashReporter;

/// Logging contract. Inject it where a logger is a real dependency; use the
/// static [AppLogger] facade for incidental logging.
abstract interface class ILoggerService {
  void d(String message, {String? name});
  void i(String message, {String? name});
  void w(String message, {Object? error, StackTrace? stackTrace, String? name});
  void e(String message, {Object? error, StackTrace? stackTrace, String? name});
}

/// Default [ILoggerService]: redacts every message and fans it out to sinks.
class LoggerService implements ILoggerService {
  LoggerService({required List<LogSink> sinks, LogLevel minLevel = .debug})
    : _sinks = List.unmodifiable(sinks),
      _minLevel = minLevel;

  /// Debug: everything to the console.
  /// Release/profile: warnings & errors to [crashReporter] only.
  factory LoggerService.platformDefault({CrashReporter? crashReporter}) {
    if (kDebugMode) {
      return LoggerService(sinks: [ConsoleLogSink()]);
    }
    return LoggerService(
      sinks: [CrashReporterSink(crashReporter ?? const NoopCrashReporter())],
      minLevel: .warning,
    );
  }

  final List<LogSink> _sinks;
  final LogLevel _minLevel;

  @override
  void d(String message, {String? name}) => _log(.debug, message, name: name);

  @override
  void i(String message, {String? name}) => _log(.info, message, name: name);

  @override
  void w(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? name,
  }) =>
      _log(.warning, message, name: name, error: error, stackTrace: stackTrace);

  @override
  void e(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? name,
  }) => _log(.error, message, name: name, error: error, stackTrace: stackTrace);

  void _log(
    LogLevel level,
    String message, {
    String? name,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (level.index < _minLevel.index) {
      return;
    }
    final entry = LogEntry(
      level: level,
      message: LogRedactor.redact(message),
      time: DateTime.now(),
      name: name,
      error: error,
      stackTrace: stackTrace,
    );
    for (final sink in _sinks) {
      try {
        sink.write(entry);
      } catch (_) {
        // A failing sink must never crash the app or block other sinks.
      }
    }
  }
}

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
      _service.d(message, name: name);

  static void info(String message, {String? name}) =>
      _service.i(message, name: name);

  static void warning(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? name,
  }) => _service.w(message, error: error, stackTrace: stackTrace, name: name);

  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? name,
  }) => _service.e(message, error: error, stackTrace: stackTrace, name: name);
}
