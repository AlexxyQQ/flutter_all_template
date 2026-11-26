import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_all_template/core/common/domain/services/analytics/analytics_error_reporter.dart';
import 'package:flutter_all_template/core/common/domain/services/analytics/domain/analytics_service.dart';
import 'package:flutter_all_template/core/error/guard.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAnalytics extends Mock implements IAnalyticsService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAnalytics analytics;
  late AnalyticsErrorReporter reporter;
  late FlutterExceptionHandler? savedFlutter;
  late ErrorCallback? savedPlatform;
  late GuardErrorReporter savedGuard;

  setUpAll(() => registerFallbackValue(Object()));

  setUp(() {
    savedFlutter = FlutterError.onError;
    savedPlatform = PlatformDispatcher.instance.onError;
    savedGuard = guardErrorReporter;
    analytics = MockAnalytics();
    reporter = AnalyticsErrorReporter(analytics: analytics);
  });

  tearDown(() {
    FlutterError.onError = savedFlutter;
    PlatformDispatcher.instance.onError = savedPlatform;
    guardErrorReporter = savedGuard;
  });

  test('guard() errors are tracked and still reach the previous reporter', () {
    final seen = <Object>[];
    guardErrorReporter = (error, _) => seen.add(error);
    reporter.install();

    final error = StateError('boom');
    guardErrorReporter(error, StackTrace.empty);

    expect(seen, [error]);
    verify(() => analytics.trackError(source: 'guard', error: error)).called(1);
  });

  test('Flutter framework errors are tracked after the existing handler', () {
    final seen = <FlutterErrorDetails>[];
    FlutterError.onError = seen.add;
    reporter.install();

    final details = FlutterErrorDetails(exception: StateError('layout'));
    FlutterError.onError!(details);

    expect(seen, [details]);
    verify(
      () => analytics.trackError(source: 'flutter', error: details.exception),
    ).called(1);
  });

  test('platform errors are tracked as fatal and keep the handled result', () {
    PlatformDispatcher.instance.onError = (_, _) => true;
    reporter.install();

    final error = StateError('async');
    final handled = PlatformDispatcher.instance.onError!(
      error,
      StackTrace.empty,
    );

    expect(handled, isTrue);
    verify(
      () => analytics.trackError(source: 'platform', error: error, fatal: true),
    ).called(1);
  });

  test('installing twice does not double-report', () {
    reporter
      ..install()
      ..install();

    guardErrorReporter(StateError('once'), StackTrace.empty);

    verify(
      () => analytics.trackError(
        source: 'guard',
        error: any(named: 'error'),
      ),
    ).called(1);
  });

  test('a failing analytics service never breaks error handling', () {
    when(
      () => analytics.trackError(
        source: any(named: 'source'),
        error: any(named: 'error'),
        fatal: any(named: 'fatal'),
      ),
    ).thenThrow(StateError('analytics down'));

    expect(
      () => reporter.report(source: 'zone', error: StateError('x')),
      returnsNormally,
    );
  });
}
