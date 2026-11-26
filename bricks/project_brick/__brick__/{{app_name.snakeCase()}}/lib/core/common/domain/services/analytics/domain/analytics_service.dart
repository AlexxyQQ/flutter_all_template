/// App-wide analytics: actions, screens and errors, attributed per user.
///
/// Every call is safe before [initialize] finishes and while signed out
/// (events are then anonymous). Calls are applied in order, so an event is
/// always stamped with the identity active at the moment it was tracked.
///
/// Never pass raw user input, e-mails, tokens or error messages as
/// parameters: describe them instead (`title_length`, `has_due_date`).
/// Parameters are sanitized anyway, and suspicious values are dropped.
abstract interface class IAnalyticsService {
  /// Loads the persisted identity and queue, and starts periodic delivery.
  Future<void> initialize();

  /// Records a user action and returns its correlation id; pass it to
  /// [trackError] for failures caused by this action.
  String trackAction({
    required String name,
    Map<String, Object?> parameters = const {},
  });

  /// Records that the screen (route) [name] became visible.
  void trackScreen({required String name});

  /// Records an error. Only its kind is recorded (failure type, status code,
  /// localization key or exception type), never its message.
  ///
  /// Without [correlationId] the error is linked to the most recent action
  /// when that action happened within the configured correlation window.
  void trackError({
    required String source,
    required Object error,
    String? correlationId,
    bool fatal = false,
  });

  /// Sign-in hook: attributes subsequent events to [userId].
  ///
  /// [userId] must be an opaque id (database id/UUID), never an e-mail or a
  /// phone number; those are rejected with an [ArgumentError].
  Future<void> identify({required String userId});

  /// Sign-out hook: subsequent events are anonymous, under a new anonymous
  /// id so they cannot be linked to the previous user.
  Future<void> clearIdentity();

  /// Delivers queued events now (best effort; failures stay queued).
  Future<void> flush();

  Future<void> dispose();
}
