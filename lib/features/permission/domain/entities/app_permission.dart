/// Every OS permission the app knows how to ask for.
///
/// Adding a permission: add a value here, its platform mapping in
/// `data/helpers/platform_permissions.dart`, its icon in
/// `presentation/helpers/permission_content.dart` and the locale keys
/// `features.permission.<name>.*`. The exhaustive switches make the compiler
/// point at the first two.
enum AppPermission {
  notification,
  location,
  storage,
  camera,
  microphone,
  contacts,
  calendar,
  bluetooth,
  phone,
  activityRecognition;

  /// Parses a route/path parameter. Returns `null` for unknown values so
  /// callers never act on arbitrary input.
  static AppPermission? tryParse(String? value) {
    for (final permission in values) {
      if (permission.name == value) {
        return permission;
      }
    }
    return null;
  }
}
