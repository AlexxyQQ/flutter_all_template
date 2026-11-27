/// App-wide analytics: actions, screens and errors, attributed per user.
///
/// Nothing here ever throws into the caller (storage, network and invalid
/// input are logged instead), and every call is safe before [initialize]
/// finishes and while signed out (events are then anonymous). Calls are applied
/// in order, so an event is always stamped with the identity active at the
/// moment it was tracked.
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
  /// localization key or a fixed exception category), never its message.
  ///
  /// [correlationId] (from [trackAction]) links the error to the action that
  /// caused it; without it the error stands alone.
  void trackError({
    required String source,
    required Object error,
    String? correlationId,
    bool fatal = false,
  });

  /// Sign-in hook: attributes subsequent events to [userId].
  ///
  /// [userId] must be an opaque id (database id/UUID), never an e-mail or a
  /// phone number. Such a value is rejected with a logged warning and the
  /// identity is cleared instead, so events never stay attributed to the
  /// previous user.
  Future<void> identify({required String userId});

  /// Sign-out hook: subsequent events are anonymous, under a new anonymous
  /// id so they cannot be linked to the previous user.
  Future<void> clearIdentity();

  /// Delivers queued events now (best effort; failures stay queued).
  Future<void> flush();

  /// Stops periodic delivery and waits for work in progress.
  Future<void> dispose();
}
