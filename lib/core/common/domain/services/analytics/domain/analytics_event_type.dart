/// What kind of thing an `AnalyticsEvent` records.
enum AnalyticsEventType {
  /// Something the user did (tap, submit, toggle).
  action,

  /// A screen became visible.
  screen,

  /// An error, optionally correlated with the action that caused it.
  error,
}
