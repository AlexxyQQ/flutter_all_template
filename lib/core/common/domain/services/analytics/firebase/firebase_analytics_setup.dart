import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

import '../../../../../../config/env/app_env.dart';
import '../../logger/logger_service.dart';

/// Synchronizes the SDK's persisted collection setting with this build.
abstract final class FirebaseAnalyticsSetup {
  static Future<void> configure() async {
    const enabled = AppEnv.analyticsEnabled && AppEnv.analyticsFirebaseEnabled;
    if (kIsWeb ? !enabled : !_hasNativeSdk) {
      return;
    }
    try {
      final analytics = FirebaseAnalytics.instance;
      if (enabled) {
        await analytics.setUserId();
      }
      await analytics.setAnalyticsCollectionEnabled(enabled);
    } catch (error) {
      AppLogger.warning(
        'Firebase Analytics configuration failed (${error.runtimeType})',
        name: 'Analytics',
      );
    }
  }

  static bool get _hasNativeSdk => switch (defaultTargetPlatform) {
    TargetPlatform.android ||
    TargetPlatform.iOS ||
    TargetPlatform.macOS => true,
    _ => false,
  };
}
