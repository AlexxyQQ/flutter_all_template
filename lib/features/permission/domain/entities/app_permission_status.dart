/// Domain view of an OS permission status.
///
/// Mirrors the platform states without leaking `permission_handler` types
/// into the domain/presentation layers.
enum AppPermissionStatus {
  /// Not requested yet, or denied once (can ask again).
  denied,

  /// Fully granted.
  granted,

  /// Granted with limitations (e.g. iOS limited photo library).
  limited,

  /// iOS provisional notifications.
  provisional,

  /// Blocked by the OS (parental controls etc.); the user cannot change it.
  restricted,

  /// Denied with "don't ask again": only the system settings can grant it.
  permanentlyDenied;

  /// Whether the feature guarded by this permission can be used.
  bool get isGranted =>
      this == granted || this == limited || this == provisional;

  /// Whether asking again is pointless and the user must open settings.
  bool get requiresSettings => this == permanentlyDenied || this == restricted;
}
