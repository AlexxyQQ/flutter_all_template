import 'package:equatable/equatable.dart';

/// Input for creating a [Todo]. The server assigns `id` and `updatedAt`.
final class CreateTodoParams extends Equatable {
  const CreateTodoParams({required this.title});

  final String title;

  @override
  List<Object?> get props => [title];
}

/// Partial update of a [Todo]: only non-null fields are changed.
final class UpdateTodoParams extends Equatable {
  const UpdateTodoParams({required this.id, this.title, this.isDone});

  final String id;
  final String? title;
  final bool? isDone;

  @override
  List<Object?> get props => [id, title, isDone];
}

/// Filter for the to-do list.
final class TodoQuery extends Equatable {
  const TodoQuery({this.search = '', this.onlyOpen = false});

  /// Case-insensitive title filter; empty = no filter.
  final String search;

  /// Hide completed items.
  final bool onlyOpen;

  TodoQuery copyWith({String? search, bool? onlyOpen}) => TodoQuery(
    search: search ?? this.search,
    onlyOpen: onlyOpen ?? this.onlyOpen,
  );

  @override
  List<Object?> get props => [search, onlyOpen];
}
