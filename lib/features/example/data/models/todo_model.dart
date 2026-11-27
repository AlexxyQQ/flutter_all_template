import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/todo.dart';

part 'todo_model.g.dart';

/// Wire/cache representation of a [Todo].
///
/// `id` and `updated_at` are required: a payload without them is a backend
/// contract bug and fails to decode (surfacing as a `ParseException`), rather
/// than silently inventing values.
@JsonSerializable(fieldRename: FieldRename.snake)
final class TodoModel extends Equatable {
  const TodoModel({
    required this.id,
    required this.title,
    required this.updatedAt,
    this.isDone = false,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);

  final String id;
  final String title;
  final DateTime updatedAt;
  final bool isDone;

  Map<String, dynamic> toJson() => _$TodoModelToJson(this);

  Todo toEntity() =>
      Todo(id: id, title: title, isDone: isDone, updatedAt: updatedAt);

  @override
  List<Object?> get props => [id, title, updatedAt, isDone];
}
