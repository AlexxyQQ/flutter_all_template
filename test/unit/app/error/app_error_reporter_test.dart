import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_all_template/app/error/app_error_reporter.dart';
import 'package:flutter_all_template/core/error/guard.dart';
import 'package:flutter_all_template/core/error/guard_error_hook.dart';
import 'package:flutter_all_template/core/services/analytics/domain/analytics_service.dart';
import 'package:flutter_all_template/core/services/logger/data/app_logger.dart';
import 'package:flutter_all_template/core/services/logger/data/log_sinks.dart';
import 'package:flutter_all_template/core/services/logger/data/logger_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAnalytics extends Mock implements IAnalyticsService {}

class _Sink implements ILogSink {
  final List<LogEntry> entries = [];

  @override
  void write(LogEntry entry) => entries.add(entry);
}

void main() {
  late _MockAnalytics analytics;
  late _Sink sink;
  late AppErrorReporter reporter;
  late FlutterExceptionHandler? savedFlutter;
  late ErrorCallback? savedPlatform;
  late ILoggerService savedLogger;

  void stubTrackError({Object? throwing}) {
    final call = when(
      () => analytics.trackError(
        source: any(named: 'source'),
        error: any<Object>(named: 'error'),
        fatal: any(named: 'fatal'),
      ),
    );
    if (throwing != null) {
      call.thenThrow(throwing);
    }
  }

  setUp(() {
    analytics = _MockAnalytics();
    sink = _Sink();
    savedFlutter = FlutterError.onError;
    savedPlatform = PlatformDispatcher.instance.onError;
    savedLogger = AppLogger.service;
    AppLogger.configure(LoggerService(sinks: [sink]));
    reporter = AppErrorReporter(analytics: () => analytics);
  });

  tearDown(() {
    FlutterError.onError = savedFlutter;
    PlatformDispatcher.instance.onError = savedPlatform;
    GuardErrorHook.onUnexpectedError = (_, _) {};
    AppLogger.configure(savedLogger);
  });

  test('flutter errors are logged and recorded once', () {
    reporter.install();
    final error = StateError('framework');

    FlutterError.onError!(FlutterErrorDetails(exception: error));

    verify(
      () => analytics.trackError(source: 'flutter', error: error),
    ).called(1);
    expect(sink.entries.single.error, same(error));
  });

  test('platform errors are fatal and handled', () {
    reporter.install();
    final error = StateError('platform');

    final handled = PlatformDispatcher.instance.onError!(
      error,
      StackTrace.empty,
    );

    expect(handled, isTrue);
    verify(
      () => analytics.trackError(source: 'platform', error: error, fatal: true),
    ).called(1);
  });

  test('zone errors are fatal', () {
    final error = StateError('zone');

    reporter.onZoneError(error, StackTrace.empty);

    verify(
      () => analytics.trackError(source: 'zone', error: error, fatal: true),
    ).called(1);
    expect(sink.entries, hasLength(1));
  });

  test('errors guard() could not map are logged and recorded once', () async {
    reporter.install();
    final error = StateError('bug');

    await guard<void>(() async => throw error);

    verify(() => analytics.trackError(source: 'guard', error: error)).called(1);
    expect(sink.entries.single.error, same(error));
  });

  test('installing twice does not report an error twice', () {
    reporter
      ..install()
      ..install();
    final error = StateError('once');

    FlutterError.onError!(FlutterErrorDetails(exception: error));

    verify(
      () => analytics.trackError(source: 'flutter', error: error),
    ).called(1);
  });

  test('errors before analytics exists are only logged', () {
    AppErrorReporter(
      analytics: () => null,
    ).onZoneError(StateError('early'), StackTrace.empty);

    expect(sink.entries, hasLength(1));
    verifyZeroInteractions(analytics);
  });

  test('an analytics failure is logged, not rethrown', () {
    stubTrackError(throwing: StateError('analytics broke'));

    reporter.onZoneError(StateError('original'), StackTrace.empty);

    expect(sink.entries.map((e) => e.level), [
      LogLevel.error,
      LogLevel.warning,
    ]);
  });
}
