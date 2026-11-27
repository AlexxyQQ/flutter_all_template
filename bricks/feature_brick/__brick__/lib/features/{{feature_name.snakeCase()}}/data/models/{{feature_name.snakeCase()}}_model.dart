import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/{{feature_name.snakeCase()}}.dart';

part '{{feature_name.snakeCase()}}_model.g.dart';

/// Wire/cache representation of a [{{feature_name.pascalCase()}}].
///
/// Required fields that are missing from a payload fail to decode (surfacing
/// as a `ParseException`) instead of being invented.
@JsonSerializable(fieldRename: FieldRename.snake)
final class {{feature_name.pascalCase()}}Model extends Equatable {
  const {{feature_name.pascalCase()}}Model({
    required this.id,
    required this.title,
    required this.updatedAt,
  });

  factory {{feature_name.pascalCase()}}Model.fromJson(Map<String, dynamic> json) =>
      _${{feature_name.pascalCase()}}ModelFromJson(json);

  final String id;
  final String title;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => _${{feature_name.pascalCase()}}ModelToJson(this);

  {{feature_name.pascalCase()}} toEntity() => {{feature_name.pascalCase()}}(id: id, title: title, updatedAt: updatedAt);

  @override
  List<Object?> get props => [id, title, updatedAt];
}
