import 'session.dart';

/// Session operations used only by the network interceptors (token refresh).
/// Nothing outside `core/session` and `core/network` may depend on it.
///
/// A request belongs to the session whose [generation] was current when its
/// token was attached. [generation] increases on every sign-in, sign-out and
/// expiry, so a late 401, refresh result or expiry from an old session carries
/// a different number and is ignored.
abstract interface class ISessionAuthority {
  int get generation;

  /// Persists refreshed tokens. Returns `false` (and saves nothing) when the
  /// session ended or changed since [generation] was read.
  Future<bool> saveRefreshedTokens({
    required int generation,
    required AuthTokens tokens,
  });

  /// Signs out, but only if [generation] is still the current session.
  Future<void> expire({required int generation});
}
