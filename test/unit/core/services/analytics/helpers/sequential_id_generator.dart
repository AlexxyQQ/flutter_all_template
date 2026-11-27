import 'package:flutter_all_template/core/services/analytics/data/helpers/analytics_id_generator.dart';

/// Deterministic ids: `id-1`, `id-2`, ...
class SequentialIdGenerator extends AnalyticsIdGenerator {
  int _next = 0;

  @override
  String next() => 'id-${++_next}';
}
