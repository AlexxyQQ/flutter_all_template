import 'analytics_event.dart';

/// Where analytics events are delivered (custom API, Firebase, ...).
abstract interface class IAnalyticsDestination {
  /// Stable id, persisted with queued events. Never change it once shipped.
  String get id;

  /// Called when the active user changes (sign-in, sign-out) and once when the
  /// persisted identity is loaded; `null` means anonymous. Destinations with
  /// their own notion of a user (Firebase) update it here, once, instead of
  /// per event. Others implement it as a no-op.
  Future<void> setUserId({required String? userId});

  /// Delivers [events] (oldest first). Throws when they were not accepted;
  /// they then stay queued and are retried.
  Future<void> send({required List<AnalyticsEvent> events});
}
