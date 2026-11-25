import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/{{feature_name.snakeCase()}}.dart';

part '{{feature_name.snakeCase()}}_model.freezed.dart';
part '{{feature_name.snakeCase()}}_model.g.dart';

/// Wire/cache representation of a [{{feature_name.pascalCase()}}]. Required fields that are missing
/// from a payload fail to decode instead of being invented.
@freezed
abstract class {{feature_name.pascalCase()}}Model with _${{feature_name.pascalCase()}}Model {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory {{feature_name.pascalCase()}}Model({
    required String id,
    required String title,
    required DateTime updatedAt,
  }) = _{{feature_name.pascalCase()}}Model;

  const {{feature_name.pascalCase()}}Model._();

  factory {{feature_name.pascalCase()}}Model.fromJson(Map<String, dynamic> json) =>
      _${{feature_name.pascalCase()}}ModelFromJson(json);

  factory {{feature_name.pascalCase()}}Model.fromEntity({{feature_name.pascalCase()}} entity) => {{feature_name.pascalCase()}}Model(
    id: entity.id,
    title: entity.title,
    updatedAt: entity.updatedAt,
  );

  {{feature_name.pascalCase()}} toEntity() => {{feature_name.pascalCase()}}(id: id, title: title, updatedAt: updatedAt);
}
