import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../generic/data/async_lock.dart';
import '../../logger/data/app_logger.dart';
import '../domain/analytics_event.dart';
import '../domain/analytics_event_type.dart';
import '../domain/analytics_identity.dart';
import '../domain/analytics_identity_store.dart';
import '../domain/analytics_queue_store.dart';
import '../domain/analytics_service.dart';
import '../domain/queued_analytics_event.dart';
import 'analytics_destination_registry.dart';
import 'helpers/analytics_config.dart';
import 'helpers/analytics_id_generator.dart';
import 'helpers/analytics_names.dart';
import 'helpers/analytics_sanitizer.dart';

/// Default [IAnalyticsService]: sanitize -> stamp identity -> durable queue
/// -> per-destination batched delivery with retries.
///
/// * One FIFO lock guards the queue and the identity. Calls are applied in
///   order, so an event carries the identity active when it was tracked, even
///   while persisted state is still loading. Network calls never hold the
///   lock, so sign-out is not delayed by a slow destination.
/// * Events are persisted (encrypted) before delivery and removed only once
///   every destination acknowledged them, so they survive restarts and
///   offline periods. The queue is bounded by [AnalyticsConfig.maxQueueSize].
/// * Analytics never throws into callers: storage and network errors are
///   logged and retried later.
@LazySingleton(as: IAnalyticsService)
class AnalyticsServiceImpl implements IAnalyticsService {
  AnalyticsServiceImpl({
    required AnalyticsConfig config,
    required AnalyticsDestinationRegistry registry,
    required IAnalyticsQueueStore queueStore,
    required IAnalyticsIdentityStore identityStore,
    required AnalyticsSanitizer sanitizer,
    required AnalyticsIdGenerator idGenerator,
  }) : _config = config,
       _registry = registry,
       _queueStore = queueStore,
       _identityStore = identityStore,
       _sanitizer = sanitizer,
       _ids = idGenerator;

  static const String _name = 'Analytics';

  final AnalyticsConfig _config;
  final AnalyticsDestinationRegistry _registry;
  final IAnalyticsQueueStore _queueStore;
  final IAnalyticsIdentityStore _identityStore;
  final AnalyticsSanitizer _sanitizer;
  final AnalyticsIdGenerator _ids;

  final AsyncLock _lock = AsyncLock();
  final List<QueuedAnalyticsEvent> _queue = [];

  AnalyticsIdentity? _identity;
  late String _sessionId = _ids.next();
  bool _loaded = false;
  bool _disposed = false;
  Timer? _timer;

  // The delivery in progress; a flush requested meanwhile makes it run once
  // more so it covers everything tracked before that request.
  Future<void>? _delivery;
  bool _deliverAgain = false;

  bool get _active =>
      _config.enabled && !_disposed && _registry.destinations.isNotEmpty;

  @override
  Future<void> initialize() async {
    if (!_active) {
      return;
    }
    await _run(_ensureLoaded);
    _timer ??= Timer.periodic(_config.flushInterval, (_) => unawaited(flush()));
    unawaited(flush());
  }

  @override
  String trackAction({
    required String name,
    Map<String, Object?> parameters = const {},
  }) {
    final id = _ids.next();
    _enqueue(
      id: id,
      type: AnalyticsEventType.action,
      name:
          _sanitizer.eventName(raw: name) ?? AnalyticsNames.fallbackActionEvent,
      parameters: _sanitizer.parameters(raw: parameters),
      correlationId: id,
    );
    return id;
  }

  @override
  void trackScreen({required String name}) {
    final screen = _sanitizer.screenName(raw: name);
    if (screen == null) {
      return;
    }
    _enqueue(
      id: _ids.next(),
      type: AnalyticsEventType.screen,
      name: AnalyticsNames.screenViewEvent,
      parameters: {'screen_name': screen},
    );
  }

  @override
  void trackError({
    required String source,
    required Object error,
    String? correlationId,
    bool fatal = false,
  }) {
    _enqueue(
      id: _ids.next(),
      type: AnalyticsEventType.error,
      name: AnalyticsNames.errorEvent,
      parameters: {
        ..._sanitizer.describeError(error: error),
        'error_source': _sanitizer.eventName(raw: source) ?? 'unknown',
        'fatal': fatal,
      },
      correlationId: correlationId,
    );
  }

