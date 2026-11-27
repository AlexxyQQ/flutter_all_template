import 'dart:convert';

import 'package:flutter_all_template/core/error/app_exception.dart';
import 'package:flutter_all_template/core/generic/domain/entities/page.dart';
import 'package:flutter_all_template/core/session/session_scope.dart';
import 'package:flutter_all_template/features/example/data/data_sources/local/todo_local_data_source.dart';
import 'package:flutter_all_template/features/example/data/data_sources/remote/todo_remote_data_source.dart';
import 'package:flutter_all_template/features/example/data/models/todo_model.dart';
import 'package:flutter_all_template/features/example/domain/params/todo_params.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/in_memory_preferences_store.dart';
import '../fakes.dart';

TodoModel _todo(String id, {String title = 'Title', bool isDone = false}) =>
    TodoModel(
      id: id,
      title: title,
      isDone: isDone,
      updatedAt: DateTime.utc(2026),
    );

void main() {
  group('TodoModel', () {
    test('reads snake_case JSON and maps to the entity', () {
      final model = TodoModel.fromJson(todoJson('1', isDone: true));

      expect(model.isDone, isTrue);
      expect(model.toEntity().updatedAt, DateTime.utc(2026));
      expect(model.toJson(), containsPair('is_done', true));
    });

    test('does not invent an id when it is missing', () {
      final json = todoJson('1')..remove('id');

      expect(() => TodoModel.fromJson(json), throwsA(isA<TypeError>()));
    });
  });

  group('TodoRemoteDataSource', () {
    late FakeApiClient client;
    late TodoRemoteDataSource dataSource;

    setUp(() {
      client = FakeApiClient((_) => todoJson('1'));
      dataSource = TodoRemoteDataSource(client: client);
    });

    test('lists with page, limit, cursor and filters', () async {
      client.respond = (_) => {
        'items': [todoJson('1'), todoJson('2')],
        'has_more': true,
        'next_cursor': 'c3',
      };

      final result = await dataSource.getTodos(
        page: const PageRequest(page: 2, limit: 2, cursor: 'c2'),
        query: const TodoQuery(search: 'milk', onlyOpen: true),
      );

      final call = client.calls.single;
      expect(call.method, 'GET');
      expect(call.path, 'todos');
      expect(call.query, {
        'page': 2,
        'limit': 2,
        'cursor': 'c2',
        'search': 'milk',
        'only_open': true,
      });
      expect(result.items.map((t) => t.id), ['1', '2']);
      expect(result.hasMore, isTrue);
      expect(result.nextCursor, 'c3');
    });

    test('infers hasMore from a full page when the API omits it', () async {
      client.respond = (_) => {
        'items': [todoJson('1')],
      };

      final result = await dataSource.getTodos(
        page: const PageRequest.first(limit: 2),
        query: const TodoQuery(),
      );

      expect(client.calls.single.query, {'page': 1, 'limit': 2});
      expect(result.hasMore, isFalse);
    });

    test('uses the right verb and path for each call', () async {
      await dataSource.createTodo(params: const CreateTodoParams(title: 'New'));
      await dataSource.updateTodo(
        params: const UpdateTodoParams(id: '1', isDone: true),
      );
      client.respond = (_) => null; // 204 No Content
      await dataSource.deleteTodo(id: '1');

      expect(client.calls.map((c) => '${c.method} ${c.path} ${c.body}'), [
        'POST todos {title: New}',
        'PATCH todos/1 {is_done: true}',
        'DELETE todos/1 null',
      ]);
    });

    test('propagates AppExceptions from the client', () {
      client.respond = (_) => throw const NetworkException();

      expect(
        () => dataSource.deleteTodo(id: '1'),
        throwsA(isA<NetworkException>()),
      );
    });
  });

  group('TodoLocalDataSource', () {
    late InMemoryPreferencesStore store;
    late TodoLocalDataSource dataSource;

    const all = TodoQuery();
    const open = TodoQuery(onlyOpen: true);

    PageResult<TodoModel> result(List<TodoModel> items, {bool more = true}) =>
        PageResult(items: items, hasMore: more, nextCursor: 'c');

    Future<void> save(
      TodoQuery query,
      List<TodoModel> items, {
      int limit = 2,
    }) => dataSource.saveFirstPage(
      query: query,
      limit: limit,
      result: result(items),
    );

    Future<PageResult<TodoModel>?> read(TodoQuery query, {int limit = 2}) =>
        dataSource.getFirstPage(query: query, limit: limit);

    setUp(() {
      store = InMemoryPreferencesStore();
      dataSource = TodoLocalDataSource(store: store);
    });

    test('is stored under the session scope so sign-out wipes it', () {
      expect(
        TodoLocalDataSource.storageKey,
        startsWith(SessionScope.keyPrefix),
      );
    });

    test('replays exactly what the server returned for that query', () async {
      await save(all, [_todo('1'), _todo('2')]);

      final hit = await read(all);
      expect(hit!.items.map((t) => t.id), ['1', '2']);
      expect(hit.hasMore, isTrue);
      expect(hit.nextCursor, 'c');
      // Another query / page size is never approximated from this one.
      expect(await read(open), isNull);
      expect(await read(const TodoQuery(search: 'milk')), isNull);
      expect(await read(all, limit: 5), isNull);
    });

    test('keeps only the most recent first page', () async {
      await save(all, [_todo('1')]);
      await save(open, [_todo('2')]);

      expect(await read(all), isNull);
      expect((await read(open))!.items.single.id, '2');
    });

    test('an unreadable entry is discarded and reads as a miss', () async {
      store.values[TodoLocalDataSource.storageKey] = '{not json';

      expect(await read(all), isNull);
      expect(store.values, isNot(contains(TodoLocalDataSource.storageKey)));
    });

    test('an entry of the wrong shape is discarded', () async {
      store.values[TodoLocalDataSource.storageKey] = jsonEncode({
        'search': '',
        'only_open': false,
        'limit': 2,
        'items': [
          {'garbage': true},
        ],
        'has_more': true,
      });

      expect(await read(all), isNull);
      expect(store.values, isNot(contains(TodoLocalDataSource.storageKey)));
    });

    test('clear empties the cache', () async {
      await save(all, [_todo('1')]);
      await dataSource.clear();

      expect(await read(all), isNull);
    });
  });
}
