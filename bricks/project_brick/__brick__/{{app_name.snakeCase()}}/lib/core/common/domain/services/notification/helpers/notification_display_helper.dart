import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'notification_channels.dart';

/// Reports a display error. The foreground service forwards it to the
/// logger; the background isolate (no DI) uses `dart:developer`.
typedef NotificationErrorReporter =
    void Function(String message, Object error, StackTrace stackTrace);

/// Renders local notifications with `awesome_notifications`.
///
/// Has no DI dependencies so it can be used from the FCM background isolate.
class NotificationDisplayHelper {
  const NotificationDisplayHelper({
    required AwesomeNotifications awesomeNotifications,
    required NotificationErrorReporter onError,
  }) : _awesomeNotifications = awesomeNotifications,
       _onError = onError;

  final AwesomeNotifications _awesomeNotifications;
  final NotificationErrorReporter _onError;

  /// Shows [message] using its `notification` block, falling back to
  /// `data.title` / `data.body` for data-only messages.
  Future<void> showRemoteMessage(RemoteMessage message) async {
    if (kIsWeb) {
      return;
    }
    final notification = message.notification;
    final title = notification?.title ?? _string(message.data['title']);
    final body = notification?.body ?? _string(message.data['body']);
    if (title == null && body == null) {
      return;
    }
    final imageUrl = defaultTargetPlatform == TargetPlatform.iOS
        ? notification?.apple?.imageUrl
        : notification?.android?.imageUrl;

    try {
      await _awesomeNotifications.createNotification(
        content: NotificationContent(
          id: notificationIdFor(message),
          channelKey: NotificationChannelConfig.highImportanceKey,
          title: title,
          body: body,
          bigPicture: imageUrl,
          largeIcon: imageUrl,
          notificationLayout: imageUrl != null
              ? NotificationLayout.BigPicture
              : NotificationLayout.Default,
          payload: message.data.map(
            (key, Object? value) => MapEntry(key, value?.toString()),
          ),
        ),
      );
    } catch (e, s) {
      _onError('Error showing push notification', e, s);
    }
  }

  Future<void> showProgressNotification({
    required int id,
    required String title,
    required String body,
    required int progress,
  }) async {
    try {
      await _awesomeNotifications.createNotification(
        content: NotificationContent(
          id: id,
          channelKey: NotificationChannelConfig.progressKey,
          title: title,
          body: body,
          notificationLayout: NotificationLayout.ProgressBar,
          progress: progress.toDouble(),
          locked: true,
        ),
      );
    } catch (e, s) {
      _onError('Error showing progress notification', e, s);
    }
  }

  Future<void> showSimpleNotification({
    required int id,
    required String title,
    required String body,
    Map<String, String?>? payload,
  }) async {
    try {
      await _awesomeNotifications.createNotification(
        content: NotificationContent(
          id: id,
          channelKey: NotificationChannelConfig.highImportanceKey,
          title: title,
          body: body,
          payload: payload,
        ),
      );
    } catch (e, s) {
      _onError('Error showing simple notification', e, s);
    }
  }

  Future<void> cancel(int id) => _awesomeNotifications.cancel(id);

  Future<void> cancelAll() => _awesomeNotifications.cancelAll();

  /// Stable, positive 31-bit id derived from the FCM message id.
  @visibleForTesting
  static int notificationIdFor(RemoteMessage message) {
    final source =
        message.messageId ?? '${DateTime.now().microsecondsSinceEpoch}';
    return source.hashCode & 0x7fffffff;
  }

  static String? _string(Object? value) => value is String ? value : null;
}
