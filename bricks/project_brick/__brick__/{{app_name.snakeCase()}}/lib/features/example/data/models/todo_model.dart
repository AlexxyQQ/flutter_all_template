import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/todo.dart';

part 'todo_model.freezed.dart';
part 'todo_model.g.dart';

/// Wire/cache representation of a [Todo].
///
/// `id` and `updated_at` are required: a payload without them is a backend
/// contract bug and fails to decode (surfacing as a `ParseException`), rather
/// than silently inventing values.
@freezed
abstract class TodoModel with _$TodoModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TodoModel({
    required String id,
    required String title,
    required DateTime updatedAt,
    @Default(false) bool isDone,
  }) = _TodoModel;

  const TodoModel._();

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);

  factory TodoModel.fromEntity(Todo todo) => TodoModel(
    id: todo.id,
    title: todo.title,
    isDone: todo.isDone,
    updatedAt: todo.updatedAt,
  );

  Todo toEntity() =>
      Todo(id: id, title: title, isDone: isDone, updatedAt: updatedAt);
}
