import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

import '../../logger/domain/logger_service.dart';
import 'helpers/fcm_background_handler.dart';
import 'helpers/notification_display_helper.dart';
import 'notification_preferences.dart';
import 'notification_tap_router.dart';
import 'push/push_messaging_client.dart';
import 'push_token_sync.dart';

/// Start-up and on/off switch of push (FCM) + local (awesome_notifications)
/// notifications. The work itself lives in small collaborators:
///
/// * [NotificationDisplayHelper] - renders notifications
/// * [NotificationTapRouter] - tap -> navigation (incl. the cold-start tap)
/// * [PushTokenSync] - FCM token <-> backend, tied to the session
/// * `NotificationPermissionService` - OS permission (separate, injected where
///   needed through `INotificationPermissionApi`)
///
/// Lifecycle: bootstrap calls [initialize] once, after `Firebase.initializeApp`.
@lazySingleton
class NotificationService {
  NotificationService({
    required IPushMessagingClient push,
    required NotificationPreferences settings,
    required NotificationDisplayHelper display,
    required NotificationTapRouter taps,
    required PushTokenSync tokens,
    required ILoggerService logger,
  }) : _push = push,
       _settings = settings,
       _display = display,
       _taps = taps,
       _tokens = tokens,
       _logger = logger;

  final IPushMessagingClient _push;
  final NotificationPreferences _settings;
  final NotificationDisplayHelper _display;
  final NotificationTapRouter _taps;
  final PushTokenSync _tokens;
  final ILoggerService _logger;

  StreamSubscription<RemoteMessage>? _foreground;
  bool _initialized = false;
  Future<void>? _initializing;

  bool get areNotificationsEnabled => _settings.areEnabled;

  /// Safe to call repeatedly: concurrent callers share one run, and a failed
  /// run can be retried.
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
      await _display.initialize();
      await _taps.start();
      _push.registerBackgroundHandler(handler: FcmBackgroundHandler.handle);
      _foreground = _push.onMessage.listen(_onForegroundMessage);
      _tokens.start();
      _initialized = true;
    } catch (_) {
      await dispose();
      rethrow;
    }
    _logger.info('NotificationService initialized.');
  }

  @disposeMethod
  Future<void> dispose() async {
    await _foreground?.cancel();
    _foreground = null;
    _taps.dispose();
    await _tokens.dispose();
  }

  /// Turns push notifications on/off for this device.
  ///
  /// Off: unregisters + deletes the FCM token (FCM stops delivering) and
  /// clears every displayed notification. On: registers the token again.
  Future<void> toggleNotifications({required bool isEnabled}) async {
    await _settings.setEnabled(value: isEnabled);
    if (isEnabled) {
      await _tokens.sync();
      return;
    }
    await _tokens.unregisterAndDelete();
    await _display.cancelAll();
  }

  /// Shows [message] unless notifications are switched off ([force] ignores
  /// the switch).
  Future<void> showNotification({
    required RemoteMessage message,
    bool force = false,
  }) {
    if (!force && !areNotificationsEnabled) {
      return Future<void>.value();
    }
    return _display.showRemoteMessage(message: message);
  }

  Future<void> cancelNotification({required int id}) => _display.cancel(id: id);

  Future<void> cancelAllNotifications() => _display.cancelAll();

  Future<void> _onForegroundMessage(RemoteMessage message) =>
      showNotification(message: message);
}
