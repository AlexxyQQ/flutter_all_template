import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../domain/analytics_destination.dart';
import '../../domain/analytics_event.dart';
import '../../helpers/analytics_names.dart';
import '../analytics_event_json.dart';

/// Posts event batches to a custom analytics endpoint
/// (`ANALYTICS_API_URL`) as
/// `{"sent_at": "<ISO-8601>", "events": [<AnalyticsEventJson>]}`.
///
/// Any 2xx response acknowledges the whole batch; anything else throws and
/// the batch is retried later. The backend should de-duplicate on `id`,
/// because a batch may be re-sent if the app dies before the response.
@lazySingleton
class ApiAnalyticsDestination implements IAnalyticsDestination {
  ApiAnalyticsDestination({
    @Named(AnalyticsNames.apiDio) required Dio dio,
    @Named(AnalyticsNames.apiUrl) required String endpoint,
  }) : _dio = dio,
       _endpoint = endpoint;

  static const String destinationId = 'api';

  final Dio _dio;
  final String _endpoint;

  @override
  String get id => destinationId;

  @override
  Future<void> send({required List<AnalyticsEvent> events}) async {
    if (events.isEmpty) {
      return;
    }
    await _dio.post<void>(
      _endpoint,
      data: {
        'sent_at': DateTime.now().toUtc().toIso8601String(),
        'events': [
          for (final event in events)
            AnalyticsEventJson.encodeEvent(event: event),
        ],
      },
    );
  }
}
