import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/constants/paths/app_path.dart';

/// Maps push payload keys to **known** in-app paths.
///
/// A push payload is untrusted input: anyone able to send a push (a leaked
/// server key, a compromised backend) must not be able to drive the app to an
/// arbitrary screen. Only values listed in [routes] are honoured; the
/// resolved path always comes from this table, never from the payload.
///
/// Payload contract: `{"type": "<key>"}` (preferred) or `{"route": "<key>"}`.
@lazySingleton
class NotificationRouteAllowlist {
  NotificationRouteAllowlist() : routes = defaultRoutes;

  @visibleForTesting
  const NotificationRouteAllowlist.custom(this.routes);

  /// Add an entry per notification type your backend sends.
  static const Map<String, String> defaultRoutes = {'home': AppPaths.home};

  /// Payload keys inspected, in priority order.
  static const List<String> payloadKeys = ['type', 'route'];

  final Map<String, String> routes;

  /// The allowlisted path for [payload], or `null` when the payload has no
  /// routing key or an unknown value.
  String? resolve(Map<String, dynamic> payload) {
    for (final key in payloadKeys) {
      final value = payload[key];
      if (value is String) {
        final path = routes[value];
        if (path != null) {
          return path;
        }
      }
    }
    return null;
  }

  /// Whether the payload asked for navigation at all.
  bool hasRoutingKey(Map<String, dynamic> payload) =>
      payloadKeys.any((key) => payload[key] is String);
}
