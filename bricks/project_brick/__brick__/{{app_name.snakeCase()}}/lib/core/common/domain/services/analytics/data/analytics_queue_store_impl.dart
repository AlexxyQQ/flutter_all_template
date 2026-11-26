import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../../logger/logger_service.dart';
import '../domain/analytics_queue_store.dart';
import '../domain/analytics_storage.dart';
import '../domain/queued_analytics_event.dart';
import 'analytics_event_json.dart';

/// [IAnalyticsQueueStore] with one encrypted storage entry per event, so a
/// crash mid-write can corrupt at most one event.
@LazySingleton(as: IAnalyticsQueueStore)
class AnalyticsQueueStoreImpl implements IAnalyticsQueueStore {
  AnalyticsQueueStoreImpl({required IAnalyticsStorage storage})
    : _storage = storage;

  static const String keyPrefix = 'analytics.queue.';
  static const String _name = 'AnalyticsQueue';

  final IAnalyticsStorage _storage;

  @override
  Future<List<QueuedAnalyticsEvent>> load() async {
    final entries = <QueuedAnalyticsEvent>[];
    final keys = (await _storage.keys()).where((k) => k.startsWith(keyPrefix));
    for (final key in keys) {
      final raw = await _storage.read(key: key);
      if (raw == null) {
        continue;
      }
      try {
        entries.add(
          AnalyticsEventJson.decodeQueued(
            json: jsonDecode(raw) as Map<String, Object?>,
          ),
        );
      } catch (e) {
        // A corrupt entry can never be delivered; drop it so it does not
        // block the queue. Only the error type is logged, never the payload.
        AppLogger.warning(
          'Dropping unreadable queued event (${e.runtimeType})',
          name: _name,
        );
        await _storage.delete(key: key);
      }
    }
    entries.sort((a, b) {
      final byTime = a.event.occurredAt.compareTo(b.event.occurredAt);
      return byTime != 0 ? byTime : a.event.id.compareTo(b.event.id);
    });
    return entries;
  }

  @override
  Future<void> save({required QueuedAnalyticsEvent entry}) => _storage.write(
    key: '$keyPrefix${entry.event.id}',
    value: jsonEncode(AnalyticsEventJson.encodeQueued(entry: entry)),
  );

  @override
  Future<void> remove({required String eventId}) =>
      _storage.delete(key: '$keyPrefix$eventId');
}
