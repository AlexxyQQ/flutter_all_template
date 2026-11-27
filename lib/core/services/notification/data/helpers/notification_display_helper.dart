import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../logger/domain/logger_service.dart';
import 'notification_channels.dart';

/// Renders local notifications with `awesome_notifications`.
///
/// Injected in the app; the FCM background isolate (no DI) builds it directly
/// with `AppLogger.service`.
@lazySingleton
class NotificationDisplayHelper {
  const NotificationDisplayHelper({
    required AwesomeNotifications awesome,
    required ILoggerService logger,
  }) : _awesome = awesome,
       _logger = logger;

  final AwesomeNotifications _awesome;
  final ILoggerService _logger;

  /// Registers the channels. Throws [StateError] if the plugin is not ready.
  Future<void> initialize() async {
    final ready = await _awesome.initialize(
      null,
      NotificationChannelConfig.channels,
      debug: kDebugMode,
    );
    if (!ready) {
      throw StateError('Notification plugin initialization failed');
    }
  }

  /// Shows [message] using its `notification` block, falling back to
  /// `data.title` / `data.body` for data-only messages.
  Future<void> showRemoteMessage({required RemoteMessage message}) async {
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
      await _awesome.createNotification(
        content: NotificationContent(
          id: notificationIdFor(message: message),
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
      _logger.error('Error showing push notification', error: e, stackTrace: s);
    }
  }

  Future<void> cancel({required int id}) => _awesome.cancel(id);

  Future<void> cancelAll() => _awesome.cancelAll();

  /// Positive 31-bit id derived from the FCM message id with FNV-1a over its
  /// UTF-8 bytes, so the same message id maps to the same notification id on
  /// every run (`String.hashCode` is not stable across runs). A message
  /// without an id gets a unique, time-based one.
  @visibleForTesting
  static int notificationIdFor({required RemoteMessage message}) {
    const fnvOffsetBasis = 0x811c9dc5;
    const fnvPrime = 0x01000193;
    final source =
        message.messageId ?? '${DateTime.now().microsecondsSinceEpoch}';
    var hash = fnvOffsetBasis;
    for (final byte in utf8.encode(source)) {
      hash = ((hash ^ byte) * fnvPrime) & 0xffffffff;
    }
    return hash & 0x7fffffff;
  }

  static String? _string(Object? value) => value is String ? value : null;
}
