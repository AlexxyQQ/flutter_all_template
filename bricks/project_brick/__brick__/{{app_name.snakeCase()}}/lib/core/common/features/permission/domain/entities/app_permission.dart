/// Every OS permission the app knows how to ask for.
///
/// Adding a permission = add a value here + one row in `permissionSpecs`
/// (`permission_spec.dart`). Nothing else needs to change.
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
    if (value == null) {
      return null;
    }
    for (final permission in values) {
      if (permission.name == value) {
        return permission;
      }
    }
    return null;
  }
}
