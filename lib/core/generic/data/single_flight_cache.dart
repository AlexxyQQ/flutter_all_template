import 'dart:async';

/// In-memory cache for **one** value with optional time-to-live and request
/// coalescing (concurrent [get]s share a single in-flight [fetch]).
///
/// Typical use: the current user's profile or remote config, held by a
/// repository:
///
/// ```dart
/// late final _profile = SingleFlightCache<Profile>(
///   fetch: () => _remote.getProfile(),
///   ttl: const Duration(minutes: 5),
/// );
/// ResultFuture<Profile> getProfile() => guard(_profile.get);
/// ```
///
/// Errors from [fetch] propagate to every waiting caller and are not cached.
class SingleFlightCache<T> {
  SingleFlightCache({
    required Future<T> Function() fetch,
    this.ttl,
    DateTime Function()? now,
  }) : _fetch = fetch,
       _now = now ?? DateTime.now;

  final Future<T> Function() _fetch;
  final DateTime Function() _now;

  /// How long a fetched value stays fresh. `null` = until [invalidate].
  final Duration? ttl;

  ({T value, DateTime storedAt})? _entry;
  Future<T>? _inFlight;

  // Bumped by [invalidate]/[set] so a fetch started earlier can't overwrite
  // newer state when it completes.
  int _generation = 0;

  /// Returns the cached value if fresh; otherwise fetches it (joining an
  /// in-flight fetch if there is one). [forceRefresh] skips the cached value.
  Future<T> get({bool forceRefresh = false}) {
    final fresh = forceRefresh ? null : peek();
    if (fresh != null) {
      return Future<T>.value(fresh.value);
    }
    return _inFlight ??= _load();
  }

  /// The cached value if present and fresh, without fetching.
  ({T value})? peek() {
    final entry = _entry;
    if (entry == null) {
      return null;
    }
    final ttl = this.ttl;
    if (ttl != null && _now().difference(entry.storedAt) > ttl) {
      _entry = null;
      return null;
    }
    return (value: entry.value);
  }

  /// Stores [value] as if it had just been fetched.
  void set(T value) {
    _generation++;
    _inFlight = null;
    _entry = (value: value, storedAt: _now());
  }

  /// Drops the cached value; the next [get] fetches again.
  void invalidate() {
    _generation++;
    _inFlight = null;
    _entry = null;
  }

  Future<T> _load() async {
    final generation = _generation;
    try {
      final value = await _fetch();
      if (generation == _generation) {
        _entry = (value: value, storedAt: _now());
      }
      return value;
    } finally {
      if (generation == _generation) {
        _inFlight = null;
      }
    }
  }
}
