import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/constants/api/api_constants.dart';
import '../../../../../config/env/app_env.dart';
import 'analytics_destination_registry.dart';
import 'data/destinations/api_analytics_destination.dart';
import 'data/destinations/local_analytics_destination.dart';
// brick:if use_firebase
import 'firebase/firebase_analytics_destination.dart';
// brick:end
import 'helpers/analytics_config.dart';
import 'helpers/analytics_names.dart';

/// Wires analytics configuration and destinations from `AppEnv`.
@module
abstract class AnalyticsModule {
  @lazySingleton
  AnalyticsConfig get analyticsConfig =>
      const AnalyticsConfig(enabled: AppEnv.analyticsEnabled);

  @Named(AnalyticsNames.apiUrl)
  String get analyticsApiUrl {
    final uri = Uri.tryParse(AppEnv.analyticsApiUrl);
    return uri != null &&
            uri.scheme == 'https' &&
            uri.host.isNotEmpty &&
            uri.userInfo.isEmpty &&
            !uri.hasFragment
        ? uri.toString()
        : '';
  }

  /// Use an isolated TLS transport. Identity-bearing events bypass HTTP logs.
  @Named(AnalyticsNames.apiDio)
  @lazySingleton
  Dio get analyticsDio => Dio(
    BaseOptions(
      connectTimeout: ApiConstants.connectTimeout,
      sendTimeout: ApiConstants.sendTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      followRedirects: false,
      contentType: Headers.jsonContentType,
    ),
  );

  @lazySingleton
  AnalyticsDestinationRegistry analyticsDestinations({
    required LocalAnalyticsDestination local,
    required ApiAnalyticsDestination api,
    // brick:if use_firebase
    required FirebaseAnalyticsDestination firebase,
    // brick:end
  }) => AnalyticsDestinationRegistry(
    destinations: [
      local,
      if (analyticsApiUrl.isNotEmpty) api,
      // brick:if use_firebase
      if (AppEnv.analyticsFirebaseEnabled) firebase,
      // brick:end
    ],
  );
}
