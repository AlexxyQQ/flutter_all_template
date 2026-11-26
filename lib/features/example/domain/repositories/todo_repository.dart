import '../../../../config/constants/type_defs/typedef.dart';
import '../../../../core/generic/domain/entities/page.dart';
import '../entities/todo.dart';
import '../params/todo_params.dart';

abstract interface class ITodoRepository {
  /// One page of to-dos matching [query]. Falls back to the offline cache
  /// when the network is unavailable.
  ResultFuture<PageResult<Todo>> getTodos({
    required PageRequest page,
    TodoQuery query = const TodoQuery(),
  });

  ResultFuture<Todo> getTodo(String id);

  ResultFuture<Todo> createTodo(CreateTodoParams params);

  ResultFuture<Todo> updateTodo(UpdateTodoParams params);

  ResultFuture<void> deleteTodo(String id);
}
