import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_all_template/core/common/domain/entities/failure.dart';
import 'package:flutter_all_template/core/generic/presentation/bloc/paged_list_bloc.dart';
import 'package:flutter_all_template/features/example/domain/entities/todo.dart';
import 'package:flutter_all_template/features/example/domain/params/todo_params.dart';
import 'package:flutter_all_template/features/example/domain/usecases/create_todo_use_case.dart';
import 'package:flutter_all_template/features/example/domain/usecases/delete_todo_use_case.dart';
import 'package:flutter_all_template/features/example/domain/usecases/get_todos_use_case.dart';
import 'package:flutter_all_template/features/example/domain/usecases/update_todo_use_case.dart';
import 'package:flutter_all_template/features/example/presentation/bloc/todo_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockGetTodos extends Mock implements GetTodosUseCase {}

class MockCreateTodo extends Mock implements CreateTodoUseCase {}

class MockUpdateTodo extends Mock implements UpdateTodoUseCase {}

class MockDeleteTodo extends Mock implements DeleteTodoUseCase {}

Todo _todo(String id, {bool isDone = false}) =>
    Todo(id: id, title: 'Todo $id', isDone: isDone, updatedAt: DateTime(2026));

const _failure = Failure(message: 'error.key', type: FailureType.network);

void main() {
  late MockGetTodos getTodos;
  late MockCreateTodo createTodo;
  late MockUpdateTodo updateTodo;
  late MockDeleteTodo deleteTodo;

  setUpAll(() {
    registerFallbackValue(const PageRequest.first(limit: 1));
    registerFallbackValue(const TodoQuery());
    registerFallbackValue(const CreateTodoParams(title: ''));
    registerFallbackValue(const UpdateTodoParams(id: ''));
  });

  setUp(() {
    getTodos = MockGetTodos();
    createTodo = MockCreateTodo();
    updateTodo = MockUpdateTodo();
    deleteTodo = MockDeleteTodo();
    when(
      () => getTodos(
        page: any(named: 'page'),
        query: any(named: 'query'),
      ),
    ).thenAnswer(
      (_) async =>
          Right(PageResult(items: [_todo('1'), _todo('2')], hasMore: true)),
    );
  });

  TodoListBloc build() => TodoListBloc(
    getTodos: getTodos,
    createTodo: createTodo,
    updateTodo: updateTodo,
    deleteTodo: deleteTodo,
    queryDebounce: Duration.zero,
  );

  TodoListState loaded(List<Todo> items) => TodoListState(
    query: const TodoQuery(),
    items: items,
    status: PagedStatus.idle,
    nextPage: const PageRequest(page: 2, limit: 20),
    hasLoaded: true,
  );

  blocTest<TodoListBloc, TodoListState>(
    'loads the first page through the use case',
    build: build,
    act: (bloc) => bloc.add(const PagedListStarted()),
    verify: (bloc) {
      expect(bloc.state.items.map((t) => t.id), ['1', '2']);
      verify(
        () => getTodos(page: const PageRequest.first(limit: 20)),
      ).called(1);
    },
  );

  blocTest<TodoListBloc, TodoListState>(
    'query changes reach the use case',
    build: build,
    act: (bloc) =>
        bloc.add(const PagedListQueryChanged(TodoQuery(search: 'milk'))),
    wait: const Duration(milliseconds: 10),
    verify: (bloc) {
      expect(bloc.state.query, const TodoQuery(search: 'milk'));
      verify(
        () => getTodos(
          page: any(named: 'page'),
          query: const TodoQuery(search: 'milk'),
        ),
      ).called(1);
    },
  );

  blocTest<TodoListBloc, TodoListState>(
    'toggle is optimistic and keeps the server version',
    setUp: () => when(
      () => updateTodo(params: any(named: 'params')),
    ).thenAnswer((_) async => Right(_todo('1', isDone: true))),
    build: build,
    seed: () => loaded([_todo('1'), _todo('2')]),
    act: (bloc) => bloc.add(TodoToggled(_todo('1'))),
    expect: () => [
      loaded([_todo('1', isDone: true), _todo('2')]),
    ],
    verify: (_) => verify(
      () => updateTodo(params: const UpdateTodoParams(id: '1', isDone: true)),
    ).called(1),
  );

  blocTest<TodoListBloc, TodoListState>(
    'a failed toggle is rolled back and reported',
    setUp: () => when(
      () => updateTodo(params: any(named: 'params')),
    ).thenAnswer((_) async => const Left(_failure)),
    build: build,
    seed: () => loaded([_todo('1')]),
    act: (bloc) => bloc.add(TodoToggled(_todo('1'))),
    expect: () => [
      loaded([_todo('1', isDone: true)]),
      loaded([_todo('1')]).copyWith(failure: () => _failure),
    ],
  );

  blocTest<TodoListBloc, TodoListState>(
    'create prepends the new item',
    setUp: () => when(
      () => createTodo(params: const CreateTodoParams(title: '  New ')),
    ).thenAnswer((_) async => Right(_todo('3'))),
    build: build,
    seed: () => loaded([_todo('1')]),
    act: (bloc) => bloc.add(const TodoCreated('  New ')),
    expect: () => [
      loaded([_todo('3'), _todo('1')]),
    ],
  );

  blocTest<TodoListBloc, TodoListState>(
    'delete removes only the matching item',
    setUp: () => when(
      () => deleteTodo(id: '2'),
    ).thenAnswer((_) async => const Right(null)),
    build: build,
    seed: () => loaded([_todo('1'), _todo('2'), _todo('3')]),
    act: (bloc) => bloc.add(const TodoDeleted('2')),
    expect: () => [
      loaded([_todo('1'), _todo('3')]),
    ],
  );

  blocTest<TodoListBloc, TodoListState>(
    'a failed delete keeps the item and reports the failure',
    setUp: () => when(
      () => deleteTodo(id: '1'),
    ).thenAnswer((_) async => const Left(_failure)),
    build: build,
    seed: () => loaded([_todo('1')]),
    act: (bloc) => bloc.add(const TodoDeleted('1')),
    expect: () => [
      loaded([_todo('1')]).copyWith(failure: () => _failure),
    ],
  );
}
