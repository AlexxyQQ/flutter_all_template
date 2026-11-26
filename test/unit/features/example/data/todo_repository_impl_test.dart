import 'package:flutter_all_template/core/common/domain/entities/failure.dart';
import 'package:flutter_all_template/core/error/app_exception.dart';
import 'package:flutter_all_template/core/generic/domain/entities/page.dart';
import 'package:flutter_all_template/features/example/data/data_sources/local/todo_local_data_source.dart';
import 'package:flutter_all_template/features/example/data/data_sources/remote/todo_remote_data_source.dart';
import 'package:flutter_all_template/features/example/data/models/todo_model.dart';
import 'package:flutter_all_template/features/example/data/repositories/todo_repository_impl.dart';
import 'package:flutter_all_template/features/example/domain/params/todo_params.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockRemote extends Mock implements ITodoRemoteDataSource {}

class MockLocal extends Mock implements ITodoLocalDataSource {}

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
  late TodoRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(_firstPage);
    registerFallbackValue(const TodoQuery());
    registerFallbackValue(<TodoModel>[]);
    registerFallbackValue(_todo('fallback'));
  });

  setUp(() {
    remote = MockRemote();
    local = MockLocal();
    repository = TodoRepositoryImpl(remote: remote, local: local);
    when(
      () => local.saveTodos(todos: any(named: 'todos')),
    ).thenAnswer((_) async {});
    when(
      () => local.saveTodo(todo: any(named: 'todo')),
    ).thenAnswer((_) async {});
    when(() => local.deleteTodo(id: any(named: 'id'))).thenAnswer((_) async {});
  });

  void remoteListThrows(AppException e) => when(
    () => remote.getTodos(
      page: any(named: 'page'),
      query: any(named: 'query'),
    ),
  ).thenThrow(e);

  group('getTodos', () {
    test('returns remote items and caches them', () async {
      final models = [_todo('1'), _todo('2')];
      when(
        () => remote.getTodos(page: _firstPage, query: const TodoQuery()),
      ).thenAnswer(
        (_) async => PageResult(items: models, hasMore: true, nextCursor: 'c'),
      );

      final result = await repository.getTodos(page: _firstPage);

      final page = result.getRight().toNullable()!;
      expect(page.items.map((t) => t.id), ['1', '2']);
      expect(page.nextCursor, 'c');
      verify(() => local.saveTodos(todos: models)).called(1);
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
        () => local.saveTodos(todos: any(named: 'todos')),
      ).thenThrow(const StorageException());

      final result = await repository.getTodos(page: _firstPage);

      expect(result.isRight(), isTrue);
    });

    test(
      'offline: serves filtered, paged, newest-first cached items',
      () async {
        remoteListThrows(const NetworkException());
        when(() => local.getTodos()).thenAnswer(
          (_) async => [
            _todo('old'),
            _todo('done', isDone: true, day: 5),
            _todo('new', day: 9),
            _todo('mid', day: 3),
          ],
        );

        final first = await repository.getTodos(
          page: _firstPage,
          query: const TodoQuery(onlyOpen: true),
        );
        final second = await repository.getTodos(
          page: const PageRequest(page: 2, limit: 2),
          query: const TodoQuery(onlyOpen: true),
        );

        final p1 = first.getRight().toNullable()!;
        final p2 = second.getRight().toNullable()!;
        expect(p1.items.map((t) => t.id), ['new', 'mid']);
        expect(p1.hasMore, isTrue);
        expect(p2.items.map((t) => t.id), ['old']);
        expect(p2.hasMore, isFalse);
      },
    );

    test('offline with an empty cache returns the network failure', () async {
      remoteListThrows(const NetworkException());
      when(() => local.getTodos()).thenAnswer((_) async => []);

      final result = await repository.getTodos(page: _firstPage);

      expect(result.getLeft().toNullable()?.type, FailureType.network);
    });

    test(
      'server errors are returned as Failure without touching the cache',
      () async {
        remoteListThrows(const ServerException(statusCode: 500));

        final result = await repository.getTodos(page: _firstPage);

        expect(result.getLeft().toNullable()?.type, FailureType.server);
        expect(result.getLeft().toNullable()?.statusCode, 500);
        verifyNever(() => local.getTodos());
      },
    );
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
}
