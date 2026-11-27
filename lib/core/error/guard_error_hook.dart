/// Where [guard] reports errors that are not an `AppException` (a bug, not a
/// failure the user can act on).
///
/// Assigned exactly once, by the app's `AppErrorReporter.install()`. It
/// defaults to a no-op so pure unit tests need no setup.
abstract final class GuardErrorHook {
  static void Function(Object error, StackTrace stackTrace) onUnexpectedError =
      (_, _) {};
}
