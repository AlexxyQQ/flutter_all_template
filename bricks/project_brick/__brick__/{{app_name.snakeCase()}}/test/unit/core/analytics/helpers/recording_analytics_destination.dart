import 'package:flutter_all_template/core/common/domain/services/analytics/domain/analytics_destination.dart';
import 'package:flutter_all_template/core/common/domain/services/analytics/domain/analytics_event.dart';

/// Records every delivered batch; throws while [failing] is true.
class RecordingAnalyticsDestination implements IAnalyticsDestination {
  RecordingAnalyticsDestination({this.id = 'recording'});

  @override
  final String id;

  final List<List<AnalyticsEvent>> batches = [];
  bool failing = false;
  int attempts = 0;
  Future<void> Function()? beforeSend;

  List<AnalyticsEvent> get events => [for (final b in batches) ...b];

  @override
  Future<void> send({required List<AnalyticsEvent> events}) async {
    attempts++;
    await beforeSend?.call();
    if (failing) {
      throw StateError('destination down');
    }
    batches.add(events);
  }
}
