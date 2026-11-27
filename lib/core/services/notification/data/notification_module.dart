import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:injectable/injectable.dart';

import '../domain/notification_launch.dart';
import 'notification_tap_router.dart';

@module
abstract class NotificationModule {
  @lazySingleton
  AwesomeNotifications get awesomeNotifications => AwesomeNotifications();

  /// The splash depends on this interface, not on the router implementation.
  @lazySingleton
  INotificationLaunch notificationLaunch(NotificationTapRouter router) =>
      router;
}
