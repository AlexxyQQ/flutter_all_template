import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../locator/service_locator.dart';
import '../logger/logger_service.dart';
import 'helpers/fcm_background_handler.dart';
import 'helpers/notification_channels.dart';
import 'helpers/notification_display_helper.dart';
import 'helpers/notification_logic_helper.dart';
import 'helpers/safe_logger.dart';

class NotificationService {
  // ---------------------------------------------------------------------------
  // CONSTRUCTORS & DEPENDENCIES
  // ---------------------------------------------------------------------------

  NotificationService._internal({
    FirebaseMessaging? firebaseMessaging,
    AwesomeNotifications? awesomeNotifications,
    ILoggerService? logger,
  }) {
    final fbMessaging = firebaseMessaging ?? FirebaseMessaging.instance;
    final awNotifications = awesomeNotifications ?? AwesomeNotifications();
    final logService =
        logger ??
        (sl.isRegistered<ILoggerService>()
            ? sl<ILoggerService>()
            : SafeLogger());

    _logger = logService;
    _logicHelper = NotificationLogicHelper(
      fbMessaging,
      awNotifications,
      logService,
    );
    _displayHelper = NotificationDisplayHelper(awNotifications, logService);
    _awesomeNotifications = awNotifications;
    _firebaseMessaging = fbMessaging;
  }

  late final NotificationLogicHelper _logicHelper;
  late final NotificationDisplayHelper _displayHelper;
  late final ILoggerService _logger;
  late final AwesomeNotifications _awesomeNotifications;
  late final FirebaseMessaging _firebaseMessaging;

  // ---------------------------------------------------------------------------
  // STATE
  // ---------------------------------------------------------------------------

  static final NotificationService instance = NotificationService._internal();

  final StreamController<Map<String, dynamic>> _notificationController =
      StreamController<Map<String, dynamic>>.broadcast();

  bool _initialized = false;
  String? _fcmToken;

  Stream<Map<String, dynamic>> get notificationStream =>
      _notificationController.stream;

  String? get fcmToken => _fcmToken;

  // ---------------------------------------------------------------------------
  // PUBLIC API - TOGGLE
  // ---------------------------------------------------------------------------

  /// Checks if notifications are currently enabled by the user.
  bool get areNotificationsEnabled => _logicHelper.areAppNotificationsEnabled;

  /// Toggles notifications on or off.
  /// If [isEnabled] is false, it will also cancel all active notifications.
  Future<void> toggleNotifications(bool isEnabled) async {
    await _logicHelper.setAppNotificationsEnabled(isEnabled);

    if (!isEnabled) {
      _logger.i(
        'Notifications disabled by user. Cancelling active notifications.',
      );
      await _displayHelper.cancelNotification(
        -1,
      ); // -1 often cancels all, or loop
      await _awesomeNotifications.cancelAll();
    }
  }

  // ---------------------------------------------------------------------------
  // INITIALIZATION
  // ---------------------------------------------------------------------------

  Future<void> initialize() async {
    if (_initialized) return;
    _logger.i('Initializing NotificationService...');

    try {
      final prefs = await SharedPreferences.getInstance();
      _logicHelper.setPrefs(prefs);

      await _configureAwesomeNotifications();
      await _configureFCMHandlers();

      _fcmToken = await _logicHelper.getFcmToken();
      _initialized = true;
      _logger.i('NotificationService initialized successfully.');
    } catch (e, s) {
      _logger.e(
        'Error initializing NotificationService',
        error: e,
        stackTrace: s,
      );
    }
  }

  @pragma('vm:entry-point')
  Future<void> initBackground() async {
    if (_initialized) return;
    final prefs = await SharedPreferences.getInstance();
    _logicHelper.setPrefs(prefs);
    await _configureAwesomeNotifications();
    _initialized = true;
  }

  // ---------------------------------------------------------------------------
  // PUBLIC API - DELEGATED METHODS
  // ---------------------------------------------------------------------------

  Future<void> showNotification(
    RemoteMessage message, {
    bool isAppInForeground = false,
    bool force = false, // Added force param if you want to bypass the toggle
  }) async {
    // Check toggle before showing
    if (!force && !_logicHelper.areAppNotificationsEnabled) {
      _logger.d('Notification suppressed: App notifications disabled.');
      return;
    }

    await _displayHelper.showNotification(
      message,
      isAppInForeground: isAppInForeground,
      onRequestPermission: requestPermission,
    );
  }

  Future<void> showSimpleNotification({
    required int id,
    required String title,
    required String body,
    Map<String, String?>? payload,
  }) async {
    if (!_logicHelper.areAppNotificationsEnabled) return;

    await _displayHelper.showSimpleNotification(
      id: id,
      title: title,
      body: body,
      payload: payload,
    );
  }

  Future<void> showProgressNotification({
    required int id,
    required String title,
    required String body,
    required int progress,
  }) async {
    // Usually progress notifications (like downloads) should show
    // even if general notifications are off. If you want to suppress them too,
    // uncomment the line below.
    // if (!_logicHelper.areAppNotificationsEnabled) return;

    await _displayHelper.showProgressNotification(
      id: id,
      title: title,
      body: body,
      progress: progress,
    );
  }

  Future<void> cancelNotification(int id) =>
      _displayHelper.cancelNotification(id);

  Future<void> suppressNotificationsForContext(String threadId) =>
      _logicHelper.suppressNotificationsForContext(threadId);

  Future<void> clearContextSuppression() =>
      _logicHelper.clearContextSuppression();

  Future<void> deleteToken() async {
    await _logicHelper.deleteToken();
    _fcmToken = null;
  }

  Future<bool> requestPermission() => _logicHelper.requestPermission();

  void dispose() {
    _notificationController.close();
    _awesomeNotifications.cancelAll();
  }

  StreamSubscription<Map<String, dynamic>> addListener(
    void Function(Map<String, dynamic>) onData,
  ) {
    return notificationStream.listen(onData);
  }

  // ---------------------------------------------------------------------------
  // PRIVATE HANDLERS
  // ---------------------------------------------------------------------------

  Future<void> _configureAwesomeNotifications() async {
    await _awesomeNotifications.initialize(
      null,
      NotificationChannelConfig.channels,
      debug: kDebugMode,
    );
    _awesomeNotifications.setListeners(
      onActionReceivedMethod: _onActionReceived,
    );
  }

  Future<void> _configureFCMHandlers() async {
    final initialAction = await _awesomeNotifications
        .getInitialNotificationAction();
    if (initialAction != null) {
      _handleNotificationAction(initialAction);
    }
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageReceived);
  }

  Future<void> _onMessageReceived(RemoteMessage message) async {
    _notificationController.add({...message.data, 'action': 'received'});

    // logicHelper.shouldSuppress now checks both context AND global toggle
    if (_logicHelper.shouldSuppress(message)) {
      _logger.i('Notification suppressed (Context or Disabled).');
    } else {
      await showNotification(message, isAppInForeground: true);
    }
  }

  void _handleNotificationAction(ReceivedAction receivedAction) {
    final parsedPayload = _logicHelper.parseActionPayload(
      receivedAction.payload,
    );
    _logicHelper.navigateFromPayload(parsedPayload);
    _notificationController.add({
      ...parsedPayload,
      'action': 'clicked',
      'response': receivedAction.buttonKeyPressed,
    });
  }

  @pragma('vm:entry-point')
  static Future<void> _onActionReceived(ReceivedAction receivedAction) async {
    NotificationService.instance._handleNotificationAction(receivedAction);
  }
}
