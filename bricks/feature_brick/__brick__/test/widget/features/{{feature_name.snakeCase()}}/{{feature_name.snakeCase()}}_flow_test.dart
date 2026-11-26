import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:__package__/core/common/domain/entities/failure.dart';
import 'package:__package__/core/common/locator/service_locator.dart';
import 'package:__package__/core/common/presentation/routes/app_router.dart';
import 'package:__package__/core/generic/domain/entities/page.dart';
import 'package:__package__/features/{{feature_name.snakeCase()}}/domain/entities/{{feature_name.snakeCase()}}.dart';
{{#use_params}}import 'package:__package__/features/{{feature_name.snakeCase()}}/domain/params/{{feature_name.snakeCase()}}_params.dart';
{{/use_params}}import 'package:__package__/features/{{feature_name.snakeCase()}}/domain/usecases/create_{{feature_name.snakeCase()}}_use_case.dart';
import 'package:__package__/features/{{feature_name.snakeCase()}}/domain/usecases/delete_{{feature_name.snakeCase()}}_use_case.dart';
import 'package:__package__/features/{{feature_name.snakeCase()}}/domain/usecases/get_{{feature_name.snakeCase()}}s_use_case.dart';
import 'package:__package__/features/{{feature_name.snakeCase()}}/presentation/bloc/{{feature_name.snakeCase()}}_list_bloc.dart';
import 'package:__package__/features/{{feature_name.snakeCase()}}/presentation/routes/{{feature_name.snakeCase()}}_route.dart';
import 'package:__package__/features/{{feature_name.snakeCase()}}/presentation/views/screens/{{feature_name.snakeCase()}}_list_screen.dart';
import 'package:__package__/features/splash/presentation/views/screens/splash_screen.dart';

import '../../helpers/test_app.dart';

class MockGet{{feature_name.pascalCase()}}s extends Mock implements Get{{feature_name.pascalCase()}}sUseCase {}

class MockCreate{{feature_name.pascalCase()}} extends Mock implements Create{{feature_name.pascalCase()}}UseCase {}

class MockDelete{{feature_name.pascalCase()}} extends Mock implements Delete{{feature_name.pascalCase()}}UseCase {}

{{feature_name.pascalCase()}} _item(String id, String title) =>
    {{feature_name.pascalCase()}}(id: id, title: title, updatedAt: DateTime(2026));

void main() {
  late MockGet{{feature_name.pascalCase()}}s get{{feature_name.pascalCase()}}s;
  late MockCreate{{feature_name.pascalCase()}} create{{feature_name.pascalCase()}};
  late MockDelete{{feature_name.pascalCase()}} delete{{feature_name.pascalCase()}};

  /// Opens the page like the app does: past the splash, pushed on top of home.
  Future<AppRouter> pump{{feature_name.pascalCase()}}Route(WidgetTester tester) async {
    final router = AppRouter();
    await tester.pumpWidget(routerApp(router.config()));
    await tester.pump(SplashScreen.displayDuration);
    await tester.pumpAndSettle();

    // `push` completes only when the route is popped: do not await it.
    unawaited(router.push(const {{feature_name.pascalCase()}}Route()));
    await tester.pumpAndSettle();
    return router;
  }

  setUpAll(() {
    loadTestTranslations();
    registerFallbackValue(const PageRequest.first(limit: 1));
    {{#use_params}}registerFallbackValue(const {{feature_name.pascalCase()}}Query());
    registerFallbackValue(const Create{{feature_name.pascalCase()}}Params(title: ''));
    {{/use_params}}{{^use_params}}registerFallbackValue('');
    {{/use_params}}
  });

  setUp(() {
    get{{feature_name.pascalCase()}}s = MockGet{{feature_name.pascalCase()}}s();
    create{{feature_name.pascalCase()}} = MockCreate{{feature_name.pascalCase()}}();
    delete{{feature_name.pascalCase()}} = MockDelete{{feature_name.pascalCase()}}();
    when(
      () => get{{feature_name.pascalCase()}}s(
        page: any(named: 'page'),
        query: any(named: 'query'),
      ),
    ).thenAnswer(
      (_) async =>
          Right(PageResult(items: [_item('1', 'First')], hasMore: false)),
    );
    when(
      () => create{{feature_name.pascalCase()}}({{#use_params}}params: any(named: 'params'){{/use_params}}{{^use_params}}title: any(named: 'title'){{/use_params}}),
    ).thenAnswer((_) async => Right(_item('2', 'Second')));
    when(
      () => delete{{feature_name.pascalCase()}}(id: any(named: 'id')),
    ).thenAnswer((_) async => const Right(null));
    sl.registerFactory<{{feature_name.pascalCase()}}ListBloc>(
      () => {{feature_name.pascalCase()}}ListBloc(
        get{{feature_name.pascalCase()}}s: get{{feature_name.pascalCase()}}s,
        create{{feature_name.pascalCase()}}: create{{feature_name.pascalCase()}},
        delete{{feature_name.pascalCase()}}: delete{{feature_name.pascalCase()}},
      ),
    );
  });

  tearDown(() => sl.reset());

  group('route', () {
    test('{{feature_name.pascalCase()}}Routes.path is registered in AppRouter', () {
      final registered = AppRouter().routes.map((route) => route.path);
      expect({{feature_name.pascalCase()}}Routes.path, '/{{feature_name.paramCase()}}s');
      expect(registered, contains({{feature_name.pascalCase()}}Routes.path));
    });

    testWidgets('can be pushed with {{feature_name.pascalCase()}}Route()', (tester) async {
      final router = await pump{{feature_name.pascalCase()}}Route(tester);

      expect(find.byType({{feature_name.pascalCase()}}ListScreen), findsOneWidget);
      expect(router.topRoute.name, {{feature_name.pascalCase()}}Route.name);
    });

    testWidgets('opens from its deep link path', (tester) async {
      final router = AppRouter();
      await tester.pumpWidget(
        routerApp(
          router.config(
            deepLinkBuilder: (_) => const DeepLink.path({{feature_name.pascalCase()}}Routes.path),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType({{feature_name.pascalCase()}}ListScreen), findsOneWidget);
    });
  });

  group('page + wrapper', () {
    testWidgets('wrapper route provides the bloc and loads the first page', (
      tester,
    ) async {
      await pump{{feature_name.pascalCase()}}Route(tester);

      final context = tester.element(find.byType({{feature_name.pascalCase()}}ListScreen));
      expect(context.read<{{feature_name.pascalCase()}}ListBloc>(), isA<{{feature_name.pascalCase()}}ListBloc>());
      expect(find.byKey(const Key('{{feature_name.snakeCase()}}_list')), findsOneWidget);
      expect(find.text('First'), findsOneWidget);
      verify(
        () => get{{feature_name.pascalCase()}}s(
          page: any(named: 'page'),
          query: any(named: 'query'),
        ),
      ).called(1);
    });

    testWidgets('shows the empty state', (tester) async {
      when(
        () => get{{feature_name.pascalCase()}}s(
          page: any(named: 'page'),
          query: any(named: 'query'),
        ),
      ).thenAnswer(
        (_) async => const Right(PageResult(items: [], hasMore: false)),
      );
      await pump{{feature_name.pascalCase()}}Route(tester);

      expect(find.byKey(const Key('{{feature_name.snakeCase()}}_empty')), findsOneWidget);
    });

    testWidgets('shows the error and retries', (tester) async {
      var calls = 0;
      when(
        () => get{{feature_name.pascalCase()}}s(
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
                PageResult(items: [_item('1', 'First')], hasMore: false),
              );
      });
      await pump{{feature_name.pascalCase()}}Route(tester);
      expect(find.byKey(const Key('{{feature_name.snakeCase()}}_error')), findsOneWidget);

      await tester.tap(find.byKey(const Key('{{feature_name.snakeCase()}}_retry_button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('{{feature_name.snakeCase()}}_error')), findsNothing);
      expect(find.text('First'), findsOneWidget);
    });

    testWidgets('adds an item', (tester) async {
      await pump{{feature_name.pascalCase()}}Route(tester);

      await tester.tap(find.byKey(const Key('{{feature_name.snakeCase()}}_add_button')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('{{feature_name.snakeCase()}}_title_field')),
        'Second',
      );
      await tester.tap(find.byKey(const Key('{{feature_name.snakeCase()}}_save_button')));
      await tester.pumpAndSettle();

      expect(find.text('Second'), findsOneWidget);
      expect(find.text('First'), findsOneWidget);
    });

    testWidgets('deletes an item', (tester) async {
      await pump{{feature_name.pascalCase()}}Route(tester);

      await tester.tap(find.byKey(const Key('{{feature_name.snakeCase()}}_delete_1')));
      await tester.pumpAndSettle();

      expect(find.text('First'), findsNothing);
      verify(() => delete{{feature_name.pascalCase()}}(id: '1')).called(1);
    });
  });
}
