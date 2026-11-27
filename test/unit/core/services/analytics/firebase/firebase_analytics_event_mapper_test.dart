import 'package:flutter_all_template/core/services/analytics/data/firebase/firebase_analytics_event_mapper.dart';
import 'package:flutter_all_template/core/services/analytics/domain/analytics_event.dart';
import 'package:flutter_all_template/core/services/analytics/domain/analytics_event_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const mapper = FirebaseAnalyticsEventMapper();

  AnalyticsEvent event({String? correlationId}) => AnalyticsEvent(
    id: 'e1',
    type: AnalyticsEventType.action,
    name: 'todo_toggle',
    occurredAt: DateTime.utc(2026),
    anonymousId: 'anon-1',
    sessionId: 'session-1',
    userId: 'user-1',
    correlationId: correlationId,
    parameters: const {'is_done': true, 'count': 2, 'filter': 'open'},
  );

  test('maps bools to 1/0 and adds ids for correlation', () {
    expect(mapper.parameters(event: event(correlationId: 'e1')), {
      'is_done': 1,
      'count': 2,
      'filter': 'open',
      'event_id': 'e1',
      'occurred_at': '2026-01-01T00:00:00.000Z',
      'session_id': 'session-1',
      'correlation_id': 'e1',
    });
  });

  test('omits the correlation id when there is none', () {
    expect(
      mapper.parameters(event: event()).containsKey('correlation_id'),
      isFalse,
    );
  });

  test('never forwards identity as an event parameter', () {
    final parameters = mapper.parameters(event: event()).values;
    expect(parameters, isNot(contains('user-1')));
    expect(parameters, isNot(contains('anon-1')));
  });
}
