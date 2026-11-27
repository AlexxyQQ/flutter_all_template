import 'package:flutter/foundation.dart';

import '../../core/error/guard_error_hook.dart';
import '../../core/services/analytics/domain/analytics_service.dart';
import '../../core/services/logger/data/app_logger.dart';

/// The single composition point for errors nobody handled: the Flutter
/// framework, the platform dispatcher, the root zone and `guard()`.
///
/// Every source is logged (the logger redacts it and feeds the crash reporter
/// sink) and, once DI is ready, recorded in analytics. [install] is the only
/// place that assigns `FlutterError.onError`, `PlatformDispatcher.onError` and
/// `GuardErrorHook`; [analytics] is read on every report, so the order in
/// which DI and [install] happen does not matter.
final class AppErrorReporter {
  /// [analytics] returns the analytics service, or `null` while DI is not up.
  AppErrorReporter({required IAnalyticsService? Function() analytics})
    : _analytics = analytics;

  final IAnalyticsService? Function() _analytics;

  /// Routes the framework, platform and `guard()` errors here.
  void install() {
    FlutterError.onError = (details) {
      if (kDebugMode) {
        FlutterError.presentError(details);
      }
      _report(
        source: 'flutter',
        message: 'Flutter framework error',
        error: details.exception,
        stackTrace: details.stack,
      );
    };
    PlatformDispatcher.instance.onError = (error, stackTrace) {
      _report(
        source: 'platform',
        message: 'Uncaught platform error',
        error: error,
        stackTrace: stackTrace,
        fatal: true,
      );
      return true;
    };
    GuardErrorHook.onUnexpectedError = (error, stackTrace) => _report(
      source: 'guard',
      message: 'Unexpected error caught by guard()',
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Handler for `runZonedGuarded`.
  void onZoneError(Object error, StackTrace stackTrace) => _report(
    source: 'zone',
    message: 'Uncaught zone error',
    error: error,
    stackTrace: stackTrace,
    fatal: true,
  );

  void _report({
    required String source,
    required String message,
    required Object error,
    required StackTrace? stackTrace,
    bool fatal = false,
  }) {
    AppLogger.error(
      message,
      error: error,
      stackTrace: stackTrace,
      name: 'ErrorReporter',
    );
    try {
      _analytics()?.trackError(source: source, error: error, fatal: fatal);
    } catch (e, s) {
      // Analytics must never break error handling; say so and carry on.
      AppLogger.warning(
        'Could not record the error in analytics',
        error: e,
        stackTrace: s,
        name: 'ErrorReporter',
      );
    }
  }
}
