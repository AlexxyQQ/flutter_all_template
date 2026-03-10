import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../logger/logger_service.dart';
import 'notification_channels.dart';

class NotificationDisplayHelper {
  NotificationDisplayHelper(this._awesomeNotifications, this._logger);
  final AwesomeNotifications _awesomeNotifications;
  final ILoggerService _logger;

  Future<void> showNotification(
    RemoteMessage message, {
    required Future<void> Function() onRequestPermission,
    bool isAppInForeground = false,
  }) async {
    final notification = message.notification;
    if (notification == null || kIsWeb) return;

    try {
      _logger.d('Showing notification: ${notification.title}');

      // [FIX 3] iOS Image Rendering Failure
      String? imageUrl;
      if (Platform.isIOS) {
        imageUrl = notification.apple?.imageUrl;
      } else {
        imageUrl = notification.android?.imageUrl;
      }

      await _awesomeNotifications.createNotification(
        content: NotificationContent(
          id: notification.hashCode,
          channelKey: NotificationChannelConfig.highImportanceKey,
          title: notification.title,
          body: notification.body,
          bigPicture: imageUrl,
          largeIcon: imageUrl,
          notificationLayout: imageUrl != null
              ? NotificationLayout.BigPicture
              : NotificationLayout.Default,
          payload: message.data.map(
            (key, value) => MapEntry(key, value.toString()),
          ),
        ),
      );
    } catch (e, s) {
      _logger.e('Error showing notification', error: e, stackTrace: s);

      // [FIX 1] Background UI Crash protection
      if (isAppInForeground) {
        if ((e is PlatformException) &&
            (e.code == 'INSUFFICIENT_PERMISSIONS')) {
          _showPermissionDialog(onRequestPermission);
        }
      }
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
          progress: double.tryParse('${progress}'),
          locked: true,
        ),
      );
    } catch (e) {
      _logger.e('Error showing progress notification', error: e);
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
    } catch (e) {
      _logger.e('Error showing simple notification', error: e);
    }
  }

  Future<void> cancelNotification(int id) async {
    await _awesomeNotifications.cancel(id);
  }

  void _showPermissionDialog(Future<void> Function() onConfirmAction) {
    // TODO: only if you don't have dedicated permission page Else don't use this
    return;
    // [FIX 4] Navigation Service Race Condition check
    // if (sl.isRegistered<NavigationService>()) {
    //   final navService = sl<NavigationService>();
    //   if (!navService.checkIfAlreadyOpened(name: AppDialogRoute.name)) {
    //     navService.closeSpecificRoute(name: AppDialogRoute.name);
    //     navService.push(
    //       AppDialogRoute(
    //         type: DialogType.info,
    //         isDismissible: true,
    //         title: LocaleKeys.common_sentences_notification_permission_requir
    //             .tr(),
    //         message: LocaleKeys.common_sentences_the_app_does_not_have_notifica
    //             .tr(),
    //         confirmText: 'Ask Permission',
    //         onConfirm: () async {
    //           await onConfirmAction();
    //         },
    //       ),
    //     );
    //   }
    // }
  }
}
