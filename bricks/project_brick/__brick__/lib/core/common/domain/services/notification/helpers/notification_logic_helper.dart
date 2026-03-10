import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../locator/service_locator.dart';
import '../../logger/logger_service.dart';
import '../../navigation/navigation_service.dart';

class NotificationLogicHelper {
  NotificationLogicHelper(
    this._firebaseMessaging,
    this._awesomeNotifications,
    this._logger,
  );
  final FirebaseMessaging _firebaseMessaging;
  final AwesomeNotifications _awesomeNotifications;
  final ILoggerService _logger;
  SharedPreferences? _prefs;

  // New Constant for Preference Key
  static const String _kAppNotificationsEnabled = 'app_notifications_enabled';

  void setPrefs(SharedPreferences prefs) {
    _prefs = prefs;
  }

  // --- Toggle Logic (New) ---

  /// Enable or Disable notifications for the entire app.
  Future<void> setAppNotificationsEnabled(bool isEnabled) async {
    if (_prefs == null) return;

    await _prefs!.setBool(_kAppNotificationsEnabled, isEnabled);

    if (isEnabled) {
      // User turned ON: Get a new token and send to server
      final String? token = await _firebaseMessaging.getToken();
      _logger.i('Notifications Enabled. New Token: $token');
      // TODO: Call your API to register this new token
    } else {
      // User turned OFF: Delete token so FCM stops sending messages
      await _firebaseMessaging.deleteToken();
      _logger.i('Notifications Disabled. Token deleted.');
    }
  }

  /// Check if notifications are enabled (Defaults to true).
  bool get areAppNotificationsEnabled {
    return _prefs?.getBool(_kAppNotificationsEnabled) ?? true;
  }

  // --- Token & Permissions ---

  Future<String?> getFcmToken() async {
    return _firebaseMessaging.getToken().catchError((e) {
      _logger.e('Failed to get FCM token', error: e);
      return null;
    });
  }

  Future<void> deleteToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      _logger.i('FCM Token deleted.');
    } catch (e) {
      _logger.e('Error deleting FCM token', error: e);
    }
  }

  Future<bool> requestPermission() async {
    bool isAllowed = await _awesomeNotifications.isNotificationAllowed();
    if (!isAllowed) {
      _logger.i('Requesting notification permission...');
      isAllowed = await _awesomeNotifications
          .requestPermissionToSendNotifications();
    }
    await _firebaseMessaging.requestPermission();
    _logger.i('Notification permission status: $isAllowed');
    return isAllowed;
  }

  // --- Suppression Logic ---

  Future<void> suppressNotificationsForContext(String threadId) async {
    if (_prefs == null) return;
    final id = threadId.replaceAll('th_', '');
    _logger.d('Suppressing notifications for thread: $id');
    await _prefs!.setString('current_thread', id);
  }

  Future<void> clearContextSuppression() async {
    if (_prefs == null) return;
    _logger.d('Clearing notification suppression context.');
    await _prefs!.remove('current_thread');
  }

  bool shouldSuppress(RemoteMessage message) {
    // 1. Check Global Toggle
    if (!areAppNotificationsEnabled) {
      return true;
    }

    // 2. Check Context (Thread) Suppression
    final current = _prefs?.getString('current_thread');
    if (current == null) return false;

    final incoming = (message.data['thread_id'] ?? '').replaceAll('th_', '');
    return current == incoming;
  }

  // --- Navigation & Action Logic ---

  Map<String, dynamic> parseActionPayload(Map<String, String?>? payload) {
    final rawPayload = payload ?? {};
    return rawPayload.map((key, value) {
      if (value == null) return MapEntry(key, null);
      if (value.startsWith('{') || value.startsWith('[')) {
        try {
          return MapEntry(key, jsonDecode(value));
        } catch (_) {
          return MapEntry(key, value);
        }
      }
      return MapEntry(key, value);
    });
  }

  void navigateFromPayload(Map<String, dynamic> payload) {
    final redirectUrl = payload['redirect_url'] as String?;
    if (redirectUrl == null) return;

    final sanitized = redirectUrl.replaceAll('th_', '');
    final route = sanitized.startsWith('/') ? sanitized : '/$sanitized';

    if (sl.isRegistered<NavigationService>()) {
      sl<NavigationService>().pushNamed(route);
    } else {
      _logger.e('NavigationService not registered. Cannot navigate to $route.');
    }
  }
}
