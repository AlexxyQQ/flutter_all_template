/// DI instance names and fixed event names used by analytics.
abstract final class AnalyticsNames {
  /// Bare Dio for the custom analytics API: never the API Dio, so auth
  /// headers are not attached to (possibly third-party) analytics hosts.
  static const String apiDio = 'analyticsApiDio';

  /// Absolute URL the custom API destination posts batches to.
  static const String apiUrl = 'analyticsApiUrl';

  static const String screenViewEvent = 'screen_view';
  static const String errorEvent = 'app_error';
  static const String fallbackActionEvent = 'unnamed_action';
}
