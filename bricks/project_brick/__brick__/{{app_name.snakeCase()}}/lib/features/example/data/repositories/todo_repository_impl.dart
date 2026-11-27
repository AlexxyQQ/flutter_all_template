import 'package:injectable/injectable.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/guard.dart';
import '../../../../core/error/typedef.dart';
import '../../../../core/generic/domain/entities/page.dart';
import '../../../../core/services/logger/data/app_logger.dart';
import '../../domain/entities/todo.dart';
import '../../domain/params/todo_params.dart';
import '../../domain/repositories/todo_repository.dart';
import '../data_sources/local/todo_local_data_source.dart';
import '../data_sources/remote/todo_remote_data_source.dart';
import '../models/todo_model.dart';

/// Remote-first repository with a small offline fallback.
///
/// * **Reads** go to the API. A first page is cached (one entry: the last one
///   served). When the device is offline (`NetworkException` /
///   `RequestTimeoutException`) the cached first page of the *same* query is
///   served; otherwise the original network error is returned.
/// * **Writes** go to the API, then drop the cached page (it no longer
///   matches the server). There is no offline outbox: a write made offline
///   fails.
/// * **Cache failures never fail a call** that already succeeded; they are
///   logged.
/// * **Account safety** is the cache key's job: it lives under
///   `SessionScope.keyPrefix`, which sign-out wipes.
@LazySingleton(as: ITodoRepository)
class TodoRepositoryImpl implements ITodoRepository {
  TodoRepositoryImpl({
    required ITodoRemoteDataSource remote,
    required ITodoLocalDataSource local,
  }) : _remote = remote,
       _local = local;

  static const String _logName = 'TodoRepository';

  final ITodoRemoteDataSource _remote;
  final ITodoLocalDataSource _local;

  @override
  ResultFuture<PageResult<Todo>> getTodos({
    required PageRequest page,
    TodoQuery query = const TodoQuery(),
  }) => guard(() async {
    try {
      final result = await _remote.getTodos(page: page, query: query);
      if (page.isFirst) {
        await _bestEffort(
          () => _local.saveFirstPage(
            query: query,
            limit: page.limit,
            result: result,
          ),
        );
      }
      return result.map((model) => model.toEntity());
    } on AppException catch (e) {
      if (!page.isFirst || !_isOffline(e)) {
        rethrow;
      }
      final cached = await _readCache(query: query, limit: page.limit);
      if (cached == null) {
        rethrow; // Report the network problem, not the cache miss.
      }
      return cached.map((model) => model.toEntity());
    }
  });

  @override
  ResultFuture<Todo> createTodo({required CreateTodoParams params}) =>
      guard(() async {
        final model = await _remote.createTodo(params: params);
        await _bestEffort(_local.clear);
        return model.toEntity();
      });

  @override
  ResultFuture<Todo> updateTodo({required UpdateTodoParams params}) =>
      guard(() async {
        final model = await _remote.updateTodo(params: params);
        await _bestEffort(_local.clear);
        return model.toEntity();
      });

  @override
  ResultFuture<void> deleteTodo({required String id}) => guard(() async {
    await _remote.deleteTodo(id: id);
    await _bestEffort(_local.clear);
  });

  static bool _isOffline(AppException e) =>
      e is NetworkException || e is RequestTimeoutException;

  Future<PageResult<TodoModel>?> _readCache({
    required TodoQuery query,
    required int limit,
  }) async {
    try {
      return await _local.getFirstPage(query: query, limit: limit);
    } on StorageException catch (e, s) {
      _logCacheFailure(e, s);
      return null; // An unreadable cache behaves like an empty one.
    }
  }

  /// Cache writes are an optimisation: the remote call already succeeded, so
  /// a store failure is logged, not surfaced.
  static Future<void> _bestEffort(Future<void> Function() write) async {
    try {
      await write();
    } on StorageException catch (e, s) {
      _logCacheFailure(e, s);
    }
  }

  static void _logCacheFailure(StorageException error, StackTrace stackTrace) =>
      AppLogger.warning(
        'To-do cache unavailable',
        error: error,
        stackTrace: stackTrace,
        name: _logName,
      );
}
