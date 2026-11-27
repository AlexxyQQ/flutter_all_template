abstract final class AppPaths {
  // ─────────────────────────────────────────────
  // Root & Core
  // ─────────────────────────────────────────────
  static const String splashRoute = '/';
  static const String home = '/home';

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
}
