import 'package:flutter_all_template/core/generic/domain/entities/page.dart';
import 'package:flutter_all_template/features/example/domain/entities/todo.dart';
import 'package:flutter_all_template/features/example/domain/params/todo_params.dart';
import 'package:flutter_all_template/features/example/domain/repositories/todo_repository.dart';
import 'package:flutter_all_template/features/example/domain/usecases/create_todo_use_case.dart';
import 'package:flutter_all_template/features/example/domain/usecases/delete_todo_use_case.dart';
import 'package:flutter_all_template/features/example/domain/usecases/get_todo_use_case.dart';
import 'package:flutter_all_template/features/example/domain/usecases/get_todos_use_case.dart';
import 'package:flutter_all_template/features/example/domain/usecases/update_todo_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements ITodoRepository {}

void main() {
  late _MockRepository repository;
  final todo = Todo(
    id: '1',
    title: 'Milk',
    isDone: false,
    updatedAt: DateTime(2026),
  );

  setUpAll(() {
    registerFallbackValue(const PageRequest.first(limit: 1));
    registerFallbackValue(const TodoQuery());
    registerFallbackValue(const CreateTodoParams(title: ''));
    registerFallbackValue(const UpdateTodoParams(id: ''));
  });

  setUp(() => repository = _MockRepository());

  test('GetTodosUseCase forwards page and query', () async {
    const page = PageRequest.first(limit: 5);
    const query = TodoQuery(search: 'm');
    final result = PageResult(items: [todo], hasMore: false);
    when(
      () => repository.getTodos(page: page, query: query),
    ).thenAnswer((_) async => Right(result));

    final got = await GetTodosUseCase(repository: repository)(
      page: page,
      query: query,
    );

    expect(got.toNullable(), result);
  });

  test('GetTodoUseCase forwards the id', () async {
    when(
      () => repository.getTodo(id: '1'),
    ).thenAnswer((_) async => Right(todo));

    final got = await GetTodoUseCase(repository: repository)(id: '1');

    expect(got.toNullable(), todo);
  });

  test('CreateTodoUseCase trims the title', () async {
    when(
      () => repository.createTodo(params: any(named: 'params')),
    ).thenAnswer((_) async => Right(todo));

    await CreateTodoUseCase(repository: repository)(
      params: const CreateTodoParams(title: '  Milk \n'),
    );

    verify(
      () =>
          repository.createTodo(params: const CreateTodoParams(title: 'Milk')),
    ).called(1);
  });

  test('UpdateTodoUseCase forwards params unchanged', () async {
    const params = UpdateTodoParams(id: '1', isDone: true);
    when(
      () => repository.updateTodo(params: params),
    ).thenAnswer((_) async => Right(todo));

    await UpdateTodoUseCase(repository: repository)(params: params);

    verify(() => repository.updateTodo(params: params)).called(1);
  });

  test('DeleteTodoUseCase forwards the id', () async {
    when(
      () => repository.deleteTodo(id: '1'),
    ).thenAnswer((_) async => const Right(null));

    await DeleteTodoUseCase(repository: repository)(id: '1');

    verify(() => repository.deleteTodo(id: '1')).called(1);
  });
}
