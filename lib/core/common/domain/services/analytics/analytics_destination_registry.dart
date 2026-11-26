import 'domain/analytics_destination.dart';

/// The destinations enabled for this build and flavor (see
/// `AnalyticsModule`). Empty means analytics stores and sends nothing.
final class AnalyticsDestinationRegistry {
  AnalyticsDestinationRegistry({
    required List<IAnalyticsDestination> destinations,
  }) : destinations = List.unmodifiable(destinations);

  final List<IAnalyticsDestination> destinations;

  Set<String> get ids => {for (final d in destinations) d.id};
}
