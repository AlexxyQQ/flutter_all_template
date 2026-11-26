import 'package:injectable/injectable.dart';

import '../../../../config/constants/type_defs/typedef.dart';
import '../entities/todo.dart';
import '../params/todo_params.dart';
import '../repositories/todo_repository.dart';

/// Creates a to-do. The only business rule: the title is trimmed.
@lazySingleton
class CreateTodoUseCase {
  const CreateTodoUseCase({required ITodoRepository repository})
    : _repository = repository;

  final ITodoRepository _repository;

  ResultFuture<Todo> call({required CreateTodoParams params}) => _repository
      .createTodo(params: CreateTodoParams(title: params.title.trim()));
}
