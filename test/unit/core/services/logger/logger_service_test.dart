import 'package:flutter_all_template/core/services/logger/data/app_logger.dart';
import 'package:flutter_all_template/core/services/logger/data/app_logger_delegate.dart';
import 'package:flutter_all_template/core/services/logger/data/log_sinks.dart';
import 'package:flutter_all_template/core/services/logger/data/logger_service.dart';
import 'package:flutter_test/flutter_test.dart';

class _RecordingSink implements ILogSink {
  final List<LogEntry> entries = [];

  @override
  void write(LogEntry entry) => entries.add(entry);
}

class _ThrowingSink implements ILogSink {
  @override
  void write(LogEntry entry) => throw StateError('sink broken');
}

class _RecordingReporter implements ICrashReporter {
  final List<String> logs = [];
  final List<Object> errors = [];
  final List<StackTrace?> stackTraces = [];

  @override
  void log(String message) => logs.add(message);

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    errors.add(error);
    stackTraces.add(stackTrace);
  }
}

void main() {
  test('messages are redacted before reaching sinks', () {
    final sink = _RecordingSink();
    LoggerService(sinks: [sink]).info('login password=hunter2');
    expect(sink.entries.single.message, isNot(contains('hunter2')));
  });

  test('minLevel filters lower levels', () {
    final sink = _RecordingSink();
    LoggerService(sinks: [sink], minLevel: LogLevel.warning)
      ..debug('d')
      ..info('i')
      ..warning('w')
      ..error('e');
    expect(sink.entries.map((e) => e.level), [
      LogLevel.warning,
      LogLevel.error,
    ]);
  });

  test('a throwing sink does not break the others', () {
    final sink = _RecordingSink();
    LoggerService(sinks: [_ThrowingSink(), sink]).error('boom');
    expect(sink.entries, hasLength(1));
  });

  test('CrashReporterSink forwards warnings and errors only', () {
    final reporter = _RecordingReporter();
    LoggerService(sinks: [CrashReporterSink(reporter: reporter)])
      ..debug('debug')
      ..info('info')
      ..warning('careful', name: 'Mod')
      ..error('failed', error: StateError('x'));
    expect(reporter.logs, ['[Mod] careful']);
    expect(reporter.errors, hasLength(1));
  });

  test('CrashReporterSink never receives the raw error, keeps the stack', () {
    final reporter = _RecordingReporter();
    final stack = StackTrace.current;
    final raw = StateError('refresh_token=abc123 failed');

    CrashReporterSink(reporter: reporter).write(
      LogEntry(
        level: LogLevel.error,
        message: 'failed',
        time: DateTime(2026),
        error: raw,
        stackTrace: stack,
      ),
    );

    final error = reporter.errors.single;
    expect(error, isNot(same(raw)));
    expect(error.toString(), isNot(contains('abc123')));
    expect(reporter.stackTraces.single, same(stack));
  });

  test('the DI logger is the same logger as AppLogger after configure', () {
    final sink = _RecordingSink();
    final previous = AppLogger.service;
    const injected = AppLoggerDelegate();
    AppLogger.configure(LoggerService(sinks: [sink]));
    addTearDown(() => AppLogger.configure(previous));

    injected.info('via DI');
    AppLogger.info('via static');

    expect(sink.entries.map((e) => e.message), ['via DI', 'via static']);
  });

  test('AppLogger facade delegates to the configured service', () {
    final sink = _RecordingSink();
    final previous = AppLogger.service;
    AppLogger.configure(LoggerService(sinks: [sink]));
    addTearDown(() => AppLogger.configure(previous));

    AppLogger.debug('a');
    AppLogger.info('b');
    AppLogger.warning('c');
    AppLogger.error('d');

    expect(sink.entries.map((e) => e.message), ['a', 'b', 'c', 'd']);
  });
}
