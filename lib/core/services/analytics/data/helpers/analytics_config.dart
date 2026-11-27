/// Runtime tuning of the analytics pipeline. Built from `AppEnv` in
/// `AnalyticsModule`; tests construct it directly.
final class AnalyticsConfig {
  const AnalyticsConfig({
    required this.enabled,
    this.batchSize = 20,
    this.flushInterval = const Duration(seconds: 30),
    this.maxQueueSize = 500,
    this.maxAttempts = 10,
  }) : assert(batchSize > 0),
       assert(maxQueueSize > 0),
       assert(maxAttempts > 0);

  /// Master switch. When `false` nothing is stored or sent.
  final bool enabled;

  /// Events sent per destination request; reaching it triggers a flush.
  final int batchSize;

  /// How often queued events are flushed while the app runs.
  final Duration flushInterval;

  /// Oldest events are dropped beyond this many (bounds storage offline).
  final int maxQueueSize;

  /// An event is dropped after this many failed delivery attempts.
  final int maxAttempts;
}
