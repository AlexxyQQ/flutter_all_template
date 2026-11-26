import 'dart:async';

import 'package:flutter_all_template/core/common/domain/entities/failure.dart';
import 'package:flutter_all_template/core/error/app_exception.dart';
import 'package:flutter_all_template/core/generic/domain/entities/page.dart';
import 'package:flutter_all_template/core/session/session.dart';
import 'package:flutter_all_template/features/example/data/data_sources/local/todo_local_data_source.dart';
import 'package:flutter_all_template/features/example/data/data_sources/remote/todo_remote_data_source.dart';
import 'package:flutter_all_template/features/example/data/models/todo_model.dart';
import 'package:flutter_all_template/features/example/data/repositories/todo_repository_impl.dart';
import 'package:flutter_all_template/features/example/domain/params/todo_params.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../core/generic/data/in_memory_preferences_store.dart';

class MockRemote extends Mock implements ITodoRemoteDataSource {}

class MockLocal extends Mock implements ITodoLocalDataSource {}

class MockSession extends Mock implements SessionManager {}

TodoModel _todo(String id, {bool isDone = false, int day = 1}) => TodoModel(
  id: id,
  title: 'Todo $id',
  isDone: isDone,
  updatedAt: DateTime.utc(2026, 1, day),
);

const _firstPage = PageRequest.first(limit: 2);

