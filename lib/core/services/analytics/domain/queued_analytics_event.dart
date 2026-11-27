import 'package:equatable/equatable.dart';

import 'analytics_event.dart';

/// An [AnalyticsEvent] waiting in the durable queue, with the destinations
/// that have not acknowledged it yet.
///
/// Tracking delivery per destination means a destination that fails never
/// causes duplicates in one that already succeeded.
final class QueuedAnalyticsEvent extends Equatable {
  const QueuedAnalyticsEvent({
    required this.event,
    required this.pendingDestinations,
    this.attempts = 0,
  });

  final AnalyticsEvent event;

  /// Ids of the destinations still owed this event.
  final Set<String> pendingDestinations;

  /// Failed delivery attempts so far (across all destinations).
  final int attempts;

  bool get isDelivered => pendingDestinations.isEmpty;

  QueuedAnalyticsEvent copyWith({
    Set<String>? pendingDestinations,
    int? attempts,
  }) => QueuedAnalyticsEvent(
    event: event,
    pendingDestinations: pendingDestinations ?? this.pendingDestinations,
    attempts: attempts ?? this.attempts,
  );

  @override
  List<Object?> get props => [event, pendingDestinations, attempts];
}
