import 'package:injectable/injectable.dart';

import '../../../../../config/constants/api/api_paths.dart';
import '../../../../../core/generic/domain/entities/page.dart';
import '../../../../../core/network/api_client.dart';
import '../../../domain/params/todo_params.dart';
import '../../models/todo_model.dart';

/// HTTP access to `/todos`. Throws `AppException`s (via [ApiClient]).
abstract interface class ITodoRemoteDataSource {
  Future<PageResult<TodoModel>> getTodos({
    required PageRequest page,
    required TodoQuery query,
  });

  Future<TodoModel> getTodo(String id);

  Future<TodoModel> createTodo(CreateTodoParams params);

  Future<TodoModel> updateTodo(UpdateTodoParams params);

  Future<void> deleteTodo(String id);
}

/// API contract (adapt to your backend):
///
/// | Call | Request | Response |
/// |---|---|---|
/// | list | `GET /todos?page=&limit=&cursor=&search=&only_open=` | `{"items": [Todo], "has_more": bool?, "next_cursor": String?}` |
/// | read | `GET /todos/{id}` | `Todo` |
/// | create | `POST /todos` `{"title"}` | `Todo` (201) |
/// | update | `PATCH /todos/{id}` `{"title"?, "is_done"?}` | `Todo` |
/// | delete | `DELETE /todos/{id}` | empty (204) |
@LazySingleton(as: ITodoRemoteDataSource)
class TodoRemoteDataSource implements ITodoRemoteDataSource {
  TodoRemoteDataSource(this._client);

  final ApiClient _client;

  static String _item(String id) =>
      '${ApiPaths.todos}/${Uri.encodeComponent(id)}';

  @override
  Future<PageResult<TodoModel>> getTodos({
    required PageRequest page,
    required TodoQuery query,
  }) {
    return _client.get(
      ApiPaths.todos,
      query: {
        'page': page.page,
        'limit': page.limit,
        if (page.cursor != null) 'cursor': page.cursor,
        if (query.search.isNotEmpty) 'search': query.search,
        if (query.onlyOpen) 'only_open': true,
      },
      decode: (json) {
        final body = Decoders.object(json);
        final items = Decoders.listOf(TodoModel.fromJson)(body['items']);
        final nextCursor = body['next_cursor'] as String?;
        final hasMore = body['has_more'] as bool?;
        return hasMore == null && nextCursor == null
            ? PageResult.fromItems(items, request: page)
            : PageResult(
                items: items,
                hasMore: hasMore ?? true,
                nextCursor: nextCursor,
              );
      },
    );
  }

  @override
  Future<TodoModel> getTodo(String id) =>
      _client.get(_item(id), decode: _decodeTodo);

  @override
  Future<TodoModel> createTodo(CreateTodoParams params) => _client.post(
    ApiPaths.todos,
    body: {'title': params.title},
    decode: _decodeTodo,
  );

  @override
  Future<TodoModel> updateTodo(UpdateTodoParams params) => _client.patch(
    _item(params.id),
    body: {
      if (params.title != null) 'title': params.title,
      if (params.isDone != null) 'is_done': params.isDone,
    },
    decode: _decodeTodo,
  );

  @override
  Future<void> deleteTodo(String id) =>
      _client.delete(_item(id), decode: Decoders.ignore);

  static TodoModel _decodeTodo(Object? json) =>
      TodoModel.fromJson(Decoders.object(json));
}
