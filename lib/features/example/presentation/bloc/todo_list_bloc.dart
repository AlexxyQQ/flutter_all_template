import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/generic/presentation/bloc/paged_list_bloc.dart';
import '../../../../core/services/analytics/domain/analytics_service.dart';
import '../../domain/entities/todo.dart';
import '../../domain/params/todo_params.dart';
import '../../domain/usecases/create_todo_use_case.dart';
import '../../domain/usecases/delete_todo_use_case.dart';
import '../../domain/usecases/get_todos_use_case.dart';
import '../../domain/usecases/update_todo_use_case.dart';

part 'todo_list_event.dart';

typedef TodoListState = PagedState<Todo, TodoQuery>;

/// Paged, searchable to-do list with create / toggle / delete.
///
/// Paging, refresh and search come from [PagedListBloc]
/// (`PagedListStarted`, `PagedListRefreshed`, `PagedListNextPageRequested`,
/// `PagedListQueryChanged<TodoQuery>`).
///
/// **Mutations** ([TodoMutation]) share one `sequential()` handler, so they
/// run one at a time in the order they were added. A toggle is optimistic: the
/// list changes at once and is rolled back if the server rejects it. A
/// refresh that was already in flight when a mutation finished can briefly
/// show the pre-mutation data until the next refresh.
///
/// **Filtered lists.** Mutation results respect the active [TodoQuery] (via
/// `TodoQuery.matches`): a created to-do that doesn't match the search is not
/// inserted, and a toggled one that no longer matches (completed while "only
/// open" is on) leaves the list. Errors are reported through
/// [PagedState.failure].
///
/// **Analytics:** every mutation is tracked as an action and its failure as an
/// error correlated with it; search, refresh, load and load-more are tracked
/// from [onLoadStarted] and their failures from [onLoadFailed]. Only derived
/// values are sent (`title_length`, `query_length`), never the title or the
/// search text.
@injectable
class TodoListBloc extends PagedListBloc<Todo, TodoQuery> {
  TodoListBloc({
    required GetTodosUseCase getTodos,
    required CreateTodoUseCase createTodo,
    required UpdateTodoUseCase updateTodo,
    required DeleteTodoUseCase deleteTodo,
    required IAnalyticsService analytics,
    @ignoreParam super.queryDebounce,
  }) : _createTodo = createTodo,
       _updateTodo = updateTodo,
       _deleteTodo = deleteTodo,
       _analytics = analytics,
       super(
         initialQuery: const TodoQuery(),
         fetchPage: (page, query) => getTodos(page: page, query: query),
       ) {
    on<TodoMutation>(_onMutation, transformer: sequential());
  }

  final CreateTodoUseCase _createTodo;
  final UpdateTodoUseCase _updateTodo;
  final DeleteTodoUseCase _deleteTodo;
  final IAnalyticsService _analytics;

  // Correlates a list-load failure with the load that caused it.
  String? _listActionId;

  @override
  void onLoadStarted({required PagedListEvent event}) {
    _listActionId = switch (event) {
      PagedListQueryChanged<TodoQuery>(:final query) => _analytics.trackAction(
        name: 'todo_search',
        parameters: {
          'query_length': query.search.trim().length,
          'only_open': query.onlyOpen,
        },
      ),
      PagedListRefreshed() => _analytics.trackAction(name: 'todo_refresh'),
      PagedListStarted() => _analytics.trackAction(name: 'todo_load'),
      PagedListNextPageRequested() => _analytics.trackAction(
        name: 'todo_load_more',
      ),
      _ => _listActionId,
    };
  }

  @override
  void onLoadFailed({required Failure failure}) => _analytics.trackError(
    source: 'todo_list_load',
    error: failure,
    correlationId: _listActionId,
  );

  Future<void> _onMutation(TodoMutation event, Emitter<TodoListState> emit) =>
      switch (event) {
        TodoCreated() => _create(event, emit),
        TodoToggled() => _toggle(event, emit),
        TodoDeleted() => _delete(event, emit),
      };

  Future<void> _create(TodoCreated event, Emitter<TodoListState> emit) async {
    final correlationId = _analytics.trackAction(
      name: 'todo_create',
      parameters: {'title_length': event.title.trim().length},
    );
    final query = state.query;
    final result = await _createTodo(
      params: CreateTodoParams(title: event.title),
    );
    emit(
      result.fold(
        (failure) => _failed(
          source: 'todo_create',
          failure: failure,
          correlationId: correlationId,
        ),
        (todo) {
          // Insert only into the list the user created it from, and only if
          // it belongs there.
          final visible =
              query == state.query &&
              query.matches(todo) &&
              !state.items.any((t) => t.id == todo.id);
          return state.copyWith(
            items: visible ? [todo, ...state.items] : null,
            failure: () => null,
          );
        },
      ),
    );
  }

  Future<void> _toggle(TodoToggled event, Emitter<TodoListState> emit) async {
    final original = event.todo;
    final toggled = original.copyWith(isDone: !original.isDone);
    final correlationId = _analytics.trackAction(
      name: 'todo_toggle',
      parameters: {'is_done': toggled.isDone},
    );
    final query = state.query;
    final originalIndex = state.items.indexWhere((t) => t.id == original.id);
    emit(
      state.copyWith(
        items: _place(toggled, query: query),
        failure: () => null,
      ),
    );

    final result = await _updateTodo(
      params: UpdateTodoParams(id: original.id, isDone: toggled.isDone),
    );
    emit(
      result.fold(
        (failure) => _failed(
          source: 'todo_toggle',
          failure: failure,
          correlationId: correlationId,
          items: _place(original, query: query, restoreAt: originalIndex),
        ),
        (saved) => state.copyWith(items: _place(saved, query: query)),
      ),
    );
  }

  Future<void> _delete(TodoDeleted event, Emitter<TodoListState> emit) async {
    final correlationId = _analytics.trackAction(name: 'todo_delete');
    final result = await _deleteTodo(id: event.id);
    emit(
      result.fold(
        (failure) => _failed(
          source: 'todo_delete',
          failure: failure,
          correlationId: correlationId,
        ),
        (_) => state.copyWith(
          items: state.items.where((t) => t.id != event.id).toList(),
          failure: () => null,
        ),
      ),
    );
  }

  /// Tracks [failure] against its action and returns the state that shows it
  /// (with [items] when a rollback changed them).
  TodoListState _failed({
    required String source,
    required Failure failure,
    required String correlationId,
    List<Todo>? items,
  }) {
    _analytics.trackError(
      source: source,
      error: failure,
      correlationId: correlationId,
    );
    return state.copyWith(items: items, failure: () => failure);
  }

  /// The current items with [todo] applied for the list of [query]:
  /// replaced in place if it matches, removed if it doesn't, re-inserted at
  /// [restoreAt] if it was removed meanwhile (rollback). Returns the items
  /// unchanged when the list now shows a different query.
  List<Todo> _place(Todo todo, {required TodoQuery query, int? restoreAt}) {
    final items = state.items;
    if (query != state.query) {
      return items;
    }
    final present = items.any((t) => t.id == todo.id);
    if (!query.matches(todo)) {
      return present ? items.where((t) => t.id != todo.id).toList() : items;
    }
    if (present) {
      return [for (final t in items) t.id == todo.id ? todo : t];
    }
    if (restoreAt == null || restoreAt < 0) {
      return items;
    }
    return [...items]..insert(restoreAt.clamp(0, items.length), todo);
  }
}
