import 'package:flutter_all_template/core/services/analytics/data/analytics_identity_store_impl.dart';
import 'package:flutter_all_template/core/services/analytics/data/analytics_queue_store_impl.dart';
import 'package:flutter_all_template/core/services/analytics/domain/analytics_event.dart';
import 'package:flutter_all_template/core/services/analytics/domain/analytics_event_type.dart';
import 'package:flutter_all_template/core/services/analytics/domain/analytics_identity.dart';
import 'package:flutter_all_template/core/services/analytics/domain/queued_analytics_event.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/in_memory_analytics_storage.dart';

QueuedAnalyticsEvent _entry(String id, DateTime at) => QueuedAnalyticsEvent(
  event: AnalyticsEvent(
    id: id,
    type: AnalyticsEventType.action,
    name: 'tap',
    occurredAt: at,
    anonymousId: 'anon',
    sessionId: 'session',
    userId: 'user-1',
    correlationId: id,
    parameters: const {'count': 2, 'is_done': true, 'filter': 'open'},
  ),
  pendingDestinations: const {'api', 'firebase'},
  attempts: 1,
);

void main() {
  late InMemoryAnalyticsStorage storage;

  setUp(() => storage = InMemoryAnalyticsStorage());

  group('AnalyticsQueueStoreImpl', () {
    test('round-trips entries, oldest first', () async {
      final store = AnalyticsQueueStoreImpl(storage: storage);
      final newer = _entry('b', DateTime.utc(2026, 1, 2));
      final older = _entry('a', DateTime.utc(2026));

      await store.save(entry: newer);
      await store.save(entry: older);

      expect(await store.load(), [older, newer]);
    });

    test('remove deletes only that entry', () async {
      final store = AnalyticsQueueStoreImpl(storage: storage);
      await store.save(entry: _entry('a', DateTime.utc(2026)));
      await store.save(entry: _entry('b', DateTime.utc(2026)));

      await store.remove(eventId: 'a');

      expect((await store.load()).map((e) => e.event.id), ['b']);
    });

    test('discards unreadable entries and ignores foreign keys', () async {
      final store = AnalyticsQueueStoreImpl(storage: storage);
      await store.save(entry: _entry('good', DateTime.utc(2026)));
      storage.values['${AnalyticsQueueStoreImpl.keyPrefix}bad'] = '{"nope":';
      storage.values['other.feature.key'] = 'untouched';

      final loaded = await store.load();

      expect(loaded.map((e) => e.event.id), ['good']);
      expect(
        storage.values.containsKey('${AnalyticsQueueStoreImpl.keyPrefix}bad'),
        isFalse,
      );
      expect(storage.values['other.feature.key'], 'untouched');
    });
  });

  group('AnalyticsIdentityStoreImpl', () {
    test('round-trips signed-in and anonymous identities', () async {
      final store = AnalyticsIdentityStoreImpl(storage: storage);

      expect(await store.read(), isNull);
      await store.write(
        identity: const AnalyticsIdentity(anonymousId: 'a', userId: 'u'),
      );
      expect(
        await store.read(),
        const AnalyticsIdentity(anonymousId: 'a', userId: 'u'),
      );
      await store.write(identity: const AnalyticsIdentity(anonymousId: 'b'));
      expect(await store.read(), const AnalyticsIdentity(anonymousId: 'b'));
    });
  });
}
