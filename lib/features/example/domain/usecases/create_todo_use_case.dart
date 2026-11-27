import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/typedef.dart';
import '../entities/todo.dart';
import '../params/todo_params.dart';
import '../repositories/todo_repository.dart';

/// Creates a to-do. Business rules: the title is trimmed and must not be
/// empty (an empty one is a validation failure; nothing is sent).
@lazySingleton
class CreateTodoUseCase {
  const CreateTodoUseCase({required ITodoRepository repository})
    : _repository = repository;

  /// Localization key of the "title is required" message. The domain cannot
  /// import the generated `LocaleKeys`; a unit test keeps this equal to
  /// `LocaleKeys.features_example_errors_emptyTitle`.
  static const String emptyTitleMessageKey =
      'features.example.errors.emptyTitle';

  final ITodoRepository _repository;

  ResultFuture<Todo> call({required CreateTodoParams params}) async {
    final title = params.title.trim();
    if (title.isEmpty) {
      return left(const Failure.validation(messageKey: emptyTitleMessageKey));
    }
    return _repository.createTodo(params: CreateTodoParams(title: title));
  }
}
