import 'package:equatable/equatable.dart';

/// A to-do item. Pure domain object: no JSON, no Flutter.
final class Todo extends Equatable {
  const Todo({
    required this.id,
    required this.title,
    required this.isDone,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final bool isDone;
  final DateTime updatedAt;

  Todo copyWith({String? title, bool? isDone, DateTime? updatedAt}) => Todo(
    id: id,
    title: title ?? this.title,
    isDone: isDone ?? this.isDone,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  @override
  List<Object?> get props => [id, title, isDone, updatedAt];
}
