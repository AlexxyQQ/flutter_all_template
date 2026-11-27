import 'package:injectable/injectable.dart';

import '../../../../core/error/typedef.dart';
import '../../../../core/generic/domain/entities/page.dart';
import '../entities/todo.dart';
import '../params/todo_params.dart';
import '../repositories/todo_repository.dart';

/// Loads one page of to-dos matching [query].
@lazySingleton
class GetTodosUseCase {
  const GetTodosUseCase({required ITodoRepository repository})
    : _repository = repository;

  final ITodoRepository _repository;

  ResultFuture<PageResult<Todo>> call({
    required PageRequest page,
    TodoQuery query = const TodoQuery(),
  }) => _repository.getTodos(page: page, query: query);
}
