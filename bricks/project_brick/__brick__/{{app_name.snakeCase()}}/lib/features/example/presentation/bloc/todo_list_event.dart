part of 'todo_list_bloc.dart';

final class TodoCreated extends PagedListEvent {
  const TodoCreated(this.title);

  final String title;

  @override
  List<Object?> get props => [title];
}

final class TodoToggled extends PagedListEvent {
  const TodoToggled(this.todo);

  final Todo todo;

  @override
  List<Object?> get props => [todo];
}

final class TodoDeleted extends PagedListEvent {
  const TodoDeleted(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}
