import 'package:injectable/injectable.dart';

import '../../domain/analytics_event.dart';

/// Converts an [AnalyticsEvent] into Firebase Analytics parameters
/// (`String`/`num` values only; bools become `1`/`0`).
///
/// Pure Dart, so the mapping is unit-tested without Firebase.
@lazySingleton
class FirebaseAnalyticsEventMapper {
  const FirebaseAnalyticsEventMapper();

  Map<String, Object> parameters({required AnalyticsEvent event}) => {
    for (final entry in event.parameters.entries.take(21))
      entry.key: switch (entry.value) {
        final bool value => value ? 1 : 0,
        final Object value => value,
      },
    'event_id': event.id,
    'occurred_at': event.occurredAt.toUtc().toIso8601String(),
    'session_id': event.sessionId,
    'correlation_id': ?event.correlationId,
  };
}
