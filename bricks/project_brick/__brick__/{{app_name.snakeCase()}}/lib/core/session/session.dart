/// Authentication tokens. Persisted only through [ITokenStore] (secure storage).
final class AuthTokens {
  const AuthTokens({required this.accessToken, this.refreshToken});

  final String accessToken;
  final String? refreshToken;

  // Never print tokens.
  @override
  String toString() => 'AuthTokens(<redacted>)';
}

/// Secure persistence of [AuthTokens]. Backed by `ISecureStore`.
abstract interface class ITokenStore {
  Future<AuthTokens?> read();
  Future<void> save({required AuthTokens tokens});
  Future<void> clear();
}

enum SessionStatus { unknown, authenticated, unauthenticated }

/// Called during logout. Each module (push notifications, analytics…)
/// registers its own cleanup so [ISessionManager] doesn't depend on them (DIP).
/// User-owned preference keys do not need a hook: store them under
/// `SessionScope.keyPrefix` and they are removed automatically.
typedef LogoutHook = Future<void> Function();

/// The session lifecycle as the app sees it: login, logout and status.
///
/// Token refresh and forced expiry belong to the network layer and live on the
/// separate `ISessionAuthority`.
abstract interface class ISessionManager {
  SessionStatus get status;

  /// Emits the current status to every new listener, then every change.
  Stream<SessionStatus> get statusStream;

  /// Restores the session from [ITokenStore] at app start.
  Future<void> restore();

  Future<void> signIn({required AuthTokens tokens});

  /// Runs every registered [LogoutHook], clears the tokens, then removes all
  /// `SessionScope` preferences. Storage failures propagate.
  Future<void> signOut();

  void registerLogoutHook({required LogoutHook hook});
}
