import 'analytics_identity.dart';

/// Persists the current [AnalyticsIdentity] across launches.
abstract interface class IAnalyticsIdentityStore {
  Future<AnalyticsIdentity?> read();
  Future<void> write({required AnalyticsIdentity identity});
}
