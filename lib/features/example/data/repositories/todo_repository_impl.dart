import 'package:injectable/injectable.dart';

import '../../../../config/constants/type_defs/typedef.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/error/guard.dart';
import '../../../../core/generic/domain/entities/page.dart';
import '../../domain/entities/todo.dart';
import '../../domain/params/todo_params.dart';
import '../../domain/repositories/todo_repository.dart';
import '../data_sources/local/todo_local_data_source.dart';
import '../data_sources/remote/todo_remote_data_source.dart';
import '../models/todo_model.dart';

/// Remote-first repository with an offline read cache:
/// * reads go to the API and are cached locally; if the device is offline
///   (`NetworkException`/`RequestTimeoutException`) cached data is served
///   instead, and the original error is returned when nothing is cached;
/// * writes go to the API and then update the cache (no offline outbox);
/// * a failing cache write never fails an otherwise successful call.
@LazySingleton(as: ITodoRepository)
class TodoRepositoryImpl implements ITodoRepository {
  TodoRepositoryImpl(this._remote, this._local);

  final ITodoRemoteDataSource _remote;
  final ITodoLocalDataSource _local;

  @override
  ResultFuture<PageResult<Todo>> getTodos({
    required PageRequest page,
    TodoQuery query = const TodoQuery(),
  }) => guard(() async {
    try {
      final result = await _remote.getTodos(page: page, query: query);
      await _cache(() => _local.saveTodos(result.items));
      return result.map((model) => model.toEntity());
    } on AppException catch (e) {
      if (!_isOffline(e)) {
        rethrow;
      }
      final cached = await _local.getTodos();
      if (cached.isEmpty) {
        rethrow;
      }
      return _pageOf(cached, page: page, query: query);
    }
  });

  @override
  ResultFuture<Todo> getTodo(String id) => guard(() async {
    try {
      final model = await _remote.getTodo(id);
      await _cache(() => _local.saveTodo(model));
      return model.toEntity();
    } on AppException catch (e) {
      if (!_isOffline(e)) {
        rethrow;
      }
      try {
        return (await _local.getTodo(id)).toEntity();
      } on CacheMissException {
        throw e; // Report the network problem, not the cache miss.
      }
    }
  });

  @override
  ResultFuture<Todo> createTodo(CreateTodoParams params) => guard(() async {
    final model = await _remote.createTodo(params);
    await _cache(() => _local.saveTodo(model));
    return model.toEntity();
  });

  @override
  ResultFuture<Todo> updateTodo(UpdateTodoParams params) => guard(() async {
    final model = await _remote.updateTodo(params);
    await _cache(() => _local.saveTodo(model));
    return model.toEntity();
  });

  @override
  ResultFuture<void> deleteTodo(String id) => guard(() async {
    await _remote.deleteTodo(id);
    await _cache(() => _local.deleteTodo(id));
  });

  static bool _isOffline(AppException e) =>
      e is NetworkException || e is RequestTimeoutException;

  /// Cache writes are best-effort: the remote call already succeeded.
  static Future<void> _cache(Future<void> Function() write) async {
    try {
      await write();
    } on StorageException {
      // Stale cache is acceptable; the next successful read rewrites it.
    }
  }

  /// Applies [query] and page-number pagination to the cached items.
  static PageResult<Todo> _pageOf(
    List<TodoModel> cached, {
    required PageRequest page,
    required TodoQuery query,
  }) {
    final search = query.search.trim().toLowerCase();
    final matching =
        cached
            .where((t) => !query.onlyOpen || !t.isDone)
            .where(
              (t) => search.isEmpty || t.title.toLowerCase().contains(search),
            )
            .map((t) => t.toEntity())
            .toList()
          ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    final items = matching.skip(page.offset).take(page.limit).toList();
    return PageResult(
      items: items,
      hasMore: page.offset + items.length < matching.length,
    );
  }
}
