import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/constants/api/api_constants.dart';
import '../../../../config/env/app_env.dart';
import '../../logger/data/app_logger.dart';
import 'analytics_destination_registry.dart';
import 'destinations/api_analytics_destination.dart';
import 'destinations/local_analytics_destination.dart';
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
    const configured = AppEnv.analyticsApiUrl;
    if (configured.isEmpty) {
      return '';
    }
    final uri = Uri.tryParse(configured);
    if (uri != null &&
        uri.scheme == 'https' &&
        uri.host.isNotEmpty &&
        uri.userInfo.isEmpty &&
        !uri.hasFragment) {
      return uri.toString();
    }
    // The value is not echoed: it may embed credentials.
    AppLogger.warning(
      'ANALYTICS_API_URL must be an https URL without credentials or a '
      'fragment; the custom analytics API is disabled',
      name: 'Analytics',
    );
    return '';
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
