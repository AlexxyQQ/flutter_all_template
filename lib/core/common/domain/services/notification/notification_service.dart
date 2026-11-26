import 'dart:async';
import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../session/session.dart';
import '../../../../storage/key_value_stores.dart';
import '../logger/logger_service.dart';
import '../navigation/navigation_service.dart';
import 'domain/push_token_repository.dart';
import 'helpers/fcm_background_handler.dart';
import 'helpers/notification_channels.dart';
import 'helpers/notification_display_helper.dart';
import 'helpers/notification_prefs.dart';
import 'helpers/notification_thread.dart';
import 'notification_permission_api.dart';
import 'notification_route_allowlist.dart';
import 'push/push_messaging_client.dart';

/// Push (FCM) + local (awesome_notifications) notifications.
///
/// Lifecycle: bootstrap calls [initialize] exactly once, after
/// `Firebase.initializeApp`. The FCM token is registered with the backend
/// (through [PushTokenRepository]) while a session is authenticated, and is
/// unregistered + deleted by a logout hook.
@lazySingleton
class NotificationService implements NotificationPermissionApi {
  NotificationService({
    required PushMessagingClient push,
    required AwesomeNotifications awesome,
    required PreferencesStore prefs,
    required PushTokenRepository tokens,
    required SessionManager session,
    required NavigationService navigation,
    required NotificationRouteAllowlist routes,
    required ILoggerService logger,
  }) : _push = push,
       _awesome = awesome,
       _prefs = prefs,
       _tokens = tokens,
       _session = session,
       _navigation = navigation,
       _routes = routes,
       _logger = logger,
       _display = NotificationDisplayHelper(
         awesomeNotifications: awesome,
         onError: (message, error, stackTrace) =>
             logger.e(message, error: error, stackTrace: stackTrace),
       );

  final PushMessagingClient _push;
  final AwesomeNotifications _awesome;
  final PreferencesStore _prefs;
  final PushTokenRepository _tokens;
  final SessionManager _session;
  final NavigationService _navigation;
  final NotificationRouteAllowlist _routes;
  final ILoggerService _logger;
  final NotificationDisplayHelper _display;

  /// awesome_notifications only accepts static/top-level action callbacks,
  /// so taps are forwarded through this static stream to the instance.
  static final StreamController<ReceivedAction> _actions =
      StreamController<ReceivedAction>.broadcast();

  final StreamController<Map<String, dynamic>> _events =
      StreamController<Map<String, dynamic>>.broadcast();

  final List<StreamSubscription<Object?>> _subscriptions = [];

  bool _initialized = false;
  Future<void>? _initializing;
  String? _currentThreadId;

  /// Last token successfully registered with the backend (never logged).
  String? _registeredToken;

  /// `received` / `clicked` events with the (untrusted) payload data.
  Stream<Map<String, dynamic>> get notificationStream => _events.stream;

  // ---------------------------------------------------------------------------
  // Initialization
  // ---------------------------------------------------------------------------

  Future<void> initialize() {
    if (_initialized) {
      return Future<void>.value();
    }
    return _initializing ??= _initialize().whenComplete(() {
      _initializing = null;
    });
  }

  Future<void> _initialize() async {
    try {
      final ready = await _awesome.initialize(
        null,
        NotificationChannelConfig.channels,
        debug: kDebugMode,
      );
      if (!ready) {
        throw StateError('Notification plugin initialization failed');
      }
      final initialAction = await _awesome.getInitialNotificationAction(
        removeFromActionEvents: true,
      );
      _subscriptions
        ..add(
          _actions.stream.listen((action) => unawaited(_handleAction(action))),
        )
        ..add(_push.onMessage.listen(_onForegroundMessage))
        ..add(_push.onTokenRefresh.listen(_onTokenRefresh))
        ..add(_session.statusStream.listen(_onSessionStatus));
      _push.registerBackgroundHandler(
        handler: firebaseMessagingBackgroundHandler,
      );

      if (initialAction != null) {
        await _handleAction(initialAction);
      }
      final listening = await _awesome.setListeners(
        onActionReceivedMethod: _onActionReceived,
      );
      if (!listening) {
        throw StateError('Notification listener setup failed');
      }
      if (_session.status == SessionStatus.authenticated) {
        await _syncToken();
      }
      _session.registerLogoutHook(hook: _onLogout);
      _initialized = true;
    } catch (_) {
      await _cancelSubscriptions();
      rethrow;
    }
    _logger.i('NotificationService initialized.');
  }

  @disposeMethod
  Future<void> dispose() async {
    await _cancelSubscriptions();
    await _events.close();
  }

