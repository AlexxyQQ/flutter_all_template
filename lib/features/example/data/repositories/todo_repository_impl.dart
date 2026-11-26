import 'package:injectable/injectable.dart';

import '../../../../config/constants/type_defs/typedef.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/error/guard.dart';
import '../../../../core/generic/domain/entities/page.dart';
import '../../../../core/session/session.dart';
import '../../domain/entities/todo.dart';
import '../../domain/params/todo_params.dart';
import '../../domain/repositories/todo_repository.dart';
import '../data_sources/local/todo_local_data_source.dart';
import '../data_sources/remote/todo_remote_data_source.dart';
import '../models/todo_model.dart';

/// Remote-first repository with an account-safe offline page cache.
///
/// * **Reads** go to the API; the answer is cached per query and page. When
///   the device is offline (`NetworkException`/`RequestTimeoutException`) the
///   cached answer for the *same* query and page is served; with none cached
///   the original network error is returned. Other queries are never
///   approximated from cached data.
/// * **Writes** go to the API and then patch the cache. There is no offline
///   outbox: a write made offline fails.
/// * **Cache writes are best-effort**: a failing one never fails a call that
///   already succeeded.
/// * **Account safety**: the cache is wiped by a logout hook, and every cache
///   write is skipped when the session changed since the request started, so
///   a response arriving *after* sign-out (or after another account signed
///   in) can never be stored for, or served to, the wrong account.
/// * **Ordering**: a list response is only cached if no mutation started or
///   finished while it was in flight (it may predate the mutation).
///
/// Register this repository eagerly at start-up (resolve it once after DI) so
/// the logout hook exists even when no to-do screen was ever opened.
@LazySingleton(as: ITodoRepository)
class TodoRepositoryImpl implements ITodoRepository {
  TodoRepositoryImpl({
    required ITodoRemoteDataSource remote,
    required ITodoLocalDataSource local,
    required SessionManager session,
  }) : _remote = remote,
       _local = local,
       _session = session {
    _session.registerLogoutHook(hook: _onLogout);
  }

  final ITodoRemoteDataSource _remote;
  final ITodoLocalDataSource _local;
  final SessionManager _session;

  // Bumped on logout: invalidates every request started before it.
  int _generation = 0;
  // Bumped when a mutation starts and when it ends.
  int _mutationVersion = 0;
  int _activeMutations = 0;

  Future<void> _onLogout() {
    _generation++; // Synchronously: late writes are rejected from here on.
    return _local.clear();
  }

  _Ticket _ticket() => _Ticket(
    identity: _session.identity,
    generation: _generation,
    mutationVersion: _mutationVersion,
  );

  /// Whether the session is the one [t] was issued under.
  bool _sameSession(_Ticket t) =>
      t.identity != null &&
      identical(t.identity, _session.identity) &&
      t.generation == _generation;

  @override
  ResultFuture<PageResult<Todo>> getTodos({
    required PageRequest page,
    TodoQuery query = const TodoQuery(),
  }) => guard(() async {
    final ticket = _ticket();
    final startedDuringMutation = _activeMutations > 0;
    try {
      final result = await _remote.getTodos(page: page, query: query);
      if (!startedDuringMutation &&
          _activeMutations == 0 &&
          ticket.mutationVersion == _mutationVersion) {
        await _cache(
          ticket,
          () => _local.savePage(page: page, query: query, result: result),
        );
      }
      return result.map((model) => model.toEntity());
    } on AppException catch (e) {
      if (!_isOffline(e) || !_sameSession(ticket)) {
        rethrow;
      }
      final cached = await _readCache(
        () => _local.getPage(page: page, query: query),
      );
      if (cached == null || !_sameSession(ticket)) {
        rethrow;
      }
      return cached.map((model) => model.toEntity());
    }
  });

  @override
  ResultFuture<Todo> getTodo({required String id}) => guard(() async {
    final ticket = _ticket();
    try {
      final model = await _remote.getTodo(id: id);
      // A single read can't tell where the item sits in a page: don't cache.
      return model.toEntity();
    } on AppException catch (e) {
      if (!_isOffline(e) || !_sameSession(ticket)) {
        rethrow;
      }
      try {
        final model = await _local.getTodo(id: id);
        if (!_sameSession(ticket)) {
          rethrow;
        }
        return model.toEntity();
      } on CacheMissException {
        // ignore: use_rethrow_when_possible
        throw e; // Report the network problem, not the cache miss.
      } on StorageException {
        throw e;
      }
    }
  });

  @override
  ResultFuture<Todo> createTodo({required CreateTodoParams params}) =>
      guard(() => _mutate(() => _remote.createTodo(params: params)));

  @override
  ResultFuture<Todo> updateTodo({required UpdateTodoParams params}) =>
      guard(() => _mutate(() => _remote.updateTodo(params: params)));

  @override
  ResultFuture<void> deleteTodo({required String id}) => guard(() async {
    final ticket = _ticket();
    _beginMutation();
    try {
      await _remote.deleteTodo(id: id);
      await _cache(ticket, () => _local.deleteTodo(id: id));
    } finally {
      _endMutation();
    }
  });

  Future<Todo> _mutate(Future<TodoModel> Function() call) async {
    final ticket = _ticket();
    _beginMutation();
    try {
      final model = await call();
      await _cache(ticket, () => _local.saveTodo(todo: model));
      return model.toEntity();
    } finally {
      _endMutation();
    }
  }

  void _beginMutation() {
    _activeMutations++;
    _mutationVersion++;
  }

  void _endMutation() {
    _activeMutations--;
    _mutationVersion++;
  }

  static bool _isOffline(AppException e) =>
      e is NetworkException || e is RequestTimeoutException;

  /// Cache writes are best-effort and only for the session that issued
  /// [ticket]. The session check and the write's enqueue happen in the same
  /// synchronous step, so a logout's `clear()` always lands after the write.
  Future<void> _cache(_Ticket ticket, Future<void> Function() write) async {
    if (!_sameSession(ticket)) {
      return;
    }
    try {
      await write();
    } on StorageException {
      // Stale cache is acceptable; the next successful read rewrites it.
    }
  }

  static Future<T?> _readCache<T>(Future<T?> Function() read) async {
    try {
      return await read();
    } on StorageException {
      return null; // Unreadable cache behaves like an empty one.
    }
  }
}

/// Identifies the session (and mutation epoch) a request started under.
final class _Ticket {
  const _Ticket({
    required this.identity,
    required this.generation,
    required this.mutationVersion,
  });

  final Object? identity;
  final int generation;
  final int mutationVersion;
}