  @override
  Future<void> identify({required String userId}) {
    final id = _sanitizer.userId(raw: userId);
    if (id == null) {
      // Never echo the value (it may be an e-mail). Events must not stay
      // attributed to the previous user, so fall back to anonymous.
      AppLogger.warning(
        'Ignoring analytics identify: user ids must be opaque ids, not '
        'e-mails or phone numbers',
        name: _name,
      );
      return clearIdentity();
    }
    if (!_active) {
      return Future<void>.value();
    }
    return _run(() async {
      await _ensureLoaded();
      final identity = _identity!;
      if (identity.userId == id) {
        return;
      }
      await _setIdentity(
        identity.isAnonymous
            ? identity.withUser(userId: id)
            : AnalyticsIdentity(anonymousId: _ids.next(), userId: id),
      );
    });
  }

  @override
  Future<void> clearIdentity() {
    if (!_active) {
      return Future<void>.value();
    }
    return _run(() async {
      await _ensureLoaded();
      if (_identity!.isAnonymous) {
        return; // Nothing to unlink; keep the anonymous id stable.
      }
      await _setIdentity(AnalyticsIdentity(anonymousId: _ids.next()));
    });
  }

  @override
  Future<void> flush() {
    if (!_active) {
      return Future<void>.value();
    }
    final running = _delivery;
    if (running != null) {
      _deliverAgain = true;
      return running;
    }
    return _delivery = _deliverUntilIdle().whenComplete(() => _delivery = null);
  }

  @override
  @disposeMethod
  Future<void> dispose() async {
    _timer?.cancel();
    _timer = null;
    _disposed = true;
    await _delivery;
    await _lock.synchronized(() {});
  }

  void _enqueue({
    required String id,
    required AnalyticsEventType type,
    required String name,
    required Map<String, Object> parameters,
    String? correlationId,
  }) {
    if (!_active) {
      return;
    }
    final occurredAt = DateTime.now().toUtc();
    unawaited(
      _run(() async {
        await _ensureLoaded();
        final identity = _identity!;
        final entry = QueuedAnalyticsEvent(
          event: AnalyticsEvent(
            id: id,
            type: type,
            name: name,
            occurredAt: occurredAt,
            anonymousId: identity.anonymousId,
            userId: identity.userId,
            sessionId: _sessionId,
            correlationId: correlationId,
            parameters: parameters,
          ),
          pendingDestinations: _registry.ids,
        );
        _queue.add(entry);
        await _persist(entry);
        await _trimQueue();
        if (_queue.length >= _config.batchSize) {
          unawaited(flush());
        }
      }),
    );
  }

  Future<void> _ensureLoaded() async {
    if (_loaded) {
      return;
    }
    if (_identity == null) {
      try {
        _identity = await _identityStore.read();
      } catch (e, s) {
        _warn('Could not read analytics identity', e, s);
      }
      if (_identity == null) {
        await _setIdentity(AnalyticsIdentity(anonymousId: _ids.next()));
      } else {
        await _announceUser();
      }
    }
    try {
      final known = _registry.ids;
      final inMemory = _queue.map((entry) => entry.event.id).toSet();
      final backlog = <QueuedAnalyticsEvent>[];
      for (final entry in await _queueStore.load()) {
        if (inMemory.contains(entry.event.id)) {
          continue;
        }
        // Destinations removed since the event was queued are no longer owed.
        final pending = entry.pendingDestinations.intersection(known);
        if (pending.isEmpty) {
          await _remove(entry.event.id);
        } else {
          backlog.add(entry.copyWith(pendingDestinations: pending));
        }
      }
      _queue.insertAll(0, backlog);
      await _trimQueue();
      _loaded = true;
    } catch (e, s) {
      // `_loaded` stays false, so the next operation retries the load.
      _warn('Could not load the analytics queue', e, s);
    }
  }

  Future<void> _deliverUntilIdle() async {
    try {
      do {
        _deliverAgain = false;
        await _deliverOnce();
      } while (_deliverAgain && !_disposed);
    } catch (e, s) {
      _warn('Analytics delivery failed', e, s);
    }
  }

