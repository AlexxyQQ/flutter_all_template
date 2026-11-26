import 'package:flutter_all_template/core/common/domain/services/logger/log_sinks.dart';
import 'package:flutter_all_template/core/common/domain/services/logger/logger_service.dart';
import 'package:flutter_test/flutter_test.dart';

class _RecordingSink implements LogSink {
  final List<LogEntry> entries = [];

  @override
  void write(LogEntry entry) => entries.add(entry);
}

class _ThrowingSink implements LogSink {
  @override
  void write(LogEntry entry) => throw StateError('sink broken');
}

class _RecordingReporter implements CrashReporter {
  final List<String> logs = [];
  final List<Object> errors = [];

  @override
  void log(String message) => logs.add(message);

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async => errors.add(error);
}

void main() {
  test('messages are redacted before reaching sinks', () {
    final sink = _RecordingSink();
    LoggerService(sinks: [sink]).i('login password=hunter2');
    expect(sink.entries.single.message, isNot(contains('hunter2')));
  });

  test('minLevel filters lower levels', () {
    final sink = _RecordingSink();
    LoggerService(sinks: [sink], minLevel: LogLevel.warning)
      ..d('d')
      ..i('i')
      ..w('w')
      ..e('e');
    expect(sink.entries.map((e) => e.level), [
      LogLevel.warning,
      LogLevel.error,
    ]);
  });

  test('a throwing sink does not break the others', () {
    final sink = _RecordingSink();
    LoggerService(sinks: [_ThrowingSink(), sink]).e('boom');
    expect(sink.entries, hasLength(1));
  });

  test('CrashReporterSink forwards warnings and errors only', () {
    final reporter = _RecordingReporter();
    final error = StateError('x');
    LoggerService(sinks: [CrashReporterSink(reporter)])
      ..d('debug')
      ..i('info')
      ..w('careful', name: 'Mod')
      ..e('failed', error: error);
    expect(reporter.logs, ['[Mod] careful']);
    expect(reporter.errors, [error]);
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
