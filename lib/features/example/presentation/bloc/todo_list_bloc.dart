import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/generic/presentation/bloc/paged_list_bloc.dart';
import '../../domain/entities/todo.dart';
import '../../domain/params/todo_params.dart';
import '../../domain/repositories/todo_repository.dart';

part 'todo_list_event.dart';

typedef TodoListState = PagedState<Todo, TodoQuery>;

/// Paged, searchable to-do list with create / toggle / delete.
///
/// Paging, refresh and search come from [PagedListBloc]
/// (`PagedListStarted`, `PagedListRefreshed`, `PagedListNextPageRequested`,
/// `PagedListQueryChanged<TodoQuery>`). Mutations run one at a time
/// (`sequential`) and report errors through [PagedState.failure] without
/// touching the loaded items (toggle is optimistic and rolled back on error).
@injectable
class TodoListBloc extends PagedListBloc<Todo, TodoQuery> {
  TodoListBloc(this._repository, {@ignoreParam super.queryDebounce})
    : super(
        initialQuery: const TodoQuery(),
        fetchPage: (page, query) =>
            _repository.getTodos(page: page, query: query),
      ) {
    on<TodoCreated>(_onCreated, transformer: sequential());
    on<TodoToggled>(_onToggled, transformer: sequential());
    on<TodoDeleted>(_onDeleted, transformer: sequential());
  }

  final ITodoRepository _repository;

  Future<void> _onCreated(
    TodoCreated event,
    Emitter<TodoListState> emit,
  ) async {
    final result = await _repository.createTodo(
      CreateTodoParams(title: event.title.trim()),
    );
    emit(
      result.fold(
        (failure) => state.copyWith(failure: () => failure),
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
    emit(state.copyWith(items: _replace(toggled), failure: () => null));

    final result = await _repository.updateTodo(
      UpdateTodoParams(id: original.id, isDone: toggled.isDone),
    );
    emit(
      result.fold(
        (failure) =>
            state.copyWith(items: _replace(original), failure: () => failure),
        (saved) => state.copyWith(items: _replace(saved)),
      ),
    );
  }

  Future<void> _onDeleted(
    TodoDeleted event,
    Emitter<TodoListState> emit,
  ) async {
    final result = await _repository.deleteTodo(event.id);
    emit(
      result.fold(
        (failure) => state.copyWith(failure: () => failure),
        (_) => state.copyWith(
          items: state.items.where((t) => t.id != event.id).toList(),
          failure: () => null,
        ),
      ),
    );
  }

  List<Todo> _replace(Todo todo) => [
    for (final item in state.items) item.id == todo.id ? todo : item,
  ];
}
