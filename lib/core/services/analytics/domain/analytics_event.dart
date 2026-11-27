import 'package:equatable/equatable.dart';

import 'analytics_event_type.dart';

/// One sanitized analytics event, stamped with the identity that was active
/// when it was tracked.
///
/// [parameters] only ever hold sanitized `String`, `num` or `bool` values;
/// raw user input, route arguments and error messages never reach here.
final class AnalyticsEvent extends Equatable {
  const AnalyticsEvent({
    required this.id,
    required this.type,
    required this.name,
    required this.occurredAt,
    required this.anonymousId,
    required this.sessionId,
    this.userId,
    this.correlationId,
    this.parameters = const {},
  });

  /// Unique event id. For actions it doubles as the correlation id that
  /// follow-up errors point to.
  final String id;
  final AnalyticsEventType type;

  /// `snake_case` event name (Firebase-compatible, at most 40 characters).
  final String name;

  /// UTC time the event was tracked (not when it was delivered).
  final DateTime occurredAt;

  /// Random per-install id; rotated on sign-out.
  final String anonymousId;

  /// Random id of one launch under one identity: it is renewed on sign-in and
  /// sign-out so two users are never linked through a shared session.
  final String sessionId;

  /// Opaque app user id, or `null` for anonymous events.
  final String? userId;

  /// Id of the action this event belongs to (errors raised by that action).
  final String? correlationId;
  final Map<String, Object> parameters;

  @override
  List<Object?> get props => [
    id,
    type,
    name,
    occurredAt,
    anonymousId,
    sessionId,
    userId,
    correlationId,
    parameters,
  ];

  // Identity fields are pseudonymous personal data: keep them out of logs.
  @override
  String toString() => 'AnalyticsEvent(${type.name}: $name)';
}
