import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:injectable/injectable.dart';

import '../domain/notification_permission_api.dart';
import 'push/push_messaging_client.dart';
import 'push_token_sync.dart';

/// Notification permission for the permission feature.
///
/// Local display (awesome_notifications) and push delivery (FCM, which on iOS
/// has its own authorization) are separate OS permissions; notifications only
/// count as allowed when **both** are granted.
@LazySingleton(as: INotificationPermissionApi)
class NotificationPermissionService implements INotificationPermissionApi {
  NotificationPermissionService({
    required AwesomeNotifications awesome,
    required IPushMessagingClient push,
    required PushTokenSync tokens,
  }) : _awesome = awesome,
       _push = push,
       _tokens = tokens;

  final AwesomeNotifications _awesome;
  final IPushMessagingClient _push;
  final PushTokenSync _tokens;

  @override
  Future<bool> isPermissionGranted() => _awesome.isNotificationAllowed();

  @override
  Future<bool> requestPermission() async {
    var displayAllowed = await _awesome.isNotificationAllowed();
    if (!displayAllowed) {
      displayAllowed = await _awesome.requestPermissionToSendNotifications();
    }
    final pushAllowed = await _push.requestPermission();
    final allowed = displayAllowed && pushAllowed;
    if (allowed) {
      // A token may only be obtainable now that push is authorized.
      await _tokens.sync();
    }
    return allowed;
  }
}
