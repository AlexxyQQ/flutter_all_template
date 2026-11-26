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
/// `PagedListQueryChanged<TodoQuery>`). Mutations run one at a time
/// (`sequential`) and report errors through [PagedState.failure] without
/// touching the loaded items (toggle is optimistic and rolled back on error).
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

  Future<void> _onCreated(
    TodoCreated event,
    Emitter<TodoListState> emit,
  ) async {
    final correlationId = _analytics.trackAction(
      name: 'todo_create',
      parameters: {'title_length': event.title.trim().length},
    );
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
        (todo) => state.copyWith(
          items: [todo, ...state.items],
          failure: () => null,
          hasLoaded: true,
        ),
      ),
    );
  }

  Future<void> _onToggled(
    TodoToggled event,
    Emitter<TodoListState> emit,
  ) async {
    final original = event.todo;
    final toggled = original.copyWith(isDone: !original.isDone);
    final correlationId = _analytics.trackAction(
      name: 'todo_toggle',
      parameters: {'is_done': toggled.isDone},
    );
    emit(state.copyWith(items: _replace(toggled), failure: () => null));

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
          items: _replace(original),
          failure: () => failure,
        );
      }, (saved) => state.copyWith(items: _replace(saved))),
    );
  }

  Future<void> _onDeleted(
    TodoDeleted event,
    Emitter<TodoListState> emit,
  ) async {
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
  }

  void _trackFailure({
    required String source,
    required Failure failure,
    required String correlationId,
  }) => _analytics.trackError(
    source: source,
    error: failure,
    correlationId: correlationId,
  );

  List<Todo> _replace(Todo todo) => [
    for (final item in state.items) item.id == todo.id ? todo : item,
  ];
}
