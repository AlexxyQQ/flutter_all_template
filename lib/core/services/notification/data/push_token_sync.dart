import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../session/session.dart';
import '../../logger/domain/logger_service.dart';
import '../domain/push_token_repository.dart';
import 'notification_preferences.dart';
import 'push/push_messaging_client.dart';

/// Keeps the backend's copy of this device's FCM token in step with the
/// session: registered while a session is authenticated (and notifications
/// are enabled), unregistered + deleted on logout or when switched off.
@lazySingleton
class PushTokenSync {
  PushTokenSync({
    required IPushMessagingClient push,
    required IPushTokenRepository tokens,
    required ISessionManager session,
    required NotificationPreferences settings,
    required ILoggerService logger,
  }) : _push = push,
       _tokens = tokens,
       _session = session,
       _settings = settings,
       _logger = logger;

  final IPushMessagingClient _push;
  final IPushTokenRepository _tokens;
  final ISessionManager _session;
  final NotificationPreferences _settings;
  final ILoggerService _logger;

  final List<StreamSubscription<Object?>> _subscriptions = [];

  /// Shared by every caller while a sync runs, so concurrent triggers (the
  /// session stream replaying its current value, a permission grant, a token
  /// refresh) produce a single backend request.
  Future<void>? _inFlight;

  /// Last token successfully registered with the backend (never logged).
  String? _registeredToken;

  /// Starts reacting to session changes and token refreshes, and registers the
  /// logout hook. The session stream replays its current status on listen, so
  /// an already-authenticated start registers the token without an extra call.
  void start() {
    _subscriptions
      ..add(_session.statusStream.listen(_onSessionStatus))
      ..add(_push.onTokenRefresh.listen(_onTokenRefresh));
    _session.registerLogoutHook(hook: unregisterAndDelete);
  }

  Future<void> dispose() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    _subscriptions.clear();
  }

  /// Registers the current FCM token when signed in and enabled.
  Future<void> sync() => _inFlight ??= _sync().whenComplete(() {
    _inFlight = null;
  });

  /// Unregisters the token from the backend and deletes it locally so FCM
  /// stops delivering to this install.
  Future<void> unregisterAndDelete() async {
    try {
      final token = _registeredToken ?? await _push.getToken();
      if (token != null) {
        final result = await _tokens.unregister(token: token);
        result.fold(
          (failure) => _logger.error(
            'Push token unregistration failed: ${failure.type}',
          ),
          (_) {},
        );
      }
      await _push.deleteToken();
    } catch (e, s) {
      _logger.error('Failed to delete push token', error: e, stackTrace: s);
    } finally {
      _registeredToken = null;
    }
  }

  bool get _shouldRegister =>
      _session.status == SessionStatus.authenticated && _settings.areEnabled;

  Future<void> _sync() async {
    if (!_shouldRegister) {
      return;
    }
    try {
      final token = await _push.getToken();
      if (token != null && token != _registeredToken) {
        await _register(token: token);
      }
    } catch (e, s) {
      _logger.error('Failed to obtain push token', error: e, stackTrace: s);
    }
  }

  Future<void> _onSessionStatus(SessionStatus status) async {
    if (status == SessionStatus.authenticated) {
      await sync();
    }
  }

  Future<void> _onTokenRefresh(String token) async {
    if (_shouldRegister) {
      await _register(token: token);
    }
  }

  Future<void> _register({required String token}) async {
    final result = await _tokens.register(token: token);
    result.fold(
      (failure) =>
          _logger.error('Push token registration failed: ${failure.type}'),
      (_) => _registeredToken = token,
    );
  }
}
