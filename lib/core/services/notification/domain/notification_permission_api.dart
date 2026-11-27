/// Notification permission as exposed to other modules (e.g. the permission
/// feature). Implemented by `NotificationService`.
abstract interface class INotificationPermissionApi {
  Future<bool> isPermissionGranted();

  /// Shows the OS prompt if needed. Returns whether notifications are allowed.
  Future<bool> requestPermission();
}
