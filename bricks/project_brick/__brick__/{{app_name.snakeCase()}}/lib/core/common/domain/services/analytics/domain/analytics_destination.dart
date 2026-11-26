import 'analytics_event.dart';

/// Where analytics events are delivered (custom API, Firebase, ...).
abstract interface class IAnalyticsDestination {
  /// Stable id, persisted with queued events. Never change it once shipped.
  String get id;

  /// Delivers [events] (oldest first). Throws when they were not accepted;
  /// they then stay queued and are retried.
  Future<void> send({required List<AnalyticsEvent> events});
}
