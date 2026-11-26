import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:injectable/injectable.dart';

import 'notification_permission_api.dart';
import 'notification_service.dart';

@module
abstract class NotificationModule {
  @lazySingleton
  AwesomeNotifications get awesomeNotifications => AwesomeNotifications();

  /// The permission feature depends on this interface, not on the service.
  @lazySingleton
  NotificationPermissionApi notificationPermissionApi(
    NotificationService service,
  ) => service;
}
