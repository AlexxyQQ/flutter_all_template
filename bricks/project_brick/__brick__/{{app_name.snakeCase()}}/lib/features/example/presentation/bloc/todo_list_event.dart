part of 'todo_list_bloc.dart';

/// Events that change a to-do. Handled one at a time, in order.
sealed class TodoMutation extends PagedListEvent {
  const TodoMutation();
}

final class TodoCreated extends TodoMutation {
  const TodoCreated(this.title);

  final String title;

  @override
  List<Object?> get props => [title];
}

final class TodoToggled extends TodoMutation {
  const TodoToggled(this.todo);

  final Todo todo;

  @override
  List<Object?> get props => [todo];
}

final class TodoDeleted extends TodoMutation {
  const TodoDeleted(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}
