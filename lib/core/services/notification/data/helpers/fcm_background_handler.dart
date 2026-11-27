import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../config/firebase/firebase_options.dart';
import '../../../logger/data/app_logger.dart';
import '../notification_preferences.dart';
import 'notification_display_helper.dart';

/// FCM background/terminated-state handler.
///
/// Runs in its **own isolate**: there is no GetIt container, no
/// `NotificationService`, and Firebase is not initialised yet, so the few
/// collaborators it needs are created here directly. [AppLogger] is static and
/// works in any isolate (it falls back to its platform default logger), which
/// is why errors are reported through it.
///
/// Messages that carry a `notification` block are already shown by the OS
/// while the app is in the background, so only data-only messages are
/// rendered here (avoids duplicates).
abstract final class FcmBackgroundHandler {
  /// Static (not a closure) so FCM can look it up by name in the new isolate.
  @pragma('vm:entry-point')
  static Future<void> handle(RemoteMessage message) async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      final enabled =
          await SharedPreferencesAsync().getBool(
            NotificationPreferences.enabledKey,
          ) ??
          true;
      if (!enabled || message.notification != null) {
        return;
      }

      final display = NotificationDisplayHelper(
        awesome: AwesomeNotifications(),
        logger: AppLogger.service,
      );
      await display.initialize();
      await display.showRemoteMessage(message: message);
    } catch (e, s) {
      AppLogger.error(
        'Background message handling failed',
        error: e,
        stackTrace: s,
        name: 'FcmBackgroundHandler',
      );
    }
  }
}
