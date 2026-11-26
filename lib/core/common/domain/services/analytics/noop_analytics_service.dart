import 'domain/analytics_service.dart';

/// [IAnalyticsService] that records nothing. For tests and previews that
/// construct blocs or observers by hand.
class NoopAnalyticsService implements IAnalyticsService {
  const NoopAnalyticsService();

  @override
  Future<void> initialize() async {}

  @override
  String trackAction({
    required String name,
    Map<String, Object?> parameters = const {},
  }) => '';

  @override
  void trackScreen({required String name}) {}

  @override
  void trackError({
    required String source,
    required Object error,
    String? correlationId,
    bool fatal = false,
  }) {}

  @override
  Future<void> identify({required String userId}) async {}

  @override
  Future<void> clearIdentity() async {}

  @override
  Future<void> flush() async {}

  @override
  Future<void> dispose() async {}
}
