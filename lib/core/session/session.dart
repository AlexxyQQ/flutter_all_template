/// Authentication tokens. Persisted only through [TokenStore] (secure storage).
final class AuthTokens {
  const AuthTokens({required this.accessToken, this.refreshToken});

  final String accessToken;
  final String? refreshToken;

  // Never print tokens.
  @override
  String toString() => 'AuthTokens(<redacted>)';
}

/// Secure persistence of [AuthTokens]. Backed by `SecureStore`.
abstract interface class TokenStore {
  Future<AuthTokens?> read();
  Future<void> save({required AuthTokens tokens});
  Future<void> clear();
}

enum SessionStatus { unknown, authenticated, unauthenticated }

/// Called during logout. Each module (push notifications, caches, analytics…)
/// registers its own cleanup so [SessionManager] doesn't depend on them (DIP).
typedef LogoutHook = Future<void> Function();

/// Owns the session lifecycle: login, logout, and reacting to an
/// unrecoverable 401 from the refresh interceptor.
abstract interface class SessionManager {
  Object? get identity;
  Future<bool> saveRefresh(Object identity, AuthTokens tokens);
  Future<void> expire(Object identity);

  SessionStatus get status;
  Stream<SessionStatus> get statusStream;

  /// Restores the session from [TokenStore] at app start.
  Future<void> restore();

  Future<void> signIn({required AuthTokens tokens});

  /// Clears tokens and runs every registered [LogoutHook]. Storage failures propagate.
  Future<void> signOut();

  void registerLogoutHook({required LogoutHook hook});

  /// Releases resources (e.g. stream controllers). Called by GetIt on teardown.
  Future<void> dispose();
}
