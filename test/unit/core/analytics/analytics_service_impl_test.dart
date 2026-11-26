import 'dart:async';

import 'package:flutter_all_template/core/common/domain/entities/failure.dart';
import 'package:flutter_all_template/core/common/domain/services/analytics/analytics_destination_registry.dart';
import 'package:flutter_all_template/core/common/domain/services/analytics/analytics_service_impl.dart';
import 'package:flutter_all_template/core/common/domain/services/analytics/data/analytics_identity_store_impl.dart';
import 'package:flutter_all_template/core/common/domain/services/analytics/data/analytics_queue_store_impl.dart';
import 'package:flutter_all_template/core/common/domain/services/analytics/domain/analytics_event_type.dart';
import 'package:flutter_all_template/core/common/domain/services/analytics/domain/analytics_identity.dart';
import 'package:flutter_all_template/core/common/domain/services/analytics/helpers/analytics_config.dart';
import 'package:flutter_all_template/core/common/domain/services/analytics/helpers/analytics_sanitizer.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/in_memory_analytics_storage.dart';
import 'helpers/recording_analytics_destination.dart';
import 'helpers/sequential_id_generator.dart';

void main() {
  late InMemoryAnalyticsStorage storage;
  late SequentialIdGenerator ids;
  late RecordingAnalyticsDestination destination;
  final services = <AnalyticsServiceImpl>[];

  AnalyticsServiceImpl build({
    AnalyticsConfig config = const AnalyticsConfig(enabled: true),
    List<RecordingAnalyticsDestination>? destinations,
  }) {
    final service = AnalyticsServiceImpl(
      config: config,
      registry: AnalyticsDestinationRegistry(
        destinations: destinations ?? [destination],
      ),
      queueStore: AnalyticsQueueStoreImpl(storage: storage),
      identityStore: AnalyticsIdentityStoreImpl(storage: storage),
      sanitizer: const AnalyticsSanitizer(),
      idGenerator: ids,
    );
    services.add(service);
    return service;
  }

  Iterable<String> queuedKeys() => storage.values.keys.where(
    (k) => k.startsWith(AnalyticsQueueStoreImpl.keyPrefix),
  );

  setUp(() {
    storage = InMemoryAnalyticsStorage();
    ids = SequentialIdGenerator();
    destination = RecordingAnalyticsDestination();
  });

  tearDown(() async {
    for (final service in services) {
      await service.dispose();
    }
    services.clear();
  });

  test('anonymous actions are delivered with an anonymous id', () async {
    final service = build();
    await service.initialize();

    service.trackAction(name: 'todo_create', parameters: {'count': 2});
    await service.flush();

    final event = destination.events.single;
    expect(event.type, AnalyticsEventType.action);
    expect(event.name, 'todo_create');
    expect(event.userId, isNull);
    expect(event.anonymousId, isNotEmpty);
    expect(event.parameters, {'count': 2});
    expect(event.correlationId, event.id);
  });

  test('events tracked before initialize are kept and delivered', () async {
    final service = build()..trackAction(name: 'early');
    await service.initialize();
    await service.flush();

    expect(destination.events.map((e) => e.name), ['early']);
  });

  test('each queued event keeps the identity it was tracked under', () async {
    final service = build();
    destination.failing = true; // keep everything queued until the end

    service.trackAction(name: 'before_sign_in');
    await service.identify(userId: 'user-42');
    service.trackAction(name: 'signed_in');
    await service.clearIdentity();
    service.trackAction(name: 'after_sign_out');
    await service.flush();

    destination.failing = false;
    await service.flush();

    final events = {for (final e in destination.events) e.name: e};
    expect(events['before_sign_in']!.userId, isNull);
    expect(events['signed_in']!.userId, 'user-42');
    expect(events['after_sign_out']!.userId, isNull);
    expect(
      events['signed_in']!.anonymousId,
      events['before_sign_in']!.anonymousId,
    );
    expect(
      events['after_sign_out']!.anonymousId,
      isNot(events['signed_in']!.anonymousId),
      reason: 'sign-out must unlink later events from the previous user',
    );
  });

  test(
    'clearIdentity keeps the anonymous id when nobody is signed in',
    () async {
      final service = build()..trackAction(name: 'one');
      await service.clearIdentity();
      service.trackAction(name: 'two');
      await service.flush();

      final [one, two] = destination.events;
      expect(two.anonymousId, one.anonymousId);
    },
  );

  test('identify rejects e-mails and phone numbers', () {
    final service = build();

    expect(
      () => service.identify(userId: 'jane@example.com'),
      throwsArgumentError,
    );
    expect(
      () => service.identify(userId: '+9779812345678'),
      throwsArgumentError,
    );
  });

  test('the identity survives a restart', () async {
    final first = build();
    await first.identify(userId: 'user-7');
    await first.dispose();

    final second = build()..trackAction(name: 'after_restart');
    await second.flush();

    expect(destination.events.single.userId, 'user-7');
  });

  test('a queue read retry merges the backlog with new events once', () async {
    destination.failing = true;
    final first = build()..trackAction(name: 'backlog');
    await first.flush();
    await first.dispose();

    storage.failKeys = true;
    final second = build()..trackAction(name: 'new_action');
    await second.identify(userId: 'user-42'); // Wait for the enqueue.
    expect(queuedKeys(), hasLength(2));
    storage.failKeys = false;
    destination.failing = false;
    await second.flush();
    expect(destination.events.map((e) => e.name), ['backlog', 'new_action']);
    expect(queuedKeys(), isEmpty);
  });

  test('undelivered events survive a restart and are delivered once', () async {
    destination.failing = true;
    final first = build()..trackAction(name: 'offline_action');
    await first.flush();
    await first.dispose();
    expect(queuedKeys(), hasLength(1));

    destination.failing = false;
    final second = build();
    await second.initialize();
    await second.flush();

    expect(destination.events.map((e) => e.name), ['offline_action']);
    expect(queuedKeys(), isEmpty);
  });

  test(
    'a failing destination does not cause duplicates in the others',
    () async {
      final healthy = RecordingAnalyticsDestination(id: 'healthy');
      final flaky = RecordingAnalyticsDestination(id: 'flaky')..failing = true;
      final service = build(destinations: [healthy, flaky])
        ..trackAction(name: 'tap');
      await service.flush();
      flaky.failing = false;
      await service.flush();
      await service.flush();

      expect(healthy.events, hasLength(1));
      expect(flaky.events, hasLength(1));
      expect(queuedKeys(), isEmpty);
    },
  );

  test('events are dropped after the maximum number of attempts', () async {
    destination.failing = true;
    final service = build(
      config: const AnalyticsConfig(enabled: true, maxAttempts: 2),
    )..trackAction(name: 'doomed');
    await service.flush();
    expect(queuedKeys(), hasLength(1));
    await service.flush();

    expect(queuedKeys(), isEmpty);
    destination.failing = false;
    await service.flush();
    expect(destination.events, isEmpty);
  });

  test('the queue keeps only the newest events beyond its bound', () async {
    destination.failing = true;
    final service =
        build(config: const AnalyticsConfig(enabled: true, maxQueueSize: 2))
          ..trackAction(name: 'first')
          ..trackAction(name: 'second')
          ..trackAction(name: 'third');
    await service.flush();
    destination.failing = false;
    await service.flush();

    expect(destination.events.map((e) => e.name), ['second', 'third']);
  });

  test('events are sent in batches of the configured size', () async {
    final service =
        build(config: const AnalyticsConfig(enabled: true, batchSize: 2))
          ..trackAction(name: 'a')
          ..trackAction(name: 'b')
          ..trackAction(name: 'c');
    await service.flush();

    expect(destination.batches.map((b) => b.length), [2, 1]);
  });

  test('new actions persist while a destination is still sending', () async {
    final sending = Completer<void>();
    final release = Completer<void>();
    destination.beforeSend = () {
      if (!sending.isCompleted) {
        sending.complete();
      }
      return release.future;
    };
    final service = build()..trackAction(name: 'first');
    final flushing = service.flush();
    try {
      await sending.future;
      service.trackAction(name: 'second');
      await service
          .identify(userId: 'user-42')
          .timeout(const Duration(seconds: 2));
      expect(queuedKeys(), hasLength(2));
    } finally {
      release.complete();
      await flushing;
    }
    await service.flush();
    expect(destination.events.map((event) => event.name), ['first', 'second']);
  });

  group('errors', () {
    test('a late error keeps the action owner across sign-out', () async {
      final service = build();
      await service.identify(userId: 'user-42');
      final actionId = service.trackAction(name: 'todo_create');
      await service.clearIdentity();
      service
        ..trackError(
          source: 'todo_create',
          error: StateError('late response'),
          correlationId: actionId,
        )
        ..trackError(source: 'zone', error: StateError('signed out'));
      await service.flush();

      final [action, lateError, unrelatedError] = destination.events;
      expect(lateError.userId, 'user-42');
      expect(lateError.sessionId, action.sessionId);
      expect(lateError.correlationId, actionId);
      expect(unrelatedError.userId, isNull);
      expect(unrelatedError.correlationId, isNull);
      expect(unrelatedError.sessionId, isNot(action.sessionId));
    });
    test('an explicit correlation id links the error to its action', () async {
      final service = build();
      final actionId = service.trackAction(name: 'todo_create');
      service
        ..trackAction(name: 'unrelated')
        ..trackError(
          source: 'todo_create',
          error: const Failure(
            message: 'common.errors.network.noInternet',
            type: FailureType.network,
          ),
          correlationId: actionId,
        );
      await service.flush();

      final error = destination.events.last;
      expect(error.type, AnalyticsEventType.error);
      expect(error.name, 'app_error');
      expect(error.correlationId, actionId);
      expect(error.parameters, {
        'error_type': 'failure_network',
        'error_key': 'common.errors.network.noInternet',
        'error_source': 'todo_create',
        'fatal': false,
      });
    });

    test('an uncorrelated error is linked to a recent action', () async {
      final service = build();
      final actionId = service.trackAction(name: 'tap');
      service.trackError(source: 'zone', error: StateError('x'), fatal: true);
      await service.flush();

      expect(destination.events.last.correlationId, actionId);
      expect(destination.events.last.parameters['fatal'], isTrue);
    });

    test('an error long after the last action is not correlated', () async {
      final service = build(
        config: const AnalyticsConfig(
          enabled: true,
          correlationWindow: Duration(milliseconds: 1),
        ),
      )..trackAction(name: 'tap');
      await Future<void>.delayed(const Duration(milliseconds: 20));
      service.trackError(source: 'zone', error: StateError('x'));
      await service.flush();

      expect(destination.events.last.correlationId, isNull);
    });

    test('error messages are never recorded', () async {
      final service = build()
        ..trackError(
          source: 'guard',
          error: Exception('jane@example.com sent token abc'),
        );
      await service.flush();

      final values = destination.events.single.parameters.values.join(' ');
      expect(values, isNot(contains('jane')));
      expect(values, isNot(contains('token')));
    });
  });

  test('screen views carry only the route name', () async {
    final service = build()..trackScreen(name: 'TodoListRoute');
    await service.flush();

    final event = destination.events.single;
    expect(event.type, AnalyticsEventType.screen);
    expect(event.name, 'screen_view');
    expect(event.parameters, {'screen_name': 'TodoListRoute'});
  });

  test('disabled analytics stores and sends nothing', () async {
    final service = build(config: const AnalyticsConfig(enabled: false));
    await service.initialize();
    service.trackAction(name: 'tap');
    await service.identify(userId: 'user-1');
    await service.flush();

    expect(destination.attempts, 0);
    expect(storage.values, isEmpty);
  });

  test('storage failures never reach callers', () async {
    storage.failWrites = true;
    final service = build();

    await service.initialize();
    service.trackAction(name: 'tap');
    await service.identify(userId: 'user-1');
    await service.flush();

    expect(destination.events.single.userId, isNull);
  });

  test('the persisted identity is the one events are stamped with', () async {
    final service = build();
    await service.identify(userId: 'user-9');

    final stored = await AnalyticsIdentityStoreImpl(storage: storage).read();
    expect(stored, isA<AnalyticsIdentity>());
    expect(stored!.userId, 'user-9');
  });
}
