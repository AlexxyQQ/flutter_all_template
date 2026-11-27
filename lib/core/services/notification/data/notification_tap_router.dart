import 'dart:async';
import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../logger/domain/logger_service.dart';
import '../../navigation/presentation/navigation_service.dart';
import '../domain/notification_launch.dart';
import 'notification_route_allowlist.dart';

/// Turns a tapped notification into navigation.
///
/// * **Running app:** a tap navigates immediately.
/// * **Cold start:** the tap is stored by [start] as a pending destination and
///   only opened when the splash calls [openPendingLaunchDestination], i.e.
///   once the router is mounted and start-up has finished (navigating from
///   `Bootstrap`, before `runApp`, has no router to talk to).
///
/// Only allowlisted destinations are honoured (see
/// [NotificationRouteAllowlist]); unknown values are ignored and logged
/// without the value itself.
@lazySingleton
class NotificationTapRouter implements INotificationLaunch {
  NotificationTapRouter({
    required AwesomeNotifications awesome,
    required NavigationService navigation,
    required NotificationRouteAllowlist routes,
    required ILoggerService logger,
  }) : _awesome = awesome,
       _navigation = navigation,
       _routes = routes,
       _logger = logger;

  final AwesomeNotifications _awesome;
  final NavigationService _navigation;
  final NotificationRouteAllowlist _routes;
  final ILoggerService _logger;

  /// awesome_notifications only accepts a static callback, so it forwards taps
  /// to whichever instance is currently started. Cleared by [dispose].
  static void Function(ReceivedAction action)? _activeSink;

  String? _pendingLaunchPath;

  /// Remembers the notification that launched the app (if any) and starts
  /// listening for later taps.
  Future<void> start() async {
    final initial = await _awesome.getInitialNotificationAction(
      removeFromActionEvents: true,
    );
    _pendingLaunchPath = initial == null
        ? null
        : _resolvePath(payload: parsePayload(initial.payload));

    _activeSink = _onTap;
    final listening = await _awesome.setListeners(
      onActionReceivedMethod: _onActionReceived,
    );
    if (!listening) {
      _activeSink = null;
      throw StateError('Notification listener setup failed');
    }
  }

  void dispose() {
    _activeSink = null;
  }

  @override
  Future<void> openPendingLaunchDestination() async {
    final path = _pendingLaunchPath;
    _pendingLaunchPath = null;
    if (path != null) {
      await _open(path: path);
    }
  }

  /// Opens the allowlisted destination of [payload], if it has one.
  @visibleForTesting
  Future<void> openFromPayload({required Map<String, dynamic> payload}) async {
    final path = _resolvePath(payload: payload);
    if (path != null) {
      await _open(path: path);
    }
  }

  /// Decodes JSON-looking values of an awesome_notifications payload.
  @visibleForTesting
  static Map<String, dynamic> parsePayload(Map<String, String?>? payload) {
    return (payload ?? const <String, String?>{}).map((key, value) {
      if (value != null && (value.startsWith('{') || value.startsWith('['))) {
        try {
          return MapEntry(key, jsonDecode(value));
        } on FormatException {
          return MapEntry(key, value);
        }
      }
      return MapEntry(key, value);
    });
  }

  @pragma('vm:entry-point')
  static Future<void> _onActionReceived(ReceivedAction action) async {
    _activeSink?.call(action);
  }

  void _onTap(ReceivedAction action) {
    // A live tap supersedes a launch destination that was never opened.
    _pendingLaunchPath = null;
    unawaited(openFromPayload(payload: parsePayload(action.payload)));
  }

  String? _resolvePath({required Map<String, dynamic> payload}) {
    final path = _routes.resolve(payload);
    if (path == null && _routes.hasRoutingKey(payload)) {
      _logger.info('Ignored notification with a non-allowlisted route.');
    }
    return path;
  }

  Future<void> _open({required String path}) async {
    try {
      await _navigation.navigateToPath(
        path: path,
        onFailure: (_) =>
            _logger.info('Could not open an allowlisted notification route.'),
      );
    } catch (error, stackTrace) {
      _logger.error(
        'Notification navigation failed',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
