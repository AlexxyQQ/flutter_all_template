import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:injectable/injectable.dart';

import '../../../logger/data/app_logger.dart';
import '../../domain/analytics_destination.dart';
import '../../domain/analytics_event.dart';
import '../../domain/analytics_event_type.dart';
import 'firebase_analytics_event_mapper.dart';

/// Forwards events to Firebase Analytics (`ANALYTICS_FIREBASE_ENABLED`).
///
/// Firebase attributes an event to the user id set when it is logged, so the
/// id is set once per identity change ([setUserId]) rather than per event
/// (which would also touch Firebase's own auto-collected events). Events queued
/// under a different user than the current one (replayed after a sign-out)
/// are skipped: a wrong attribution is worse than a missing event. Firebase
/// stamps events with the time they are logged, not `occurredAt`, and buffers
/// offline itself. `FirebaseAnalytics.instance` is only touched when sending,
/// i.e. after `Firebase.initializeApp` in `main.dart`.
@lazySingleton
class FirebaseAnalyticsDestination implements IAnalyticsDestination {
  FirebaseAnalyticsDestination({required FirebaseAnalyticsEventMapper mapper})
    : _mapper = mapper;

  static const String destinationId = 'firebase';

  final FirebaseAnalyticsEventMapper _mapper;
  String? _userId;

  FirebaseAnalytics get _analytics => FirebaseAnalytics.instance;

  @override
  String get id => destinationId;

  @override
  Future<void> setUserId({required String? userId}) async {
    await _analytics.setUserId(id: userId);
    _userId = userId;
  }

  @override
  Future<void> send({required List<AnalyticsEvent> events}) async {
    var skipped = 0;
    for (final event in events) {
      if (event.userId != _userId) {
        skipped++;
        continue;
      }
      final parameters = _mapper.parameters(event: event);
      if (event.type == AnalyticsEventType.screen) {
        await _analytics.logScreenView(
          screenName: parameters['screen_name'] as String?,
          parameters: parameters,
        );
      } else {
        await _analytics.logEvent(name: event.name, parameters: parameters);
      }
    }
    if (skipped > 0) {
      AppLogger.debug(
        'Skipped $skipped events queued under another user',
        name: 'FirebaseAnalytics',
      );
    }
  }
}
