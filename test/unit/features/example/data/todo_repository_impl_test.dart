import 'package:flutter_all_template/core/error/app_exception.dart';
import 'package:flutter_all_template/core/error/failure.dart';
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
const _secondPage = PageRequest(page: 2, limit: 2, cursor: 'c');

void main() {
  late MockRemote remote;
  late MockLocal local;
  late TodoRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(_firstPage);
    registerFallbackValue(const TodoQuery());
    registerFallbackValue(const CreateTodoParams(title: ''));
    registerFallbackValue(const UpdateTodoParams(id: ''));
    registerFallbackValue(
      const PageResult<TodoModel>(items: [], hasMore: false),
    );
  });

  setUp(() {
    remote = MockRemote();
    local = MockLocal();
    repository = TodoRepositoryImpl(remote: remote, local: local);
    when(
      () => local.saveFirstPage(
        query: any(named: 'query'),
        limit: any(named: 'limit'),
        result: any(named: 'result'),
      ),
    ).thenAnswer((_) async {});
    when(() => local.clear()).thenAnswer((_) async {});
  });

  void remoteListThrows(AppException e) => when(
    () => remote.getTodos(
      page: any(named: 'page'),
      query: any(named: 'query'),
    ),
  ).thenThrow(e);

  void cachedPage(PageResult<TodoModel>? page) => when(
    () => local.getFirstPage(
      query: any(named: 'query'),
      limit: any(named: 'limit'),
    ),
  ).thenAnswer((_) async => page);

  group('getTodos', () {
    test('returns remote items and caches the first page', () async {
      final remotePage = PageResult(
        items: [_todo('1'), _todo('2')],
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
        () => local.saveFirstPage(
          query: const TodoQuery(),
          limit: 2,
          result: remotePage,
        ),
      ).called(1);
    });

    test('later pages are not cached', () async {
      when(
        () => remote.getTodos(page: _secondPage, query: const TodoQuery()),
      ).thenAnswer(
        (_) async => PageResult(items: [_todo('3')], hasMore: false),
      );

      final result = await repository.getTodos(page: _secondPage);

      expect(result.isRight(), isTrue);
      verifyNever(
        () => local.saveFirstPage(
          query: any(named: 'query'),
          limit: any(named: 'limit'),
          result: any(named: 'result'),
        ),
      );
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
        () => local.saveFirstPage(
          query: any(named: 'query'),
          limit: any(named: 'limit'),
          result: any(named: 'result'),
        ),
      ).thenThrow(const StorageException());

      final result = await repository.getTodos(page: _firstPage);

      expect(result.isRight(), isTrue);
    });

    test('offline: serves the cached first page of that query', () async {
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
        () => local.getFirstPage(
          query: const TodoQuery(onlyOpen: true),
          limit: 2,
        ),
      ).called(1);
    });

    test('offline timeouts also fall back to the cache', () async {
      remoteListThrows(const RequestTimeoutException());
      cachedPage(PageResult(items: [_todo('1')], hasMore: false));

      final result = await repository.getTodos(page: _firstPage);

      expect(result.getRight().toNullable()?.items.single.id, '1');
    });

    test('offline on a later page reports the network failure', () async {
      remoteListThrows(const NetworkException());

      final result = await repository.getTodos(page: _secondPage);

      expect(result.getLeft().toNullable()?.type, FailureType.network);
      verifyNever(
        () => local.getFirstPage(
          query: any(named: 'query'),
          limit: any(named: 'limit'),
        ),
      );
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
          () => local.getFirstPage(
            query: any(named: 'query'),
            limit: any(named: 'limit'),
          ),
        ).thenThrow(const StorageException());

        final result = await repository.getTodos(page: _firstPage);

        expect(result.getLeft().toNullable()?.type, FailureType.network);
      },
    );

    test('server errors are returned as Failure without the cache', () async {
      remoteListThrows(const ServerException(statusCode: 500));

      final result = await repository.getTodos(page: _firstPage);

      expect(result.getLeft().toNullable()?.type, FailureType.server);
      expect(result.getLeft().toNullable()?.statusCode, 500);
      verifyNever(
        () => local.getFirstPage(
          query: any(named: 'query'),
          limit: any(named: 'limit'),
        ),
      );
    });
  });

  group('writes', () {
    test('create calls the API and drops the cached page', () async {
      const params = CreateTodoParams(title: 'New');
      when(
        () => remote.createTodo(params: params),
      ).thenAnswer((_) async => _todo('9'));

      final result = await repository.createTodo(params: params);

      expect(result.getRight().toNullable()?.id, '9');
      verify(() => local.clear()).called(1);
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
      verifyNever(() => local.clear());
    });

    test('delete removes the item remotely, then drops the cache', () async {
      when(() => remote.deleteTodo(id: '1')).thenAnswer((_) async {});

      final result = await repository.deleteTodo(id: '1');

      expect(result, const Right<Failure, void>(null));
      verifyInOrder([() => remote.deleteTodo(id: '1'), () => local.clear()]);
    });

    test('a failing cache invalidation does not fail the write', () async {
      when(() => remote.deleteTodo(id: '1')).thenAnswer((_) async {});
      when(() => local.clear()).thenThrow(const StorageException());

      final result = await repository.deleteTodo(id: '1');

      expect(result.isRight(), isTrue);
    });

    test('unexpected errors become an unknown Failure', () async {
      when(() => remote.deleteTodo(id: '1')).thenThrow(StateError('bug'));

      final result = await repository.deleteTodo(id: '1');

      expect(result.getLeft().toNullable(), const Failure.unknown());
    });
  });
}
