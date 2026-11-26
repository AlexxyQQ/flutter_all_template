import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';

/// A to-do item. Pure domain object: no JSON, no Flutter.
@freezed
abstract class Todo with _$Todo {
  const factory Todo({
    required String id,
    required String title,
    required bool isDone,
    required DateTime updatedAt,
  }) = _Todo;
}
