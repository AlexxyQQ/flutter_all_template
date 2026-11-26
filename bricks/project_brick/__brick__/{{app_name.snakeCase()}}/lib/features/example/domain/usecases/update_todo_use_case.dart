import 'package:injectable/injectable.dart';

import '../../../../config/constants/type_defs/typedef.dart';
import '../entities/todo.dart';
import '../params/todo_params.dart';
import '../repositories/todo_repository.dart';

/// Applies a partial update to a to-do.
@lazySingleton
class UpdateTodoUseCase {
  const UpdateTodoUseCase({required ITodoRepository repository})
    : _repository = repository;

  final ITodoRepository _repository;

  ResultFuture<Todo> call({required UpdateTodoParams params}) =>
      _repository.updateTodo(params: params);
}
