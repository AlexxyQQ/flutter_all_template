import '../domain/analytics_event.dart';
import '../domain/analytics_event_type.dart';
import '../domain/queued_analytics_event.dart';

/// JSON shape of analytics events, used both for the durable queue and as
/// the custom API wire format. Decoding throws [FormatException] on bad data.
abstract final class AnalyticsEventJson {
  static Map<String, Object?> encodeEvent({required AnalyticsEvent event}) => {
    'id': event.id,
    'type': event.type.name,
    'name': event.name,
    'occurred_at': event.occurredAt.toUtc().toIso8601String(),
    'anonymous_id': event.anonymousId,
    'session_id': event.sessionId,
    'user_id': event.userId,
    'correlation_id': event.correlationId,
    'parameters': event.parameters,
  };

  static AnalyticsEvent decodeEvent({required Map<String, Object?> json}) {
    final type = AnalyticsEventType.values.asNameMap()[json['type']];
    final occurredAt = DateTime.tryParse(_string(json, 'occurred_at'));
    final parameters = json['parameters'];
    if (type == null || occurredAt == null || parameters is! Map) {
      throw const FormatException('Invalid analytics event');
    }
    return AnalyticsEvent(
      id: _string(json, 'id'),
      type: type,
      name: _string(json, 'name'),
      occurredAt: occurredAt.toUtc(),
      anonymousId: _string(json, 'anonymous_id'),
      sessionId: _string(json, 'session_id'),
      userId: json['user_id'] as String?,
      correlationId: json['correlation_id'] as String?,
      parameters: {
        for (final entry in parameters.entries)
          if (entry.key is String &&
              (entry.value is String ||
                  entry.value is num ||
                  entry.value is bool))
            entry.key as String: entry.value as Object,
      },
    );
  }

  static Map<String, Object?> encodeQueued({
    required QueuedAnalyticsEvent entry,
  }) => {
    'event': encodeEvent(event: entry.event),
    'pending': entry.pendingDestinations.toList(),
    'attempts': entry.attempts,
  };

  static QueuedAnalyticsEvent decodeQueued({
    required Map<String, Object?> json,
  }) {
    final event = json['event'];
    final pending = json['pending'];
    final attempts = json['attempts'];
    if (event is! Map<String, Object?> ||
        pending is! List ||
        attempts is! int) {
      throw const FormatException('Invalid queued analytics event');
    }
    return QueuedAnalyticsEvent(
      event: decodeEvent(json: event),
      pendingDestinations: pending.whereType<String>().toSet(),
      attempts: attempts,
    );
  }

  static String _string(Map<String, Object?> json, String key) {
    final value = json[key];
    if (value is! String || value.isEmpty) {
      throw FormatException('Missing "$key"');
    }
    return value;
  }
}
