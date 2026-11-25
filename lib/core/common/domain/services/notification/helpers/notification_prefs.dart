/// Preference keys shared by the foreground service and the background
/// isolate handler (which reads `SharedPreferences` directly, without DI).
abstract final class NotificationPrefs {
  /// `bool`, defaults to `true`.
  static const String enabledKey = 'app_notifications_enabled';
}
