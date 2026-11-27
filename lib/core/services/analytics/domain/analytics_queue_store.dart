import 'queued_analytics_event.dart';

/// Durable queue of undelivered analytics events.
abstract interface class IAnalyticsQueueStore {
  /// Every queued event, oldest first. Unreadable entries are discarded.
  Future<List<QueuedAnalyticsEvent>> load();

  /// Inserts or replaces the entry for `entry.event.id`.
  Future<void> save({required QueuedAnalyticsEvent entry});

  Future<void> remove({required String eventId});
}
