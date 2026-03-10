import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../notification_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // 1. Initialize SharedPreferences in this isolated background thread
  final prefs = await SharedPreferences.getInstance();
  await prefs.reload(); // Ensure we have the latest data

  // 2. Check the toggle explicitly
  // Note: Matches the key used in 'notification_logic_helper.dart'
  final bool isEnabled = prefs.getBool('app_notifications_enabled') ?? true;

  if (!isEnabled) {
    print(
      '[BackgroundHandler] Suppressing notification because toggle is OFF.',
    );
    return; // 🛑 EXIT HERE: Do not show notification
  }

  // 3. If enabled, initialize the service and show
  await NotificationService.instance.initBackground();

  // If you switched to Data-Only messages (recommended), message.notification will be null.
  // We manually trigger the local notification using the data payload.
  await NotificationService.instance.showNotification(message);
}
