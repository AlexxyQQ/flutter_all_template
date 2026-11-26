import 'package:injectable/injectable.dart';

import '../../../../config/constants/type_defs/typedef.dart';
import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

/// Loads a single to-do by id.
@lazySingleton
class GetTodoUseCase {
  const GetTodoUseCase({required ITodoRepository repository})
    : _repository = repository;

  final ITodoRepository _repository;

  ResultFuture<Todo> call({required String id}) => _repository.getTodo(id: id);
}
