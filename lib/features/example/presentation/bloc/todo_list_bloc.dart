import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/common/domain/entities/failure.dart';
import '../../../../core/common/domain/services/analytics/domain/analytics_service.dart';
import '../../../../core/generic/presentation/bloc/paged_list_bloc.dart';
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
/// **Mutation serialization.** Mutations run one at a time (`sequential`) and
/// each runs inside [serialized], so they never interleave with list loads
/// either: a refresh can't overwrite a mutation with a stale snapshot, and a
/// mutation never acts on a list that is about to be replaced. A mutation
/// that completes after the query changed leaves the (new) list untouched.
///
/// **Filtered lists.** Mutation results respect the active [TodoQuery]: a
/// created to-do that doesn't match the search is not inserted, and a toggled
/// one that no longer matches (completed while "only open" is on) leaves the
/// list. Errors are reported through [PagedState.failure]; a failed toggle is
/// rolled back to its original position.
///
/// Analytics: every mutation is tracked as an action and its failure as an
/// error correlated with it; search, refresh and list-load failures are
/// tracked too. Only derived values are sent (`title_length`,
/// `query_length`), never the title or search text.
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
    on<TodoCreated>(_onCreated, transformer: sequential());
    on<TodoToggled>(_onToggled, transformer: sequential());
    on<TodoDeleted>(_onDeleted, transformer: sequential());
  }

  final CreateTodoUseCase _createTodo;
  final UpdateTodoUseCase _updateTodo;
  final DeleteTodoUseCase _deleteTodo;
  final IAnalyticsService _analytics;

  // Correlates a list-load failure with the search/refresh that caused it.
  String? _listActionId;

  @override
  void onTransition(Transition<PagedListEvent, TodoListState> transition) {
    super.onTransition(transition);
    final event = transition.event;
    if (event is TodoCreated || event is TodoToggled || event is TodoDeleted) {
      return; // Tracked with explicit correlation in their handlers.
    }
    final current = transition.currentState;
    final next = transition.nextState;
    if (event is PagedListQueryChanged<TodoQuery> &&
        current.query != next.query) {
      _listActionId = _analytics.trackAction(
        name: 'todo_search',
        parameters: {
          'query_length': next.query.search.trim().length,
          'only_open': next.query.onlyOpen,
        },
      );
    } else if (event is PagedListRefreshed &&
        current.status == PagedStatus.idle) {
      _listActionId = _analytics.trackAction(name: 'todo_refresh');
    } else if (event is PagedListStarted && next.isLoadingFirst) {
      _listActionId = _analytics.trackAction(name: 'todo_load');
    } else if (event is PagedListNextPageRequested && next.isLoadingMore) {
      _listActionId = _analytics.trackAction(name: 'todo_load_more');
    }
    final failure = next.failure;
    if (failure != null && failure != current.failure) {
      _analytics.trackError(
        source: 'todo_list_load',
        error: failure,
        correlationId: _listActionId,
      );
    }
  }

  Future<void> _onCreated(TodoCreated event, Emitter<TodoListState> emit) =>
      serialized(() async {
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
            (failure) {
              _trackFailure(
                source: 'todo_create',
                failure: failure,
                correlationId: correlationId,
              );
              return state.copyWith(failure: () => failure);
            },
            (todo) {
              // Insert only into the list the user created it from, and only if
              // it belongs there.
              final visible =
                  query == state.query &&
                  _matches(todo, state.query) &&
                  !state.items.any((t) => t.id == todo.id);
              return state.copyWith(
                items: visible ? [todo, ...state.items] : null,
                failure: () => null,
              );
            },
          ),
        );
      });

  Future<void> _onToggled(TodoToggled event, Emitter<TodoListState> emit) =>
      serialized(() async {
        final original = event.todo;
        final toggled = original.copyWith(isDone: !original.isDone);
        final correlationId = _analytics.trackAction(
          name: 'todo_toggle',
          parameters: {'is_done': toggled.isDone},
        );
        final query = state.query;
        final originalIndex = state.items.indexWhere(
          (t) => t.id == original.id,
        );
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
          result.fold((failure) {
            _trackFailure(
              source: 'todo_toggle',
              failure: failure,
              correlationId: correlationId,
            );
            return state.copyWith(
              items: _place(original, query: query, restoreAt: originalIndex),
              failure: () => failure,
            );
          }, (saved) => state.copyWith(items: _place(saved, query: query))),
        );
      });

  Future<void> _onDeleted(TodoDeleted event, Emitter<TodoListState> emit) =>
      serialized(() async {
        final correlationId = _analytics.trackAction(name: 'todo_delete');
        final result = await _deleteTodo(id: event.id);
        emit(
          result.fold(
            (failure) {
              _trackFailure(
                source: 'todo_delete',
                failure: failure,
                correlationId: correlationId,
              );
              return state.copyWith(failure: () => failure);
            },
            (_) => state.copyWith(
              items: state.items.where((t) => t.id != event.id).toList(),
              failure: () => null,
            ),
          ),
        );
      });

  void _trackFailure({
    required String source,
    required Failure failure,
    required String correlationId,
  }) => _analytics.trackError(
    source: source,
    error: failure,
    correlationId: correlationId,
  );

  /// Mirrors the server-side filter of [TodoQuery].
  static bool _matches(Todo todo, TodoQuery query) {
    if (query.onlyOpen && todo.isDone) {
      return false;
    }
    final search = query.search.trim().toLowerCase();
    return search.isEmpty || todo.title.toLowerCase().contains(search);
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
    if (!_matches(todo, query)) {
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
