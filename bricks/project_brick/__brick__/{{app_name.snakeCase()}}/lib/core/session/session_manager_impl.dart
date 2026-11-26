import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../common/domain/services/logger/logger_service.dart';
import 'session.dart';

/// Default [SessionManager].
///
/// `signOut()` order:
/// 1. run every registered [LogoutHook] (they may still need the token, e.g.
///    to unregister a push token on the backend), each isolated with its own
///    try/catch and a timeout;
/// 2. clear the stored tokens;
/// 3. emit [SessionStatus.unauthenticated].
///
/// Concurrent `signOut()` calls (e.g. several 401s at once) share one run.
@LazySingleton(as: SessionManager)
class SessionManagerImpl implements SessionManager {
  SessionManagerImpl({required TokenStore tokenStore})
    : _tokenStore = tokenStore;

  static const Duration hookTimeout = Duration(seconds: 5);
  static const String _name = 'SessionManager';

  final TokenStore _tokenStore;
  final List<LogoutHook> _logoutHooks = [];
  final BehaviorSubject<SessionStatus> _status =
      BehaviorSubject<SessionStatus>.seeded(SessionStatus.unknown);

  Future<void>? _signingOut;

  @override
  SessionStatus get status => _status.value;

  /// Emits the current status to every new listener, then every change.
  @override
  Stream<SessionStatus> get statusStream => _status.stream;

  @override
  Future<void> restore() async {
    try {
      final tokens = await _tokenStore.read();
      _setStatus(
        tokens == null
            ? SessionStatus.unauthenticated
            : SessionStatus.authenticated,
      );
    } catch (e, s) {
      AppLogger.error(
        'Failed to restore session',
        error: e,
        stackTrace: s,
        name: _name,
      );
      _setStatus(SessionStatus.unauthenticated);
    }
  }

  @override
  Future<void> signIn({required AuthTokens tokens}) async {
    await _tokenStore.save(tokens: tokens);
    _setStatus(SessionStatus.authenticated);
  }

  @override
  Future<void> signOut() =>
      _signingOut ??= _signOut().whenComplete(() => _signingOut = null);

  Future<void> _signOut() async {
    for (final hook in List<LogoutHook>.of(_logoutHooks)) {
      try {
        await hook().timeout(hookTimeout);
      } catch (e, s) {
        AppLogger.error(
          'Logout hook failed',
          error: e,
          stackTrace: s,
          name: _name,
        );
      }
    }
    try {
      await _tokenStore.clear();
    } catch (e, s) {
      AppLogger.error(
        'Failed to clear tokens on sign-out',
        error: e,
        stackTrace: s,
        name: _name,
      );
    }
    _setStatus(SessionStatus.unauthenticated);
  }

  @override
  void registerLogoutHook({required LogoutHook hook}) => _logoutHooks.add(hook);

  void _setStatus(SessionStatus status) {
    if (_status.value != status) {
      _status.add(status);
    }
  }

  @override
  @disposeMethod
  Future<void> dispose() => _status.close();
}
