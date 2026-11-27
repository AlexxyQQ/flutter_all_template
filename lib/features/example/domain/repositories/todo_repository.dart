import '../../../../core/error/typedef.dart';
import '../../../../core/generic/domain/entities/page.dart';
import '../entities/todo.dart';
import '../params/todo_params.dart';

abstract interface class ITodoRepository {
  /// One page of to-dos matching [query]. A failed *first page* falls back to
  /// the last cached first page of the same query when the network is
  /// unavailable.
  ResultFuture<PageResult<Todo>> getTodos({
    required PageRequest page,
    TodoQuery query = const TodoQuery(),
  });

  ResultFuture<Todo> createTodo({required CreateTodoParams params});

  ResultFuture<Todo> updateTodo({required UpdateTodoParams params});

  ResultFuture<void> deleteTodo({required String id});
}
