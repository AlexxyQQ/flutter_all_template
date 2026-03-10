import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/common/data/models/helpers/model_generation_helper.dart';
import '../../../data/models/{{feature_name.snakeCase()}}_model.dart';
import '../{{feature_name.snakeCase()}}_entity.dart';

part '{{feature_name.snakeCase()}}_request_params.freezed.dart';
part '{{feature_name.snakeCase()}}_request_params.g.dart';

@freezed
abstract class {{feature_name.pascalCase()}}RequestParams with _${{feature_name.pascalCase()}}RequestParams {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory {{feature_name.pascalCase()}}RequestParams({
    String? id,
    // TODO: add your request fields here
  }) = _{{feature_name.pascalCase()}}RequestParams;

  const {{feature_name.pascalCase()}}RequestParams._();

  factory {{feature_name.pascalCase()}}RequestParams.fromJson(Map<String, dynamic> json) =>
      _${{feature_name.pascalCase()}}RequestParamsFromJson(json);

  factory {{feature_name.pascalCase()}}RequestParams.create() {
    return {{feature_name.pascalCase()}}RequestParams(
      id: ModelGeneratorHelper.generateUuidFromJson(null),
    );
  }
}

// -----------------------------------------------------------------------------
// Params -> Model & Entity
// -----------------------------------------------------------------------------
extension {{feature_name.pascalCase()}}RequestParamsMapper on {{feature_name.pascalCase()}}RequestParams {
  {{feature_name.pascalCase()}}Model toModel() {
    return {{feature_name.pascalCase()}}Model(
      id: id ?? ModelGeneratorHelper.generateUuidFromJson(id),
    );
  }

  {{feature_name.pascalCase()}}Entity toEntity() {
    return {{feature_name.pascalCase()}}Entity(
      id: id ?? ModelGeneratorHelper.generateUuidFromJson(id),
    );
  }
}

// -----------------------------------------------------------------------------
// Model -> Params
// -----------------------------------------------------------------------------
extension {{feature_name.pascalCase()}}ModelParamsMapper on {{feature_name.pascalCase()}}Model {
  {{feature_name.pascalCase()}}RequestParams toParams() {
    return {{feature_name.pascalCase()}}RequestParams(id: id);
  }
}

// -----------------------------------------------------------------------------
// Entity -> Params
// -----------------------------------------------------------------------------
extension {{feature_name.pascalCase()}}EntityParamsMapper on {{feature_name.pascalCase()}}Entity {
  {{feature_name.pascalCase()}}RequestParams toParams() {
    return {{feature_name.pascalCase()}}RequestParams(id: id);
  }
}

// -----------------------------------------------------------------------------
// HELPER LIST MAPPERS
// -----------------------------------------------------------------------------
extension {{feature_name.pascalCase()}}RequestParamsListMapper on List<{{feature_name.pascalCase()}}RequestParams> {
  List<{{feature_name.pascalCase()}}Model> toModels() => map((e) => e.toModel()).toList();
  List<{{feature_name.pascalCase()}}Entity> toEntities() => map((e) => e.toEntity()).toList();
}
