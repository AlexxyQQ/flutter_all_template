/// Hand-off for a notification that **launched** the app from a terminated
/// state.
///
/// The tap is only remembered during start-up (no router exists yet). The
/// first screen that is ready to navigate (the splash) calls
/// [openPendingLaunchDestination] once; it is a no-op when nothing is pending
/// and consumes the destination so it never opens twice.
abstract interface class INotificationLaunch {
  Future<void> openPendingLaunchDestination();
}
