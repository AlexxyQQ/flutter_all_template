import 'dart:convert';

import 'package:flutter_all_template/core/error/app_exception.dart';
import 'package:flutter_all_template/core/generic/domain/entities/page.dart';
import 'package:flutter_all_template/features/example/data/data_sources/local/todo_local_data_source.dart';
import 'package:flutter_all_template/features/example/data/data_sources/remote/todo_remote_data_source.dart';
import 'package:flutter_all_template/features/example/data/models/todo_model.dart';
import 'package:flutter_all_template/features/example/domain/params/todo_params.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../core/generic/data/in_memory_preferences_store.dart';
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
      expect(TodoModel.fromEntity(model.toEntity()), model);
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
      expect(call.path, '/todos');
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
      await dataSource.getTodo(id: 'a/b');
      await dataSource.createTodo(params: const CreateTodoParams(title: 'New'));
      await dataSource.updateTodo(
        params: const UpdateTodoParams(id: '1', isDone: true),
      );
      client.respond = (_) => null; // 204 No Content
      await dataSource.deleteTodo(id: '1');

      expect(client.calls.map((c) => '${c.method} ${c.path} ${c.body}'), [
        'GET /todos/a%2Fb null',
        'POST /todos {title: New}',
        'PATCH /todos/1 {is_done: true}',
        'DELETE /todos/1 null',
      ]);
    });

    test('propagates AppExceptions from the client', () {
      client.respond = (_) => throw const NetworkException();

      expect(
        () => dataSource.getTodo(id: '1'),
        throwsA(isA<NetworkException>()),
      );
    });
  });

  group('TodoLocalDataSource', () {
    late InMemoryPreferencesStore store;
    late TodoLocalDataSource dataSource;

    const page1 = PageRequest.first(limit: 2);
    const page2 = PageRequest(page: 2, limit: 2);
    const all = TodoQuery();
    const open = TodoQuery(onlyOpen: true);
    const milk = TodoQuery(search: 'milk');

    PageResult<TodoModel> result(List<TodoModel> items, {bool more = true}) =>
        PageResult(items: items, hasMore: more, nextCursor: 'c');

    Future<void> save(
      TodoQuery query,
      List<TodoModel> items, {
      PageRequest page = page1,
    }) => dataSource.savePage(page: page, query: query, result: result(items));

    Future<PageResult<TodoModel>?> read(
      TodoQuery query, {
      PageRequest page = page1,
    }) => dataSource.getPage(page: page, query: query);

    setUp(() {
      store = InMemoryPreferencesStore();
      dataSource = TodoLocalDataSource(store: store);
    });

    test('replays exactly what the server returned for that query', () async {
      await save(all, [_todo('1'), _todo('2')]);

      final hit = await read(all);
      expect(hit!.items.map((t) => t.id), ['1', '2']);
      expect(hit.hasMore, isTrue);
      expect(hit.nextCursor, 'c');
      // Another query / page / size is never approximated from this one.
      expect(await read(open), isNull);
      expect(await read(all, page: page2), isNull);
      expect(await read(all, page: const PageRequest.first(limit: 5)), isNull);
    });

    test('a fresh first page drops the stale later pages', () async {
      await save(all, [_todo('1')]);
      await save(all, [_todo('2')], page: page2);
      await save(open, [_todo('1')]);

      await save(all, [_todo('9')]);

      expect(await read(all, page: page2), isNull);
      expect(await read(open), isNotNull);
      expect((await read(all))!.items.single.id, '9');
    });

    test('is bounded: least recently used pages are evicted', () async {
      const hot = TodoQuery(search: 'q0');
      for (var i = 0; i < TodoLocalDataSource.maxPages + 5; i++) {
        await save(TodoQuery(search: 'q$i'), [_todo('$i')]);
        await read(hot); // Keep q0 recently used.
      }

      expect(await read(hot), isNotNull);
      expect(await read(const TodoQuery(search: 'q1')), isNull);
      final stored = store.getString(TodoLocalDataSource.storageKey)!;
      expect(
        '"search"'.allMatches(stored).length,
        TodoLocalDataSource.maxPages,
      );
    });

    test('oversized pages and searches are not stored unbounded', () async {
      const big = PageRequest.first(limit: 500);
      await save(all, [for (var i = 0; i < 300; i++) _todo('$i')], page: big);
      expect(
        (await read(all, page: big))!.items,
        hasLength(TodoLocalDataSource.maxItemsPerPage),
      );

      final longSearch = TodoQuery(search: 'x' * 200);
      await save(longSearch, [_todo('1')]);
      expect(await read(longSearch), isNull);
    });

    test('getTodo finds an item in any cached page, else misses', () async {
      await save(all, [_todo('1'), _todo('2')]);

      expect((await dataSource.getTodo(id: '2')).id, '2');
      expect(
        () => dataSource.getTodo(id: 'x'),
        throwsA(isA<CacheMissException>()),
      );
    });

    group('mutations', () {
      setUp(() async {
        await save(all, [_todo('1', title: 'Buy milk'), _todo('2')]);
        await save(open, [_todo('1', title: 'Buy milk'), _todo('2')]);
        await save(milk, [_todo('1', title: 'Buy milk')]);
      });

      test('an update replaces in place', () async {
        await dataSource.saveTodo(todo: _todo('2', title: 'Renamed'));

        expect((await read(all))!.items.map((t) => t.title), [
          'Buy milk',
          'Renamed',
        ]);
        expect(await read(milk), isNotNull);
      });

      test('completing an item removes it from "only open" pages', () async {
        await dataSource.saveTodo(
          todo: _todo('1', title: 'Buy milk', isDone: true),
        );

        expect((await read(open))!.items.map((t) => t.id), ['2']);
        expect((await read(all))!.items.first.isDone, isTrue);
      });

      test(
        'an item that newly matches a query invalidates that query',
        () async {
          await dataSource.saveTodo(todo: _todo('2', title: 'milk run'));

          expect(await read(milk), isNull);
          expect(await read(all), isNotNull);
        },
      );

      test('delete removes the id from every page', () async {
        await dataSource.deleteTodo(id: '1');

        for (final q in [all, open, milk]) {
          expect((await read(q))!.items.where((t) => t.id == '1'), isEmpty);
        }
      });
    });

    group('repair', () {
      test('a corrupt value is discarded and the cache works again', () async {
        store.values[TodoLocalDataSource.storageKey] = '{not json';

        expect(await read(open), isNull);
        expect(
          store.values.containsKey(TodoLocalDataSource.storageKey),
          isFalse,
        );

        await save(open, [_todo('1')]);
        expect(await read(open), isNotNull);
      });

      test('a corrupt value never blocks writes', () async {
        store.values[TodoLocalDataSource.storageKey] = '[1, 2]';

        await save(open, [_todo('1')]);

        expect(await read(open), isNotNull);
      });

      test('only the undecodable entry is dropped', () async {
        await save(open, [_todo('1')]);
        await save(all, [_todo('2')]);
        final json =
            jsonDecode(store.getString(TodoLocalDataSource.storageKey)!)
                as Map<String, dynamic>;
        (json['entries'] as List<dynamic>)[0] = {'garbage': true};
        store.values[TodoLocalDataSource.storageKey] = jsonEncode(json);

        expect(await read(open), isNull);
        expect(await read(all), isNotNull);
      });
    });

    test('clear empties the cache', () async {
      await save(open, [_todo('1')]);
      await dataSource.clear();

      expect(await read(open), isNull);
    });
  });
}
