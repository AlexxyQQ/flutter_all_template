import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationChannelConfig {
  static const String highImportanceKey = 'high_importance';
  static const String progressKey = 'progress_channel';

  static List<NotificationChannel> get channels => [
    NotificationChannel(
      channelKey: highImportanceKey,
      channelName: 'High Importance Notifications',
      channelDescription: 'Important notifications from the app.',
      defaultColor: const Color(0xFF9D50DD),
      ledColor: Colors.white,
      importance: NotificationImportance.High,
    ),
    NotificationChannel(
      channelKey: progressKey,
      channelName: 'Progress Notifications',
      channelDescription: 'Notifications that show task progress.',
      importance: NotificationImportance.Low,
      onlyAlertOnce: true,
    ),
  ];
}
