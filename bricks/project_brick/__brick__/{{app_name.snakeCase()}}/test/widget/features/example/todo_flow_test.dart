import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_all_template/core/common/domain/entities/failure.dart';
import 'package:flutter_all_template/core/common/domain/services/analytics/noop_analytics_service.dart';
import 'package:flutter_all_template/core/common/domain/services/navigation/navigation_service.dart';
import 'package:flutter_all_template/core/common/locator/service_locator.dart';
import 'package:flutter_all_template/core/common/presentation/modals/modal_service.dart';
import 'package:flutter_all_template/core/common/presentation/routes/app_router.dart';
import 'package:flutter_all_template/core/generic/domain/entities/page.dart';
import 'package:flutter_all_template/features/example/domain/entities/todo.dart';
import 'package:flutter_all_template/features/example/domain/params/todo_params.dart';
import 'package:flutter_all_template/features/example/domain/usecases/create_todo_use_case.dart';
import 'package:flutter_all_template/features/example/domain/usecases/delete_todo_use_case.dart';
import 'package:flutter_all_template/features/example/domain/usecases/get_todos_use_case.dart';
import 'package:flutter_all_template/features/example/domain/usecases/update_todo_use_case.dart';
import 'package:flutter_all_template/features/example/presentation/bloc/todo_list_bloc.dart';
import 'package:flutter_all_template/features/example/presentation/routes/todo_route.dart';
import 'package:flutter_all_template/features/example/presentation/views/screens/todo_list_screen.dart';
import 'package:flutter_all_template/features/splash/presentation/views/screens/splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/test_app.dart';

class MockGetTodos extends Mock implements GetTodosUseCase {}

class MockCreateTodo extends Mock implements CreateTodoUseCase {}

class MockUpdateTodo extends Mock implements UpdateTodoUseCase {}

class MockDeleteTodo extends Mock implements DeleteTodoUseCase {}

class MockNavigation extends Mock implements NavigationService {}

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
    sl
      ..registerFactory<ModalService>(
        () => ModalService(navigation: MockNavigation()),
      )
      ..registerFactory<TodoListBloc>(
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

    final navigation = NavigationService(appRouter: router);
    expect(navigation.checkIfAlreadyOpened(name: TodoRoute.name), isTrue);
    expect(navigation.canPop(), isTrue);
    await tester.tap(find.byType(AutoLeadingButton));
    await tester.pumpAndSettle();
    expect(navigation.current.name, HomeRoute.name);
    expect(navigation.canPop(), isFalse);
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

  group('route', () {
    test('TodoRoutes.path is registered in AppRouter', () {
      final registered = AppRouter().routes.map((route) => route.path);
      expect(TodoRoutes.path, '/todos');
      expect(registered, contains(TodoRoutes.path));
    });

    testWidgets('can be pushed with TodoRoute()', (tester) async {
      final router = AppRouter();
      await tester.pumpWidget(routerApp(router.config()));
      await tester.pump(SplashScreen.displayDuration);
      await tester.pumpAndSettle();

      // `push` completes only when the route is popped: do not await it.
      unawaited(router.push(const TodoRoute()));
      await tester.pumpAndSettle();

      expect(find.byType(TodoListScreen), findsOneWidget);
      expect(router.topRoute.name, TodoRoute.name);

      final navigation = NavigationService(appRouter: router);
      await tester.tap(find.byKey(const Key('todo_add_button')));
      await tester.pumpAndSettle();

      expect(
        await navigation.closeSpecificRoute(name: TodoWrapperRoute.name),
        isFalse,
      );
      navigation.popForced();
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('todo_title_field')), findsNothing);
      expect(navigation.current.name, TodoRoute.name);
      expect(await navigation.closeSpecificRoute(name: TodoRoute.name), isTrue);
      await tester.pumpAndSettle();
      expect(navigation.current.name, HomeRoute.name);
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
                Failure(message: 'error.key', type: FailureType.network),
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
