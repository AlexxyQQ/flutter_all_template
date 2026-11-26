import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_all_template/core/common/domain/services/analytics/data/destinations/api_analytics_destination.dart';
import 'package:flutter_all_template/core/common/domain/services/analytics/domain/analytics_event.dart';
import 'package:flutter_all_template/core/common/domain/services/analytics/domain/analytics_event_type.dart';
import 'package:flutter_test/flutter_test.dart';

import '../network/helpers/fake_http_adapter.dart';

final _event = AnalyticsEvent(
  id: 'e1',
  type: AnalyticsEventType.action,
  name: 'todo_create',
  occurredAt: DateTime.utc(2026, 1, 1, 10),
  anonymousId: 'anon-1',
  sessionId: 'session-1',
  userId: 'user-1',
  correlationId: 'e1',
  parameters: const {'title_length': 8, 'is_done': true},
);

void main() {
  group('ApiAnalyticsDestination', () {
    late FakeHttpAdapter adapter;
    late ApiAnalyticsDestination destination;

    setUp(() {
      adapter = FakeHttpAdapter((_) async => jsonBody(null, 204));
      destination = ApiAnalyticsDestination(
        dio: Dio()..httpClientAdapter = adapter,
        endpoint: 'https://analytics.example.com/v1/events',
      );
    });

    test('posts the batch with identity and correlation per event', () async {
      await destination.send(events: [_event]);

      final request = adapter.requests.single;
      expect(request.method, 'POST');
      expect(request.uri.toString(), 'https://analytics.example.com/v1/events');
      final body = jsonDecode(jsonEncode(request.data)) as Map<String, Object?>;
      expect(body['events'], [
        {
          'id': 'e1',
          'type': 'action',
          'name': 'todo_create',
          'occurred_at': '2026-01-01T10:00:00.000Z',
          'anonymous_id': 'anon-1',
          'session_id': 'session-1',
          'user_id': 'user-1',
          'correlation_id': 'e1',
          'parameters': {'title_length': 8, 'is_done': true},
        },
      ]);
    });

    test('never attaches credentials', () async {
      await destination.send(events: [_event]);

      expect(
        adapter.requests.single.headers.keys.map((k) => k.toLowerCase()),
        isNot(contains('authorization')),
      );
    });

    test('throws when the server does not acknowledge the batch', () {
      adapter.handler = (_) async => jsonBody(null, 503);

      expect(destination.send(events: [_event]), throwsA(isA<DioException>()));
    });

    test('sends nothing for an empty batch', () async {
      await destination.send(events: const []);

      expect(adapter.requests, isEmpty);
    });
  });
}