void main() {
  late MockRemote remote;
  late MockLocal local;
  late MockSession session;
  late Object? identity;
  late LogoutHook logoutHook;
  late TodoRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(_firstPage);
    registerFallbackValue(const TodoQuery());
    registerFallbackValue(const CreateTodoParams(title: ''));
    registerFallbackValue(const UpdateTodoParams(id: ''));
    registerFallbackValue(
      const PageResult<TodoModel>(items: [], hasMore: false),
    );
    registerFallbackValue(_todo('fallback'));
  });

  setUp(() {
    remote = MockRemote();
    local = MockLocal();
    session = MockSession();
    identity = Object();
    when(() => session.identity).thenAnswer((_) => identity);
    when(() => session.registerLogoutHook(hook: any(named: 'hook'))).thenAnswer(
      (invocation) {
        logoutHook = invocation.namedArguments[#hook] as LogoutHook;
      },
    );
    repository = TodoRepositoryImpl(
      remote: remote,
      local: local,
      session: session,
    );
    when(
      () => local.savePage(
        page: any(named: 'page'),
        query: any(named: 'query'),
        result: any(named: 'result'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => local.saveTodo(todo: any(named: 'todo')),
    ).thenAnswer((_) async {});
    when(() => local.deleteTodo(id: any(named: 'id'))).thenAnswer((_) async {});
    when(() => local.clear()).thenAnswer((_) async {});
  });

  void remoteListThrows(AppException e) => when(
    () => remote.getTodos(
      page: any(named: 'page'),
      query: any(named: 'query'),
    ),
  ).thenThrow(e);

  void cachedPage(PageResult<TodoModel>? page) => when(
    () => local.getPage(
      page: any(named: 'page'),
      query: any(named: 'query'),
    ),
  ).thenAnswer((_) async => page);

  group('getTodos', () {
    test('returns remote items and caches the page for its query', () async {
      final models = [_todo('1'), _todo('2')];
      final remotePage = PageResult(
        items: models,
        hasMore: true,
        nextCursor: 'c',
      );
      when(
        () => remote.getTodos(page: _firstPage, query: const TodoQuery()),
      ).thenAnswer((_) async => remotePage);

      final result = await repository.getTodos(page: _firstPage);

      final page = result.getRight().toNullable()!;
      expect(page.items.map((t) => t.id), ['1', '2']);
      expect(page.nextCursor, 'c');
      verify(
        () => local.savePage(
          page: _firstPage,
          query: const TodoQuery(),
          result: remotePage,
        ),
      ).called(1);
    });

    test('a failing cache write does not fail the call', () async {
      when(
        () => remote.getTodos(
          page: any(named: 'page'),
          query: any(named: 'query'),
        ),
      ).thenAnswer(
        (_) async => PageResult(items: [_todo('1')], hasMore: false),
      );
      when(
        () => local.savePage(
          page: any(named: 'page'),
          query: any(named: 'query'),
          result: any(named: 'result'),
        ),
      ).thenThrow(const StorageException());

      final result = await repository.getTodos(page: _firstPage);

      expect(result.isRight(), isTrue);
    });

    test('offline: serves the cached answer for that query and page', () async {
      remoteListThrows(const NetworkException());
      cachedPage(
        PageResult(
          items: [_todo('new', day: 9), _todo('mid', day: 3)],
          hasMore: true,
          nextCursor: 'c2',
        ),
      );

      final result = await repository.getTodos(
        page: _firstPage,
        query: const TodoQuery(onlyOpen: true),
      );

      final page = result.getRight().toNullable()!;
      expect(page.items.map((t) => t.id), ['new', 'mid']);
      expect(page.hasMore, isTrue);
      expect(page.nextCursor, 'c2');
      verify(
        () => local.getPage(
          page: _firstPage,
          query: const TodoQuery(onlyOpen: true),
        ),
      ).called(1);
    });

    test('offline with nothing cached returns the network failure', () async {
      remoteListThrows(const NetworkException());
      cachedPage(null);

      final result = await repository.getTodos(page: _firstPage);

      expect(result.getLeft().toNullable()?.type, FailureType.network);
    });

    test(
      'offline with an unreadable cache returns the network failure',
      () async {
        remoteListThrows(const NetworkException());
        when(
          () => local.getPage(
            page: any(named: 'page'),
            query: any(named: 'query'),
          ),
        ).thenThrow(const StorageException());

        final result = await repository.getTodos(page: _firstPage);

        expect(result.getLeft().toNullable()?.type, FailureType.network);
      },
    );

    test(
      'server errors are returned as Failure without touching the cache',
      () async {
        remoteListThrows(const ServerException(statusCode: 500));

        final result = await repository.getTodos(page: _firstPage);

        expect(result.getLeft().toNullable()?.type, FailureType.server);
        expect(result.getLeft().toNullable()?.statusCode, 500);
        verifyNever(
          () => local.getPage(
            page: any(named: 'page'),
            query: any(named: 'query'),
          ),
        );
      },
    );

    test('a list response that raced a mutation is not cached', () async {
      final listing = Completer<PageResult<TodoModel>>();
      when(
        () => remote.getTodos(
          page: any(named: 'page'),
          query: any(named: 'query'),
        ),
      ).thenAnswer((_) => listing.future);
      when(() => remote.deleteTodo(id: '1')).thenAnswer((_) async {});

      final list = repository.getTodos(page: _firstPage);
      await Future<void>.delayed(Duration.zero);
      await repository.deleteTodo(id: '1');
      listing.complete(PageResult(items: [_todo('1')], hasMore: false));

      expect((await list).isRight(), isTrue); // Still returned to the caller.
      verifyNever(
        () => local.savePage(
          page: any(named: 'page'),
          query: any(named: 'query'),
          result: any(named: 'result'),
        ),
      );
    });
  });

  group('getTodo', () {
    test('falls back to the cached item when offline', () async {
      when(
        () => remote.getTodo(id: '1'),
      ).thenThrow(const RequestTimeoutException());
      when(() => local.getTodo(id: '1')).thenAnswer((_) async => _todo('1'));

      final result = await repository.getTodo(id: '1');

      expect(result.getRight().toNullable()?.id, '1');
    });

    test('offline and not cached reports the network problem', () async {
      when(() => remote.getTodo(id: '1')).thenThrow(const NetworkException());
      when(() => local.getTodo(id: '1')).thenThrow(const CacheMissException());

      final result = await repository.getTodo(id: '1');

      expect(result.getLeft().toNullable()?.type, FailureType.network);
    });
  });

  group('writes', () {
    test('create calls the API and caches the result', () async {
      const params = CreateTodoParams(title: 'New');
      when(
        () => remote.createTodo(params: params),
      ).thenAnswer((_) async => _todo('9'));

      final result = await repository.createTodo(params: params);

      expect(result.getRight().toNullable()?.id, '9');
      verify(() => local.saveTodo(todo: _todo('9'))).called(1);
    });

    test('update failure is mapped and the cache is untouched', () async {
      const params = UpdateTodoParams(id: '1', isDone: true);
      when(
        () => remote.updateTodo(params: params),
      ).thenThrow(const ValidationException(fieldErrors: {'title': 'x'}));

      final result = await repository.updateTodo(params: params);

      final failure = result.getLeft().toNullable()!;
      expect(failure.type, FailureType.validation);
      expect(failure.fieldErrors, {'title': 'x'});
      verifyNever(() => local.saveTodo(todo: any(named: 'todo')));
    });

    test('delete removes the item remotely, then from the cache', () async {
      when(() => remote.deleteTodo(id: '1')).thenAnswer((_) async {});

      final result = await repository.deleteTodo(id: '1');

      expect(result, const Right<Failure, void>(null));
      verifyInOrder([
        () => remote.deleteTodo(id: '1'),
        () => local.deleteTodo(id: '1'),
      ]);
    });

    test('unexpected errors become an unknown Failure', () async {
      when(() => remote.deleteTodo(id: '1')).thenThrow(StateError('bug'));

      final result = await repository.deleteTodo(id: '1');

      expect(result.getLeft().toNullable(), const Failure.unknown());
    });
  });

  group('account safety', () {
    test('logout wipes the cache', () async {
      await logoutHook();

      verify(() => local.clear()).called(1);
    });

    test('a write that finishes after logout is not cached', () async {
      final creating = Completer<TodoModel>();
      when(
        () => remote.createTodo(params: any(named: 'params')),
      ).thenAnswer((_) => creating.future);

      final create = repository.createTodo(
        params: const CreateTodoParams(title: 'late'),
      );
      await Future<void>.delayed(Duration.zero);
      identity = null; // Signing out...
      await logoutHook();
      creating.complete(_todo('9'));

      expect((await create).isRight(), isTrue);
      verifyNever(() => local.saveTodo(todo: any(named: 'todo')));
    });

    test('a write that finishes after another account signed in is not '
        'cached', () async {
      final updating = Completer<TodoModel>();
      when(
        () => remote.updateTodo(params: any(named: 'params')),
      ).thenAnswer((_) => updating.future);

      final update = repository.updateTodo(
        params: const UpdateTodoParams(id: '1', isDone: true),
      );
      await Future<void>.delayed(Duration.zero);
      identity = Object(); // Another account, no logout hook seen yet.
      updating.complete(_todo('1', isDone: true));

      expect((await update).isRight(), isTrue);
      verifyNever(() => local.saveTodo(todo: any(named: 'todo')));
    });

    test('a list or delete finishing after logout is not cached', () async {
      final listing = Completer<PageResult<TodoModel>>();
      final deleting = Completer<void>();
      when(
        () => remote.getTodos(
          page: any(named: 'page'),
          query: any(named: 'query'),
        ),
      ).thenAnswer((_) => listing.future);
      when(() => remote.deleteTodo(id: '1')).thenAnswer((_) => deleting.future);

      final list = repository.getTodos(page: _firstPage);
      final delete = repository.deleteTodo(id: '1');
      await Future<void>.delayed(Duration.zero);
      await logoutHook();
      listing.complete(PageResult(items: [_todo('1')], hasMore: false));
      deleting.complete();
      await Future.wait([list, delete]);

      verifyNever(
        () => local.savePage(
          page: any(named: 'page'),
          query: any(named: 'query'),
          result: any(named: 'result'),
        ),
      );
      verifyNever(() => local.deleteTodo(id: any(named: 'id')));
    });

    test('an offline read after logout does not serve the old cache', () async {
      final failing = Completer<PageResult<TodoModel>>();
      when(
        () => remote.getTodos(
          page: any(named: 'page'),
          query: any(named: 'query'),
        ),
      ).thenAnswer((_) => failing.future);
      cachedPage(PageResult(items: [_todo('old')], hasMore: false));

      final list = repository.getTodos(page: _firstPage);
      await Future<void>.delayed(Duration.zero);
      await logoutHook();
      failing.completeError(const NetworkException());

      expect((await list).getLeft().toNullable()?.type, FailureType.network);
    });

    test('end to end: a late write never reaches the next account', () async {
      final store = InMemoryPreferencesStore();
      final realLocal = TodoLocalDataSource(store: store);
      final repo = TodoRepositoryImpl(
        remote: remote,
        local: realLocal,
        session: session,
      );
      final creating = Completer<TodoModel>();
      when(
        () => remote.createTodo(params: any(named: 'params')),
      ).thenAnswer((_) => creating.future);

      final create = repo.createTodo(
        params: const CreateTodoParams(title: 'late'),
      );
      await Future<void>.delayed(Duration.zero);
      identity = null;
      await logoutHook(); // Last registered hook belongs to [repo].
      identity = Object(); // Next account signs in.
      creating.complete(_todo('9'));
      await create;

      await expectLater(
        realLocal.getTodo(id: '9'),
        throwsA(isA<CacheMissException>()),
      );
    });
  });
}