  Future<void> _deliverOnce() async {
    final snapshot = await _lock.synchronized(() async {
      await _ensureLoaded();
      return List.of(_queue);
    });

    final failedIds = <String>{};
    final acknowledged = <String, Set<String>>{};
    for (final destination in _registry.destinations) {
      final pending = snapshot
          .where((entry) => entry.pendingDestinations.contains(destination.id))
          .toList();
      for (var start = 0; start < pending.length; start += _config.batchSize) {
        final batch = pending.skip(start).take(_config.batchSize).toList();
        try {
          await destination.send(events: [for (final e in batch) e.event]);
        } catch (e, s) {
          _warn('Delivery to "${destination.id}" failed', e, s);
          failedIds.addAll(batch.map((entry) => entry.event.id));
          break;
        }
        for (final entry in batch) {
          (acknowledged[entry.event.id] ??= {}).add(destination.id);
        }
      }
    }

    // Events tracked during delivery were persisted right away; they are
    // picked up by the next delivery.
    await _lock.synchronized(
      () => _applyDelivery(acknowledged: acknowledged, failedIds: failedIds),
    );
  }

  Future<void> _applyDelivery({
    required Map<String, Set<String>> acknowledged,
    required Set<String> failedIds,
  }) async {
    final remaining = <QueuedAnalyticsEvent>[];
    var dropped = 0;
    for (final original in _queue) {
      final sentTo = acknowledged[original.event.id] ?? const <String>{};
      final entry = original.copyWith(
        pendingDestinations: original.pendingDestinations.difference(sentTo),
        attempts:
            original.attempts + (failedIds.contains(original.event.id) ? 1 : 0),
      );
      if (entry.isDelivered || entry.attempts >= _config.maxAttempts) {
        if (!entry.isDelivered) {
          dropped++;
        }
        await _remove(entry.event.id);
      } else {
        remaining.add(entry);
        if (entry != original) {
          await _persist(entry);
        }
      }
    }
    _queue
      ..clear()
      ..addAll(remaining);
    if (dropped > 0) {
      AppLogger.warning(
        'Dropped $dropped analytics events after ${_config.maxAttempts} '
        'failed attempts',
        name: _name,
      );
    }
  }

  Future<void> _trimQueue() async {
    while (_queue.length > _config.maxQueueSize) {
      await _remove(_queue.removeAt(0).event.id);
    }
  }

  /// Switches identity (and with it the session, so events of two identities
  /// are never linked by a shared session id), then tells the destinations.
  Future<void> _setIdentity(AnalyticsIdentity identity) async {
    _identity = identity;
    _sessionId = _ids.next();
    try {
      await _identityStore.write(identity: identity);
    } catch (e, s) {
      // Kept in memory for this launch; events are still stamped correctly.
      _warn('Could not persist analytics identity', e, s);
    }
    await _announceUser();
  }

  Future<void> _announceUser() async {
    for (final destination in _registry.destinations) {
      try {
        await destination.setUserId(userId: _identity?.userId);
      } catch (e, s) {
        _warn('Could not set the user on "${destination.id}"', e, s);
      }
    }
  }

  Future<void> _persist(QueuedAnalyticsEvent entry) async {
    try {
      await _queueStore.save(entry: entry);
    } catch (e, s) {
      // Still delivered from memory; it is only lost if the app dies first.
      _warn('Could not persist an analytics event', e, s);
    }
  }

  Future<void> _remove(String eventId) async {
    try {
      await _queueStore.remove(eventId: eventId);
    } catch (e, s) {
      // A stale entry is re-delivered after restart; backends de-duplicate
      // on the event id.
      _warn('Could not remove a delivered analytics event', e, s);
    }
  }

  /// Runs [body] under the lock; analytics failures never reach callers.
  Future<void> _run(Future<void> Function() body) =>
      _lock.synchronized(body).catchError((Object e, StackTrace s) {
        _warn('Analytics operation failed', e, s);
      });

  void _warn(String message, Object error, StackTrace stackTrace) =>
      AppLogger.warning(
        message,
        error: error,
        stackTrace: stackTrace,
        name: _name,
      );
}
