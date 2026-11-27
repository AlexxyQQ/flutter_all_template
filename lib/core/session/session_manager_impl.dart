import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../generic/data/async_lock.dart';
import '../services/logger/data/app_logger.dart';
import '../storage/key_value_stores.dart';
import 'session.dart';
import 'session_authority.dart';
import 'session_scope.dart';

/// Default [ISessionManager] and [ISessionAuthority] (see `SessionModule`).
///
/// `signOut()` order:
/// 1. run every registered [LogoutHook] (they may still need the token, e.g.
///    to unregister a push token on the backend), each isolated with its own
///    try/catch and a timeout;
/// 2. clear the stored tokens;
/// 3. remove every `SessionScope` preference;
/// 4. emit [SessionStatus.unauthenticated].
///
/// Concurrent `signOut()` calls (e.g. several 401s at once) share one run.
@lazySingleton
class SessionManagerImpl implements ISessionManager, ISessionAuthority {
  SessionManagerImpl({
    required ITokenStore tokenStore,
    required IPreferencesStore preferences,
  }) : _tokenStore = tokenStore,
       _preferences = preferences;

  static const Duration hookTimeout = Duration(seconds: 5);
  static const String _name = 'SessionManager';

  final ITokenStore _tokenStore;
  final IPreferencesStore _preferences;
  final List<LogoutHook> _logoutHooks = [];
  final AsyncLock _lock = AsyncLock();
  final BehaviorSubject<SessionStatus> _status =
      BehaviorSubject<SessionStatus>.seeded(SessionStatus.unknown);

  int _generation = 0;
  Future<void>? _signingOut;

  @override
  int get generation => _generation;

  @override
  SessionStatus get status => _status.value;

  @override
  Stream<SessionStatus> get statusStream => _status.stream;

  @override
  Future<void> restore() => _lock.synchronized(() async {
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
  });

  @override
  Future<void> signIn({required AuthTokens tokens}) {
    // A sign-out requested after this sign-in must start a fresh run.
    _signingOut = null;
    return _lock.synchronized(() async {
      await _tokenStore.save(tokens: tokens);
      _generation++;
      _setStatus(SessionStatus.authenticated);
    });
  }

  @override
  Future<void> signOut() {
    final existing = _signingOut;
    if (existing != null) {
      return existing;
    }
    // Immediately orphan requests and refreshes of the ending session.
    _generation++;
    late final Future<void> run;
    run = _lock.synchronized(_signOut).whenComplete(() {
      if (identical(run, _signingOut)) {
        _signingOut = null;
      }
    });
    return _signingOut = run;
  }

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
      await _preferences.removeByPrefix(prefix: SessionScope.keyPrefix);
    } catch (e, s) {
      AppLogger.error(
        'Failed to clear session data on sign-out',
        error: e,
        stackTrace: s,
        name: _name,
      );
      rethrow;
    }
    _setStatus(SessionStatus.unauthenticated);
  }

  @override
  Future<bool> saveRefreshedTokens({
    required int generation,
    required AuthTokens tokens,
  }) => _lock.synchronized(() async {
    if (generation != _generation) {
      return false;
    }
    await _tokenStore.save(tokens: tokens);
    return generation == _generation;
  });

  @override
  Future<void> expire({required int generation}) =>
      generation == _generation ? signOut() : Future<void>.value();

  @override
  void registerLogoutHook({required LogoutHook hook}) => _logoutHooks.add(hook);

  void _setStatus(SessionStatus status) {
    if (_status.value != status) {
      _status.add(status);
    }
  }

  /// Releases the status stream. Called by GetIt on teardown.
  @disposeMethod
  Future<void> dispose() => _status.close();
}
