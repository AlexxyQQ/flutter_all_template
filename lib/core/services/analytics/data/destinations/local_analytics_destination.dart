import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../../../../generic/data/async_lock.dart';
import '../../domain/analytics_destination.dart';
import '../../domain/analytics_event.dart';
import '../../domain/analytics_storage.dart';
import '../analytics_event_json.dart';

/// Retains the most recent events on the device for diagnostic inspection.
@lazySingleton
final class LocalAnalyticsDestination implements IAnalyticsDestination {
  LocalAnalyticsDestination({required IAnalyticsStorage storage})
    : _storage = storage;

  static const String _prefix = 'analytics.history.';
  static const int _maxEntries = 500;

  final IAnalyticsStorage _storage;
  final AsyncLock _lock = AsyncLock();

  @override
  String get id => 'local';

  /// Events carry their own user id; nothing to track here.
  @override
  Future<void> setUserId({required String? userId}) async {}

  @override
  Future<void> send({required List<AnalyticsEvent> events}) =>
      _lock.synchronized(() async {
        for (final event in events) {
          final timestamp = event.occurredAt.microsecondsSinceEpoch
              .toString()
              .padLeft(16, '0');
          await _storage.write(
            key: '$_prefix$timestamp.${event.id}',
            value: jsonEncode(AnalyticsEventJson.encodeEvent(event: event)),
          );
        }
        final keys = await _historyKeys();
        for (final key in keys.skip(_maxEntries)) {
          await _storage.delete(key: key);
        }
      });

  Future<List<String>> _historyKeys() async {
    final keys = (await _storage.keys())
        .where((key) => key.startsWith(_prefix))
        .toList();
    return keys..sort((left, right) => right.compareTo(left));
  }
}
