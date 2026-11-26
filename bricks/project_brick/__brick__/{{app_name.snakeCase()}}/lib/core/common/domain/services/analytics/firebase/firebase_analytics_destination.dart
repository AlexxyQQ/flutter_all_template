import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:injectable/injectable.dart';

import '../domain/analytics_destination.dart';
import '../domain/analytics_event.dart';
import '../domain/analytics_event_type.dart';
import 'firebase_analytics_event_mapper.dart';

/// Forwards events to Firebase Analytics (`ANALYTICS_FIREBASE_ENABLED`).
///
/// The user id is switched per event, so replayed events keep the identity
/// they were tracked under. Firebase stamps events with the time they are
/// logged, not `occurredAt`; Firebase itself buffers offline after that.
/// `FirebaseAnalytics.instance` is only touched when sending, i.e. after
/// `Firebase.initializeApp` in `main.dart`.
@lazySingleton
class FirebaseAnalyticsDestination implements IAnalyticsDestination {
  FirebaseAnalyticsDestination({required FirebaseAnalyticsEventMapper mapper})
    : _mapper = mapper;

  static const String destinationId = 'firebase';

  final FirebaseAnalyticsEventMapper _mapper;

  FirebaseAnalytics get _analytics => FirebaseAnalytics.instance;

  @override
  String get id => destinationId;

  @override
  Future<void> send({required List<AnalyticsEvent> events}) async {
    String? currentUserId;
    var userIdSet = false;
    try {
      for (final event in events) {
        if (!userIdSet || event.userId != currentUserId) {
          await _analytics.setUserId(id: event.userId);
          currentUserId = event.userId;
          userIdSet = true;
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
    } finally {
      // Replays may include a user who has already signed out.
      if (currentUserId != null) {
        await _analytics.setUserId();
      }
    }
  }
}
