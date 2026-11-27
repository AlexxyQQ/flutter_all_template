import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_all_template/app/di/service_locator.dart';
import 'package:flutter_all_template/app/router/app_router.dart';
import 'package:flutter_all_template/core/error/failure.dart';
import 'package:flutter_all_template/core/generic/domain/entities/page.dart';
import 'package:flutter_all_template/features/example/domain/entities/todo.dart';
import 'package:flutter_all_template/features/example/domain/params/todo_params.dart';
import 'package:flutter_all_template/features/example/domain/usecases/create_todo_use_case.dart';
import 'package:flutter_all_template/features/example/domain/usecases/delete_todo_use_case.dart';
import 'package:flutter_all_template/features/example/domain/usecases/get_todos_use_case.dart';
import 'package:flutter_all_template/features/example/domain/usecases/update_todo_use_case.dart';
import 'package:flutter_all_template/features/example/presentation/bloc/todo_list_bloc.dart';
import 'package:flutter_all_template/features/example/presentation/routes/todo_routes.dart';
import 'package:flutter_all_template/features/example/presentation/views/screens/todo_list_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/noop_analytics_service.dart';
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

  /// Pumps the registered route straight away (skips splash and home).
  Future<AppRouter> pumpTodoRoute(WidgetTester tester) async {
    final router = AppRouter();
    await tester.pumpWidget(
      routerApp(
        router.config(
          deepLinkBuilder: (_) => const DeepLink.path(TodoRoutes.path),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return router;
  }

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
        analytics: const NoopAnalyticsService(),
      ),
    );
  });

  tearDown(() => sl.reset());

  testWidgets('home -> todos: lists items and adds a new one', (tester) async {
    final router = AppRouter();
    await tester.pumpWidget(routerApp(router.config()));
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

    expect(router.topRoute.name, TodoListRoute.name);
    expect(router.canPop(), isTrue);
    await tester.tap(find.byType(AutoLeadingButton));
    await tester.pumpAndSettle();
    expect(router.topRoute.name, HomeRoute.name);
    expect(router.canPop(), isFalse);
  });

  testWidgets('cancelling the add popup creates nothing', (tester) async {
    await pumpTodoRoute(tester);

    await tester.tap(find.byKey(const Key('todo_add_button')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('todo_title_field')), findsOneWidget);

    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('todo_title_field')), findsNothing);
    verifyNever(() => createTodo(params: any(named: 'params')));
  });

  testWidgets('a blank title shows the use case validation message', (
    tester,
  ) async {
    when(() => createTodo(params: any(named: 'params'))).thenAnswer(
      (_) async => const Left(
        Failure.validation(messageKey: CreateTodoUseCase.emptyTitleMessageKey),
      ),
    );
    await pumpTodoRoute(tester);

    await tester.tap(find.byKey(const Key('todo_add_button')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('todo_title_field')), '   ');
    await tester.tap(find.byKey(const Key('todo_save_button')));
    await tester.pumpAndSettle();

    expect(find.text('Enter a title for the to-do.'), findsOneWidget);
    expect(find.text('Buy milk'), findsOneWidget);
  });

  testWidgets('pull to refresh waits for the reload to finish', (tester) async {
    await pumpTodoRoute(tester);
    final reload = Completer<Either<Failure, PageResult<Todo>>>();
    when(
      () => getTodos(
        page: any(named: 'page'),
        query: any(named: 'query'),
      ),
    ).thenAnswer((_) => reload.future);

    await tester.fling(
      find.byKey(const Key('todo_list')),
      const Offset(0, 300),
      1000,
    );
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(RefreshProgressIndicator), findsOneWidget);

    reload.complete(
      Right(PageResult(items: [_todo('1', 'Buy milk')], hasMore: false)),
    );
    await tester.pumpAndSettle();
    expect(find.byType(RefreshProgressIndicator), findsNothing);
  });

  group('route', () {
    test('TodoRoutes.path is registered in AppRouter', () {
      final registered = AppRouter().routes.map((route) => route.path);
      expect(TodoRoutes.path, '/todos');
      expect(registered, contains(TodoRoutes.path));
    });

    testWidgets('can be pushed with TodoListRoute()', (tester) async {
      final router = AppRouter();
      await tester.pumpWidget(routerApp(router.config()));
      await tester.pumpAndSettle();

      // `push` completes only when the route is popped: do not await it.
      unawaited(router.push(const TodoListRoute()));
      await tester.pumpAndSettle();

      expect(find.byType(TodoListScreen), findsOneWidget);
      expect(router.topRoute.name, TodoListRoute.name);
    });
  });

  group('page + wrapper', () {
    testWidgets('wrapper route provides the bloc and loads the first page', (
      tester,
    ) async {
      await pumpTodoRoute(tester);

      final context = tester.element(find.byType(TodoListScreen));
      expect(context.read<TodoListBloc>(), isA<TodoListBloc>());
      expect(find.byKey(const Key('todo_list')), findsOneWidget);
      expect(find.text('Buy milk'), findsOneWidget);
      verify(
        () => getTodos(
          page: any(named: 'page'),
          query: any(named: 'query'),
        ),
      ).called(1);
    });

    testWidgets('shows the empty state', (tester) async {
      when(
        () => getTodos(
          page: any(named: 'page'),
          query: any(named: 'query'),
        ),
      ).thenAnswer(
        (_) async => const Right(PageResult(items: [], hasMore: false)),
      );
      await pumpTodoRoute(tester);

      expect(find.byKey(const Key('todo_empty')), findsOneWidget);
    });

    testWidgets('shows the error and retries', (tester) async {
      var calls = 0;
      when(
        () => getTodos(
          page: any(named: 'page'),
          query: any(named: 'query'),
        ),
      ).thenAnswer((_) async {
        calls++;
        return calls == 1
            ? const Left(
                Failure(messageKey: 'error.key', type: FailureType.network),
              )
            : Right(
                PageResult(items: [_todo('1', 'Buy milk')], hasMore: false),
              );
      });
      await pumpTodoRoute(tester);
      expect(find.byKey(const Key('todo_error')), findsOneWidget);

      await tester.tap(find.byKey(const Key('todo_retry_button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('todo_error')), findsNothing);
      expect(find.text('Buy milk'), findsOneWidget);
    });
  });
}
