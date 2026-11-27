import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

/// Android notification channels.
///
/// Channel names/descriptions are shown in the system settings but are created
/// before localization is available (bootstrap, and the FCM background
/// isolate), so they are plain constants. Rename them here for your product.
abstract final class NotificationChannelConfig {
  static const String highImportanceKey = 'high_importance';
  static const String highImportanceName = 'Notifications';
  static const String highImportanceDescription =
      'Important notifications from the app.';

  /// Accent colour of the notification icon (brand purple).
  static const Color accentColor = Color(0xFF9D50DD);

  static List<NotificationChannel> get channels => [
    NotificationChannel(
      channelKey: highImportanceKey,
      channelName: highImportanceName,
      channelDescription: highImportanceDescription,
      defaultColor: accentColor,
      ledColor: Colors.white,
      importance: NotificationImportance.High,
    ),
  ];
}
