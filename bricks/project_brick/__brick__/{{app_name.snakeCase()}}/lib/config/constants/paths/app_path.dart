class AppPaths {
  // ─────────────────────────────────────────────
  // Root & Core
  // ─────────────────────────────────────────────
  static const String splashRoute = '/';
  static const String bottomNavRoute = '/app';

  // ─────────────────────────────────────────────
  // Permission
  // ─────────────────────────────────────────────
  static const String permission = '/permission';

  /// Name of the path parameter holding `AppPermission.name`.
  static const String permissionParam = 'permission';

  /// Route pattern: `/permission/:permission`.
  static const String permissionPattern = '$permission/:$permissionParam';

  /// Concrete path for one permission, e.g. `/permission/camera`.
  static String permissionPath(String permissionName) =>
      '$permission/$permissionName';

  // ─────────────────────────────────────────────
  // Features
  // ─────────────────────────────────────────────

  // Another Feature
  static const String anotherFeature = '/another';
  static const String anotherScreen = 'another-screen';
  static const String notificationDebugger = 'notification-debugger';
  static const String permissionTest = 'permission-test';
}
