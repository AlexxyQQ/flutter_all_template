import 'package:flutter/material.dart';
import 'package:flutter_all_template/core/common/locator/service_locator.dart';
import 'package:flutter_all_template/core/common/presentation/routes/app_router.dart';
import 'package:flutter_all_template/core/generic/domain/entities/page.dart';
import 'package:flutter_all_template/features/example/domain/entities/todo.dart';
import 'package:flutter_all_template/features/example/domain/params/todo_params.dart';
import 'package:flutter_all_template/features/example/domain/usecases/create_todo_use_case.dart';
import 'package:flutter_all_template/features/example/domain/usecases/delete_todo_use_case.dart';
import 'package:flutter_all_template/features/example/domain/usecases/get_todos_use_case.dart';
import 'package:flutter_all_template/features/example/domain/usecases/update_todo_use_case.dart';
import 'package:flutter_all_template/features/example/presentation/bloc/todo_list_bloc.dart';
import 'package:flutter_all_template/features/example/presentation/views/screens/todo_list_screen.dart';
import 'package:flutter_all_template/features/splash/presentation/views/screens/splash_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/test_app.dart';

class MockGetTodos extends Mock implements GetTodosUseCase {}

class MockCreateTodo extends Mock implements CreateTodoUseCase {}

class MockUpdateTodo extends Mock implements UpdateTodoUseCase {}

class MockDeleteTodo extends Mock implements DeleteTodoUseCase {}

Todo _todo(String id, String title) =>
    Todo(id: id, title: title, isDone: false, updatedAt: DateTime(2026));

void main() {
  late MockGetTodos getTodos;
  late MockCreateTodo createTodo;

  setUpAll(() {
    loadTestTranslations();
    registerFallbackValue(const PageRequest.first(limit: 1));
    registerFallbackValue(const TodoQuery());
    registerFallbackValue(const CreateTodoParams(title: ''));
  });

  setUp(() {
    getTodos = MockGetTodos();
    createTodo = MockCreateTodo();
    when(
      () => getTodos(
        page: any(named: 'page'),
        query: any(named: 'query'),
      ),
    ).thenAnswer(
      (_) async =>
          Right(PageResult(items: [_todo('1', 'Buy milk')], hasMore: false)),
    );
    when(
      () => createTodo(params: any(named: 'params')),
    ).thenAnswer((_) async => Right(_todo('2', 'Walk the dog')));
    sl.registerFactory<TodoListBloc>(
      () => TodoListBloc(
        getTodos: getTodos,
        createTodo: createTodo,
        updateTodo: MockUpdateTodo(),
        deleteTodo: MockDeleteTodo(),
      ),
    );
  });

  tearDown(() => sl.reset());

  testWidgets('home -> todos: lists items and adds a new one', (tester) async {
    final router = AppRouter();
    await tester.pumpWidget(routerApp(router.config()));
    await tester.pump(SplashScreen.displayDuration);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('home_open_todos_button')));
    await tester.pumpAndSettle();

    expect(find.byType(TodoListScreen), findsOneWidget);
    expect(find.text('Buy milk'), findsOneWidget);

    await tester.tap(find.byKey(const Key('todo_add_button')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('todo_title_field')),
      'Walk the dog',
    );
    await tester.tap(find.byKey(const Key('todo_save_button')));
    await tester.pumpAndSettle();

    expect(find.text('Walk the dog'), findsOneWidget);
    expect(find.text('Buy milk'), findsOneWidget);
  });
}
