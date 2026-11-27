/// Marks local data that belongs to the signed-in user.
///
/// Every user-owned key in `IPreferencesStore` (caches, per-user settings) is
/// stored as `'${SessionScope.keyPrefix}<name>'`. `ISessionManager` removes all
/// of them on sign-out and on forced session expiry, so one user's data can
/// never be shown to the next user, and no feature has to register a hook.
abstract final class SessionScope {
  static const String keyPrefix = 'session.';
}
