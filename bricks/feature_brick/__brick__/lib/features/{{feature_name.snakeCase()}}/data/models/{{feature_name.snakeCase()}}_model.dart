import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/common/data/models/helpers/model_generation_helper.dart';
import '../../domain/entities/{{feature_name.snakeCase()}}_entity.dart';

part '{{feature_name.snakeCase()}}_model.freezed.dart';
part '{{feature_name.snakeCase()}}_model.g.dart';

@freezed
abstract class {{feature_name.pascalCase()}}Model with _${{feature_name.pascalCase()}}Model {
  const {{feature_name.pascalCase()}}Model._();

  @JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
  const factory {{feature_name.pascalCase()}}Model({
    @JsonKey(fromJson: ModelGeneratorHelper.generateUuidFromJson)
    required String id,
    // TODO: add your model fields here (mirror entity fields)
  }) = _{{feature_name.pascalCase()}}Model;

  factory {{feature_name.pascalCase()}}Model.fromJson(Map<String, dynamic> json) =>
      _${{feature_name.pascalCase()}}ModelFromJson(json);
}

// -----------------------------------------------------------------------------
// MODEL -> ENTITY
// -----------------------------------------------------------------------------
extension {{feature_name.pascalCase()}}ModelMapper on {{feature_name.pascalCase()}}Model {
  {{feature_name.pascalCase()}}Entity toEntity() {
    return {{feature_name.pascalCase()}}Entity(
      id: id,
    );
  }
}

// -----------------------------------------------------------------------------
// ENTITY -> MODEL
// -----------------------------------------------------------------------------
extension {{feature_name.pascalCase()}}EntityMapper on {{feature_name.pascalCase()}}Entity {
  {{feature_name.pascalCase()}}Model toModel() {
    return {{feature_name.pascalCase()}}Model(
      id: id,
    );
  }
}

// -----------------------------------------------------------------------------
// HELPER LIST MAPPERS
// -----------------------------------------------------------------------------
extension {{feature_name.pascalCase()}}ModelListMapper on List<{{feature_name.pascalCase()}}Model> {
  List<{{feature_name.pascalCase()}}Entity> toEntities() => map((e) => e.toEntity()).toList();
}

extension {{feature_name.pascalCase()}}EntityListMapper on List<{{feature_name.pascalCase()}}Entity> {
  List<{{feature_name.pascalCase()}}Model> toModels() => map((e) => e.toModel()).toList();
}