  Future<void> _cancelSubscriptions() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    _subscriptions.clear();
  }

  // ---------------------------------------------------------------------------
  // Permission (NotificationPermissionApi)
  // ---------------------------------------------------------------------------

  @override
  Future<bool> isPermissionGranted() => _awesome.isNotificationAllowed();

  @override
  Future<bool> requestPermission() async {
    var allowed = await _awesome.isNotificationAllowed();
    if (!allowed) {
      allowed = await _awesome.requestPermissionToSendNotifications();
    }
    // iOS needs the FCM authorization as well.
    await _push.requestPermission();
    if (allowed && _session.status == SessionStatus.authenticated) {
      await _syncToken();
    }
    return allowed;
  }

  // ---------------------------------------------------------------------------
  // User toggle
  // ---------------------------------------------------------------------------

  bool get areNotificationsEnabled =>
      _prefs.getBool(NotificationPrefs.enabledKey) ?? true;

  /// Turns push notifications on/off for this device.
  ///
  /// Off: unregisters + deletes the FCM token (FCM stops delivering) and
  /// clears every displayed notification.
  Future<void> toggleNotifications({required bool isEnabled}) async {
    await _prefs.setBool(NotificationPrefs.enabledKey, value: isEnabled);
    if (isEnabled) {
      if (_session.status == SessionStatus.authenticated) {
        await _syncToken();
      }
      return;
    }
    await _unregisterAndDeleteToken();
    await _display.cancelAll();
  }

  // ---------------------------------------------------------------------------
  // Display
  // ---------------------------------------------------------------------------

  Future<void> showNotification(RemoteMessage message, {bool force = false}) {
    if (!force && !areNotificationsEnabled) {
      return Future.value();
    }
    return _display.showRemoteMessage(message);
  }

  Future<void> showSimpleNotification({
    required int id,
    required String title,
    required String body,
    Map<String, String?>? payload,
  }) async {
    if (!areNotificationsEnabled) {
      return;
    }
    await _display.showSimpleNotification(
      id: id,
      title: title,
      body: body,
      payload: payload,
    );
  }

  /// Progress notifications (e.g. uploads) are shown even when push
  /// notifications are toggled off: they are user-initiated.
  Future<void> showProgressNotification({
    required int id,
    required String title,
    required String body,
    required int progress,
  }) => _display.showProgressNotification(
    id: id,
    title: title,
    body: body,
    progress: progress,
  );

  Future<void> cancelNotification(int id) => _display.cancel(id);

  Future<void> cancelAllNotifications() => _display.cancelAll();

  // ---------------------------------------------------------------------------
  // Thread suppression
  // ---------------------------------------------------------------------------

  /// Suppresses foreground pushes for [threadId] (the conversation on screen).
  void suppressNotificationsForThread(String threadId) {
    _currentThreadId = normalizeThreadId(threadId);
  }

  void clearThreadSuppression() {
    _currentThreadId = null;
  }

  @visibleForTesting
  bool shouldSuppress(RemoteMessage message) {
    if (!areNotificationsEnabled) {
      return true;
    }
    final current = _currentThreadId;
    final incoming = message.data[threadIdPayloadKey];
    return current != null &&
        incoming is String &&
        normalizeThreadId(incoming) == current;
  }

  // ---------------------------------------------------------------------------
  // Navigation from a tapped notification
  // ---------------------------------------------------------------------------

  /// Navigates only to allowlisted destinations (see
  /// [NotificationRouteAllowlist]). Unknown values are ignored and logged
  /// (without the value itself).
  @visibleForTesting
  Future<void> navigateFromPayload(Map<String, dynamic> payload) async {
    final path = _routes.resolve(payload);
    if (path != null) {
      await _navigation.navigateToPath(
        path,
        onFailure: (_) =>
            _logger.i('Could not open an allowlisted notification route.'),
      );
      return;
    }
    if (_routes.hasRoutingKey(payload)) {
      _logger.i('Ignored notification with a non-allowlisted route.');
    }
  }

  // ---------------------------------------------------------------------------
  // Private
  // ---------------------------------------------------------------------------

  @pragma('vm:entry-point')
  static Future<void> _onActionReceived(ReceivedAction action) async {
    if (!_actions.isClosed) {
      _actions.add(action);
    }
  }

  Future<void> _handleAction(ReceivedAction action) async {
    final payload = parsePayload(action.payload);
    _events.add({
      ...payload,
      'action': 'clicked',
      'response': action.buttonKeyPressed,
    });
    try {
      await navigateFromPayload(payload);
    } catch (error, stackTrace) {
      _logger.e(
        'Notification navigation failed',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _onForegroundMessage(RemoteMessage message) async {
    _events.add({...message.data, 'action': 'received'});
    if (shouldSuppress(message)) {
      _logger.d('Foreground notification suppressed.');
      return;
    }
    await showNotification(message);
  }

  Future<void> _onTokenRefresh(String token) async {
    if (_session.status == SessionStatus.authenticated &&
        areNotificationsEnabled) {
      await _register(token);
    }
  }

  Future<void> _onSessionStatus(SessionStatus status) async {
    if (status == SessionStatus.authenticated) {
      await _syncToken();
    }
  }

  /// Logout hook: the device must stop receiving the previous user's pushes.
  Future<void> _onLogout() => _unregisterAndDeleteToken();

  Future<void> _syncToken() async {
    if (!areNotificationsEnabled) {
      return;
    }
    try {
      final token = await _push.getToken();
      if (token != null && token != _registeredToken) {
        await _register(token);
      }
    } catch (e, s) {
      _logger.e('Failed to obtain push token', error: e, stackTrace: s);
    }
  }

  Future<void> _register(String token) async {
    final result = await _tokens.register(token: token);
    result.fold(
      (failure) => _logger.e('Push token registration failed: ${failure.type}'),
      (_) => _registeredToken = token,
    );
  }

  Future<void> _unregisterAndDeleteToken() async {
    try {
      final token = _registeredToken ?? await _push.getToken();
      if (token != null) {
        final result = await _tokens.unregister(token: token);
        result.fold(
          (failure) =>
              _logger.e('Push token unregistration failed: ${failure.type}'),
          (_) {},
        );
      }
      await _push.deleteToken();
    } catch (e, s) {
      _logger.e('Failed to delete push token', error: e, stackTrace: s);
    } finally {
      _registeredToken = null;
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
}
