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
  TodoRepositoryImpl({
    required ITodoRemoteDataSource remote,
    required ITodoLocalDataSource local,
  }) : _remote = remote,
       _local = local;

  final ITodoRemoteDataSource _remote;
  final ITodoLocalDataSource _local;

  @override
  ResultFuture<PageResult<Todo>> getTodos({
    required PageRequest page,
    TodoQuery query = const TodoQuery(),
  }) => guard(() async {
    try {
      final result = await _remote.getTodos(page: page, query: query);
      await _cache(() => _local.saveTodos(todos: result.items));
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
  ResultFuture<Todo> getTodo({required String id}) => guard(() async {
    try {
      return await _fetchAndCacheTodo(fetch: () => _remote.getTodo(id: id));
    } on AppException catch (e) {
      if (!_isOffline(e)) {
        rethrow;
      }
      try {
        return (await _local.getTodo(id: id)).toEntity();
      } on CacheMissException {
        throw e; // Report the network problem, not the cache miss.
      }
    }
  });

  @override
  ResultFuture<Todo> createTodo({required CreateTodoParams params}) => guard(
    () => _fetchAndCacheTodo(fetch: () => _remote.createTodo(params: params)),
  );

  @override
  ResultFuture<Todo> updateTodo({required UpdateTodoParams params}) => guard(
    () => _fetchAndCacheTodo(fetch: () => _remote.updateTodo(params: params)),
  );

  @override
  ResultFuture<void> deleteTodo({required String id}) => guard(() async {
    await _remote.deleteTodo(id: id);
    await _cache(() => _local.deleteTodo(id: id));
  });

  static bool _isOffline(AppException e) =>
      e is NetworkException || e is RequestTimeoutException;

  Future<Todo> _fetchAndCacheTodo({
    required Future<TodoModel> Function() fetch,
  }) async {
    final model = await fetch();
    await _cache(() => _local.saveTodo(todo: model));
    return model.toEntity();
  }

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
