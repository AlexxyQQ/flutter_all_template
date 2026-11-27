import 'package:injectable/injectable.dart';

import '../../../../core/error/typedef.dart';
import '../repositories/todo_repository.dart';

/// Deletes a to-do by id.
@lazySingleton
class DeleteTodoUseCase {
  const DeleteTodoUseCase({required ITodoRepository repository})
    : _repository = repository;

  final ITodoRepository _repository;

  ResultFuture<void> call({required String id}) =>
      _repository.deleteTodo(id: id);
}
