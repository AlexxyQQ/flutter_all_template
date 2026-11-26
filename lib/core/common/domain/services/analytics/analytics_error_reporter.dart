import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../error/guard.dart';
import 'domain/analytics_service.dart';

/// Adds analytics error events to the app's global error entry points
/// (Flutter framework, platform dispatcher, `guard()`, the root zone),
/// keeping the handlers `bootstrap` installed before DI.
///
/// Only the error's kind is recorded (see `AnalyticsSanitizer.describeError`)
/// and it is correlated with the most recent user action.
@lazySingleton
class AnalyticsErrorReporter {
  AnalyticsErrorReporter({required IAnalyticsService analytics})
    : _analytics = analytics;

  final IAnalyticsService _analytics;
  bool _installed = false;

  /// Chains onto the current handlers. Safe to call more than once.
  void install() {
    if (_installed) {
      return;
    }
    _installed = true;

    final previousFlutter = FlutterError.onError;
    FlutterError.onError = (details) {
      previousFlutter?.call(details);
      report(source: 'flutter', error: details.exception);
    };

    final dispatcher = PlatformDispatcher.instance;
    final previousPlatform = dispatcher.onError;
    dispatcher.onError = (error, stackTrace) {
      report(source: 'platform', error: error, fatal: true);
      return previousPlatform?.call(error, stackTrace) ?? false;
    };

    final previousGuard = guardErrorReporter;
    guardErrorReporter = (error, stackTrace) {
      previousGuard(error, stackTrace);
      report(source: 'guard', error: error);
    };
  }

  /// Records [error]. Never throws: error handling must not fail because of
  /// analytics.
  void report({
    required String source,
    required Object error,
    bool fatal = false,
  }) {
    try {
      _analytics.trackError(source: source, error: error, fatal: fatal);
    } catch (_) {
      // Deliberately ignored: this runs inside the global error handlers,
      // where a throw would recurse or hide the original error.
    }
  }
}
