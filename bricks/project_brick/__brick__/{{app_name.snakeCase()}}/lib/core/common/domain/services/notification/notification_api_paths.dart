/// Backend endpoints used by the notification module.
abstract final class NotificationApiPaths {
  /// `POST` registers a device push token, `DELETE` unregisters it.
  /// Body: `{"token": "...", "platform": "android|iOS"}`.
  static const String pushToken = '/devices/push-token';
}
