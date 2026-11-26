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
      dataSource = TodoRemoteDataSource(client);
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
      await dataSource.getTodo('a/b');
      await dataSource.createTodo(const CreateTodoParams(title: 'New'));
      await dataSource.updateTodo(
        const UpdateTodoParams(id: '1', isDone: true),
      );
      client.respond = (_) => null; // 204 No Content
      await dataSource.deleteTodo('1');

      expect(client.calls.map((c) => '${c.method} ${c.path} ${c.body}'), [
        'GET /todos/a%2Fb null',
        'POST /todos {title: New}',
        'PATCH /todos/1 {is_done: true}',
        'DELETE /todos/1 null',
      ]);
    });

    test('propagates AppExceptions from the client', () {
      client.respond = (_) => throw const NetworkException();

      expect(() => dataSource.getTodo('1'), throwsA(isA<NetworkException>()));
    });
  });

  group('TodoLocalDataSource', () {
    late TodoLocalDataSource dataSource;

    setUp(() => dataSource = TodoLocalDataSource(InMemoryPreferencesStore()));

    test('get/update/delete target only the requested id', () async {
      await dataSource.saveTodos([_todo('1'), _todo('2'), _todo('3')]);

      expect((await dataSource.getTodo('2')).id, '2');

      await dataSource.saveTodo(_todo('2', title: 'Updated'));
      await dataSource.deleteTodo('3');

      final todos = await dataSource.getTodos();
      expect(todos.map((t) => (t.id, t.title)), [
        ('1', 'Title'),
        ('2', 'Updated'),
      ]);
    });

    test('deleting an unknown id leaves other items untouched', () async {
      await dataSource.saveTodos([_todo('1')]);
      await dataSource.deleteTodo('nope');

      expect(await dataSource.getTodos(), hasLength(1));
    });

    test('missing items throw CacheMissException', () {
      expect(() => dataSource.getTodo('x'), throwsA(isA<CacheMissException>()));
    });

    test('clear empties the cache', () async {
      await dataSource.saveTodos([_todo('1')]);
      await dataSource.clear();

      expect(await dataSource.getTodos(), isEmpty);
    });
  });
}
