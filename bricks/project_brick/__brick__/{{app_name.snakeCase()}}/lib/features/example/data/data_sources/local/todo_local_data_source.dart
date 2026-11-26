import 'package:injectable/injectable.dart';

import '../../../../../core/generic/data/json_collection_store.dart';
import '../../../../../core/storage/key_value_stores.dart';
import '../../models/todo_model.dart';

/// Offline cache of to-dos. Throws `StorageException` / `CacheMissException`.
abstract interface class ITodoLocalDataSource {
  Future<List<TodoModel>> getTodos();

  /// Throws `CacheMissException` if [id] isn't cached.
  Future<TodoModel> getTodo({required String id});

  Future<void> saveTodos({required Iterable<TodoModel> todos});

  Future<void> saveTodo({required TodoModel todo});

  Future<void> deleteTodo({required String id});

  Future<void> clear();
}

@LazySingleton(as: ITodoLocalDataSource)
class TodoLocalDataSource implements ITodoLocalDataSource {
  TodoLocalDataSource({required PreferencesStore store})
    : _todos = JsonCollectionStore<TodoModel>(
        store: store,
        key: storageKey,
        idOf: (todo) => todo.id,
        toJson: (todo) => todo.toJson(),
        fromJson: TodoModel.fromJson,
      );

  static const String storageKey = 'cache.todos';

  final JsonCollectionStore<TodoModel> _todos;

  @override
  Future<List<TodoModel>> getTodos() => _todos.readAll();

  @override
  Future<TodoModel> getTodo({required String id}) => _todos.read(id);

  @override
  Future<void> saveTodos({required Iterable<TodoModel> todos}) =>
      _todos.upsertAll(todos);

  @override
  Future<void> saveTodo({required TodoModel todo}) => _todos.upsert(todo);

  @override
  Future<void> deleteTodo({required String id}) => _todos.delete(id);

  @override
  Future<void> clear() => _todos.clear();
}
