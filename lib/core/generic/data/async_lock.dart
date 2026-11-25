import 'dart:async';

/// A tiny FIFO mutex for async code.
///
/// Every [synchronized] body starts only after all previously scheduled bodies
/// have completed (successfully or not), so read-modify-write sequences on a
/// shared resource can't interleave.
///
/// ```dart
/// final _lock = AsyncLock();
/// Future<void> increment() => _lock.synchronized(() async {
///   final value = await read();
///   await write(value + 1);
/// });
/// ```
///
/// Not re-entrant: calling [synchronized] from inside a body of the same lock
/// deadlocks.
final class AsyncLock {
  Future<void> _tail = Future<void>.value();

  /// Runs [body] once every previously scheduled body has finished and returns
  /// its result (or error).
  Future<R> synchronized<R>(FutureOr<R> Function() body) {
    final previous = _tail;
    final released = Completer<void>();
    _tail = released.future;
    return previous.then((_) => body()).whenComplete(released.complete);
  }
}
