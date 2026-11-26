import 'dart:developer' as developer;

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../config/firebase/firebase_options.dart';
import 'notification_channels.dart';
import 'notification_display_helper.dart';
import 'notification_prefs.dart';

const String _logName = 'FcmBackgroundHandler';

/// FCM background/terminated-state handler.
///
/// Runs in its **own isolate**: there is no GetIt container, no
/// `NotificationService`, and Firebase is not initialised yet. Everything it
/// needs is created here directly.
///
/// Messages that carry a `notification` block are already shown by the OS
/// while the app is in the background, so only data-only messages are
/// rendered here (avoids duplicates).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final enabled =
        await SharedPreferencesAsync().getBool(NotificationPrefs.enabledKey) ??
        true;
    if (!enabled || message.notification != null) {
      return;
    }

    final awesome = AwesomeNotifications();
    await awesome.initialize(
      null,
      NotificationChannelConfig.channels,
      debug: kDebugMode,
    );
    await NotificationDisplayHelper(
      awesomeNotifications: awesome,
      onError: _report,
    ).showRemoteMessage(message);
  } catch (e, s) {
    _report('Background message handling failed', e, s);
  }
}

void _report(String message, Object error, StackTrace stackTrace) {
  developer.log(message, name: _logName, error: error, stackTrace: stackTrace);
}
