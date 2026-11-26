import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import 'domain/analytics_service.dart';

/// Flushes queued analytics when the app is backgrounded, the last moment
/// the OS reliably lets it use the network. Events are persisted anyway, so
/// a missed flush only delays delivery.
@lazySingleton
class AnalyticsLifecycleObserver with WidgetsBindingObserver {
  AnalyticsLifecycleObserver({required IAnalyticsService analytics})
    : _analytics = analytics;

  final IAnalyticsService _analytics;
  bool _installed = false;

  void install() {
    if (_installed) {
      return;
    }
    _installed = true;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached) {
      unawaited(_analytics.flush());
    }
  }

  @disposeMethod
  void dispose() {
    if (_installed) {
      WidgetsBinding.instance.removeObserver(this);
      _installed = false;
    }
  }
}
