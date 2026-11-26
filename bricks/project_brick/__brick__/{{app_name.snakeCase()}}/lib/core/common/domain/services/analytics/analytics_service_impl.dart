import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../../generic/data/async_lock.dart';
import '../logger/logger_service.dart';
import 'analytics_destination_registry.dart';
import 'domain/analytics_event.dart';
import 'domain/analytics_event_type.dart';
import 'domain/analytics_identity.dart';
import 'domain/analytics_identity_store.dart';
import 'domain/analytics_queue_store.dart';
import 'domain/analytics_service.dart';
import 'domain/queued_analytics_event.dart';
import 'helpers/analytics_config.dart';
import 'helpers/analytics_id_generator.dart';
import 'helpers/analytics_names.dart';
import 'helpers/analytics_sanitizer.dart';

/// Default [IAnalyticsService]: sanitize -> stamp identity -> durable queue
/// -> per-destination batched delivery with retries.
///
/// * Every mutation runs through one FIFO lock, so events are stamped with
///   the identity active at the moment they were tracked, even while the
///   persisted state is still loading.
/// * Events are persisted (encrypted) before delivery and removed only once
///   every destination acknowledged them, so they survive restarts and
///   offline periods. The queue is bounded by [AnalyticsConfig.maxQueueSize].
/// * Analytics never throws into callers: storage and network errors are
///   logged (types and counts only) and retried later.
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
  final AsyncLock _deliveryLock = AsyncLock();
  final List<QueuedAnalyticsEvent> _queue = [];
  final Map<String, ({AnalyticsIdentity identity, String sessionId})>
  _actionOwners = {};

  AnalyticsIdentity? _identity;
  late String _sessionId = _ids.next();
  bool _loaded = false;
  bool _disposed = false;
  Timer? _timer;
  Future<void>? _scheduledFlush;
  String? _lastActionId;
  DateTime? _lastActionAt;

  bool get _active =>
      _config.enabled && !_disposed && _registry.destinations.isNotEmpty;

  @override
  Future<void> initialize() async {
    if (!_active) {
      return;
    }
    await _run(_ensureLoaded);
    _timer ??= Timer.periodic(_config.flushInterval, (_) => _scheduleFlush());
    _scheduleFlush();
  }

  @override
  String trackAction({
    required String name,
    Map<String, Object?> parameters = const {},
  }) {
    final id = _ids.next();
    final now = DateTime.now().toUtc();
    _lastActionId = id;
    _lastActionAt = now;
    _enqueue(
      id: id,
      occurredAt: now,
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
      occurredAt: DateTime.now().toUtc(),
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
    final now = DateTime.now().toUtc();
    _enqueue(
      id: _ids.next(),
      occurredAt: now,
      type: AnalyticsEventType.error,
      name: AnalyticsNames.errorEvent,
      parameters: {
        ..._sanitizer.describeError(error: error),
        'error_source': _sanitizer.eventName(raw: source) ?? 'unknown',
        'fatal': fatal,
      },
      correlationId: correlationId ?? _recentActionId(now: now),
    );
  }

  @override
  Future<void> identify({required String userId}) {
    final id = _sanitizer.userId(raw: userId);
    if (id == null) {
      // The value itself is deliberately not echoed (it may be an e-mail).
      throw ArgumentError(
        'Analytics user ids must be opaque ids, not e-mails or phone numbers',
        'userId',
      );
    }
    if (!_active) {
      return Future<void>.value();
    }
    _forgetRecentAction();
    return _run(() async {
      await _ensureLoaded();
      final identity = _identity!;
      if (identity.userId != id) {
        await _setIdentity(
          identity.isAnonymous
              ? identity.withUser(userId: id)
              : AnalyticsIdentity(anonymousId: _ids.next(), userId: id),
        );
      }
    });
  }

  @override
  Future<void> clearIdentity() {
    if (!_active) {
      return Future<void>.value();
    }
    _forgetRecentAction();
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
    return _deliveryLock.synchronized(() async {
      var snapshot = <QueuedAnalyticsEvent>[];
      await _run(() async {
        await _ensureLoaded();
        snapshot = List.of(_queue);
      });
      await _deliver(snapshot: snapshot);
    });
  }

  @override
  @disposeMethod
  Future<void> dispose() async {
    _timer?.cancel();
    _timer = null;
    _disposed = true;
    await _deliveryLock.synchronized(() {});
    await _lock.synchronized(() {});
  }

  void _scheduleFlush() {
    if (_scheduledFlush == null && !_disposed) {
      _scheduledFlush = flush().whenComplete(() => _scheduledFlush = null);
      unawaited(_scheduledFlush);
    }
  }

  void _forgetRecentAction() {
    _lastActionId = null;
    _lastActionAt = null;
  }

  String? _recentActionId({required DateTime now}) {
    final at = _lastActionAt;
    if (at == null || now.difference(at) > _config.correlationWindow) {
      return null;
    }
    return _lastActionId;
  }

  void _enqueue({
    required String id,
    required DateTime occurredAt,
    required AnalyticsEventType type,
    required String name,
    required Map<String, Object> parameters,
    String? correlationId,
  }) {
    if (!_active) {
      return;
    }
    unawaited(
      _run(() async {
        await _ensureLoaded();
        final owner = _actionOwners[correlationId];
        final identity = owner?.identity ?? _identity!;
        final sessionId = owner?.sessionId ?? _sessionId;
        if (type == AnalyticsEventType.action) {
          _actionOwners[id] = (identity: identity, sessionId: sessionId);
          if (_actionOwners.length > _config.maxQueueSize) {
            _actionOwners.remove(_actionOwners.keys.first);
          }
        }
        final entry = QueuedAnalyticsEvent(
          event: AnalyticsEvent(
            id: id,
            type: type,
            name: name,
            occurredAt: occurredAt,
            anonymousId: identity.anonymousId,
            userId: identity.userId,
            sessionId: sessionId,
            correlationId: type == AnalyticsEventType.action || owner != null
                ? correlationId
                : null,
            parameters: parameters,
          ),
          pendingDestinations: _registry.ids,
        );
        _queue.add(entry);
        await _persist(entry);
        await _trimQueue();
        if (_queue.length >= _config.batchSize) {
          _scheduleFlush();
        }
      }),
    );
  }

  Future<void> _ensureLoaded() async {
    if (_loaded) {
      return;
    }
    _loaded = true;
    try {
      _identity = await _identityStore.read();
    } catch (e) {
      _warn('Could not read analytics identity', e);
    }
    if (_identity == null) {
      await _setIdentity(AnalyticsIdentity(anonymousId: _ids.next()));
    }
    try {
      final known = _registry.ids;
      for (final entry in await _queueStore.load()) {
        // Destinations removed since the event was queued are no longer owed.
        final pending = entry.pendingDestinations.intersection(known);
        if (pending.isEmpty) {
          await _queueStore.remove(eventId: entry.event.id);
        } else {
          _queue.add(entry.copyWith(pendingDestinations: pending));
        }
      }
      await _trimQueue();
    } catch (e) {
      _warn('Could not load the analytics queue', e);
    }
  }

  Future<void> _deliver({required List<QueuedAnalyticsEvent> snapshot}) async {
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
        } catch (e) {
          _warn('Delivery to "${destination.id}" failed', e);
          failedIds.addAll(batch.map((entry) => entry.event.id));
          break;
        }
        for (final entry in batch) {
          (acknowledged[entry.event.id] ??= {}).add(destination.id);
        }
      }
    }

    // Network calls never hold the queue lock. Actions recorded during
    // delivery are persisted immediately and picked up on the next flush.
    await _run(
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

  Future<void> _setIdentity(AnalyticsIdentity identity) async {
    _identity = identity;
    _sessionId = _ids.next();
    try {
      await _identityStore.write(identity: identity);
    } catch (e) {
      // Kept in memory for this launch; events are still stamped correctly.
      _warn('Could not persist analytics identity', e);
    }
  }

  Future<void> _persist(QueuedAnalyticsEvent entry) async {
    try {
      await _queueStore.save(entry: entry);
    } catch (e) {
      // Still delivered from memory; it is only lost if the app dies first.
      _warn('Could not persist an analytics event', e);
    }
  }

  Future<void> _remove(String eventId) async {
    try {
      await _queueStore.remove(eventId: eventId);
    } catch (e) {
      // A stale entry is re-delivered after restart; backends de-duplicate
      // on the event id.
      _warn('Could not remove a delivered analytics event', e);
    }
  }

  /// Runs [body] under the lock; analytics failures never reach callers.
  Future<void> _run(Future<void> Function() body) =>
      _lock.synchronized(body).catchError((Object e) {
        _warn('Analytics operation failed', e);
      });

  void _warn(String message, Object error) =>
      AppLogger.warning('$message (${error.runtimeType})', name: _name);
}
