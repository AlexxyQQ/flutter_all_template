import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

import '../domain/logger_service.dart';
import 'log_redactor.dart';
import 'log_sinks.dart';

/// Default [ILoggerService]: redacts every message and fans it out to sinks.
class LoggerService implements ILoggerService {
  LoggerService({required List<ILogSink> sinks, LogLevel minLevel = .debug})
    : _sinks = List.unmodifiable(sinks),
      _minLevel = minLevel;

  /// Debug: everything to the console.
  /// Release/profile: warnings & errors to [crashReporter] only.
  factory LoggerService.platformDefault({ICrashReporter? crashReporter}) {
    if (kDebugMode) {
      return LoggerService(sinks: [ConsoleLogSink()]);
    }
    return LoggerService(
      sinks: [
        CrashReporterSink(reporter: crashReporter ?? const NoopCrashReporter()),
      ],
      minLevel: .warning,
    );
  }

  final List<ILogSink> _sinks;
  final LogLevel _minLevel;

  @override
  void debug(String message, {String? name}) =>
      _log(.debug, message, name: name);

  @override
  void info(String message, {String? name}) => _log(.info, message, name: name);

  @override
  void warning(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? name,
  }) =>
      _log(.warning, message, name: name, error: error, stackTrace: stackTrace);

  @override
  void error(
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
      } catch (e, s) {
        // A failing sink must never crash the app or block other sinks. It
        // cannot be reported through the logger itself, so use the VM log.
        developer.log(
          'Log sink ${sink.runtimeType} failed',
          name: 'Logger',
          error: e,
          stackTrace: s,
        );
      }
    }
  }
}
