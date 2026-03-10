import 'dart:async';

import '../../../common/domain/services/logger/logger_service.dart';

/// An abstract class for caching a **Single Specific Resource** (Singleton Cache).
///
/// Unlike a generic cache that manages multiple keys (e.g., caching *all* users by ID),
/// this class is designed for unique resources where only one instance exists in the
/// context of the application.
///
/// ## Common Use Cases
/// * **Current User Profile**: The logged-in user's details.
/// * **Application Configuration**: Remote config fetched from a server.
/// * **Dashboard Summary**: A specific, heavy data object loaded on the home screen.
///
/// ## Key Features
///
/// 1.  **Simplified API**: Consumers call `get()` without arguments. The specific
///     identifier (key) is encapsulated within the service implementation.
/// 2.  **Request Coalescing**: Prevents duplicate network calls if multiple widgets
///     request the data simultaneously.
/// 3.  **Time-To-Live (TTL)**: Automatically expires data to ensure freshness.
///
/// ## Example Usage
///
/// ```dart
/// // 1. Implement the service for a specific resource (e.g., App Config)
/// class AppConfigCache extends BaseSingleCacheService<Map<String, dynamic>> {
///   AppConfigCache() : super(
///     key: 'app_config', // Unique internal identifier
///     ttl: const Duration(minutes: 30),
///   );
///
///   @override
///   Future<Map<String, dynamic>?> fetch() async {
///     // Perform the actual network request
///     return await api.fetchRemoteConfig();
///   }
/// }
///
/// // 2. Use it (No keys needed!)
/// void main() async {
///   final configService = AppConfigCache();
///
///   // First call: Triggers network request
///   final config = await configService.get();
///
///   // Second call: Returns instantly from memory
///   final config2 = await configService.get();
/// }
/// ```
abstract class BaseSingleCacheService<T> {
  BaseSingleCacheService({
    required this.key,
    this.ttl,
    this.enableCache = true,
  });

  /// A unique internal identifier for this resource.
  ///
  /// Even though the consumer doesn't pass a key, we need this internally
  /// for logging, debugging, or potential future extensions.
  final String key;

  /// Defines how long the value remains valid in the cache.
  ///
  /// * If set to a [Duration], data older than this is considered "stale"
  ///   and will trigger a new [fetch] on the next request.
  /// * If `null`, data persists indefinitely until manually invalidated.
  final Duration? ttl;

  /// Global switch to enable or disable caching.
  ///
  /// * `true` (default): Caching, TTL, and Request Coalescing are active.
  /// * `false`: The service acts as a pass-through. Every call to [get]
  ///   will directly trigger [fetch].
  final bool enableCache;

  /// Internal storage for the successfully fetched result.
  _CacheEntry<T>? _cacheEntry;

  /// Internal tracker for a generic `Future` currently in progress.
  /// Used to implement Request Coalescing.
  Future<T?>? _inProgress;

  /// The abstract method to be implemented by subclasses.
  ///
  /// This is where the specific data retrieval logic (API call, DB query) resides.
  /// This method is called automatically by [get] when the cache is empty or expired.
  Future<T?> fetch();

  /// Helper to create a consistent log tag based on the unique key.
  /// Example: "Cache:user_profile"
  String get _logTag => 'Cache:$key';

  /// Asynchronously retrieves the cached resource.
  ///
  /// This method orchestrates the caching strategy:
  /// 1.  **Cache Hit**: Checks if valid (non-expired) data exists.
  /// 2.  **Coalescing**: Checks if a fetch is already running; if so, returns that same Future.
  /// 3.  **Fetch**: Initiates a new [fetch] operation if neither of the above apply.
  Future<T?> get() {
    AppLogger.debug('Requesting data...', name: _logTag);

    if (!enableCache) {
      AppLogger.debug(
        'Cache disabled. Bypassing logic -> Calling fetch().',
        name: _logTag,
      );

      return fetch();
    }

    // 1. Check if valid data exists in cache
    if (_hasValidEntry()) {
      AppLogger.debug('✅ Cache HIT. Returning memory data.', name: _logTag);

      return Future.value(_cacheEntry!.value);
    }

    // 2. Check if a request is already in progress (Request Coalescing)
    if (_inProgress != null) {
      AppLogger.debug(
        '🔗 Request Coalescing: Joining in-progress fetch.',
        name: _logTag,
      );
      return _inProgress!;
    }

    // 3. Initiate new fetch
    AppLogger.debug(
      '❌ Cache MISS (Empty or Expired). Initiating fetch...',
      name: _logTag,
    );
    final future = _fetchAndCache();
    _inProgress = future;
    return future;
  }

  /// Synchronously retrieves the item if it is available in memory and valid.
  ///
  /// Returns `null` if the data hasn't been fetched yet or if it has expired.
  /// This is useful for UI rendering where you cannot await a Future.
  T? getSync() {
    if (_hasValidEntry()) {
      return _cacheEntry!.value;
    }
    return null;
  }

  /// Manually inserts or updates the value in the cache.
  ///
  /// This effectively resets the TTL timer for the resource.
  void set(T? value) {
    AppLogger.info('💾 Manually updating cache value.', name: _logTag);
    _cacheEntry = _CacheEntry(value: value, timestamp: DateTime.now());
  }

  void getSet({required Function(T? currentData) data}) {
    final currentData = getSync();
    AppLogger.info(
      '💾 Manually updating cache value. ${currentData.toString()}',
      name: _logTag,
    );
    final T? newData = data(currentData);
    set(newData);
  }

  /// Invalidates the cache.
  ///
  /// Removes the stored value and clears any in-progress flags.
  /// The next call to [get] will force a fresh network request.
  void invalidate() {
    AppLogger.info(
      '🗑️ Invalidating cache. Next get() will trigger fetch.',
      name: _logTag,
    );
    _cacheEntry = null;
    _inProgress = null;
  }

  /// Internal helper to verify if the cache entry exists and is within the [ttl].
  bool _hasValidEntry() {
    if (_cacheEntry == null) return false;

    if (ttl != null) {
      final isExpired =
          DateTime.now().difference(_cacheEntry!.timestamp) > ttl!;
      if (isExpired) {
        AppLogger.debug('⏰ TTL Expired. Marking data as stale.', name: _logTag);
        _cacheEntry = null;
        return false;
      }
    }
    return true;
  }

  /// Executes the fetch, handles storage, and ensures the loading state is cleaned up.
  Future<T?> _fetchAndCache() async {
    try {
      final result = await fetch();
      AppLogger.info('⬇️ Fetch successful. Updating cache.', name: _logTag);
      set(result);
      _cacheEntry = _CacheEntry(value: result, timestamp: DateTime.now());
      return result;
    } catch (e, s) {
      // Allow the error to propagate, but ensure the 'loading' state is cleared.
      AppLogger.error(
        '❌ Fetch failed.',
        error: e,
        stackTrace: s,
        name: _logTag,
      );
      rethrow;
    } finally {
      _inProgress = null;
    }
  }
}

/// A private wrapper class to associate a cached value with its fetch time.
class _CacheEntry<T> {
  _CacheEntry({required this.value, required this.timestamp});
  final T? value;
  final DateTime timestamp;
}
