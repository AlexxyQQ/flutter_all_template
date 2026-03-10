import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/common/data/models/helpers/model_generation_helper.dart';
import '../../domain/entities/example_sub_entity.dart';

part 'example_sub_model.freezed.dart';
part 'example_sub_model.g.dart';

@freezed
abstract class ExampleSubModel with _$ExampleSubModel {
  const ExampleSubModel._();

  @JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
  const factory ExampleSubModel({
    required String subId,
    required String description,
    required bool isActive,
    @Default(true) bool isVisible,
    @JsonKey(fromJson: ModelGeneratorHelper.generateCreatedAtFromJson)
    required DateTime createdAt,
    @JsonKey(fromJson: ModelGeneratorHelper.generateUpdatedAtFromJson)
    DateTime? updatedAt,
  }) = _ExampleSubModel;

  factory ExampleSubModel.fromJson(Map<String, dynamic> json) =>
      _$ExampleSubModelFromJson(json);
}

// -----------------------------------------------------------------------------
// MODEL -> ENTITY
// -----------------------------------------------------------------------------
extension ExampleSubModelMapper on ExampleSubModel {
  ExampleSubEntity toEntity() {
    return ExampleSubEntity(
      subId: subId,
      description: description,
      isActive: isActive,
      isVisible: isVisible,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

// -----------------------------------------------------------------------------
// ENTITY -> MODEL
// -----------------------------------------------------------------------------
extension ExampleSubEntityMapper on ExampleSubEntity {
  ExampleSubModel toModel() {
    return ExampleSubModel(
      subId: subId,
      description: description,
      isActive: isActive,
      isVisible: isVisible,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

// -----------------------------------------------------------------------------
// HELPER LIST MAPPERS
// -----------------------------------------------------------------------------
extension ExampleSubModelListMapper on List<ExampleSubModel> {
  List<ExampleSubEntity> toEntities() => map((e) => e.toEntity()).toList();
}

extension ExampleSubEntityListMapper on List<ExampleSubEntity> {
  List<ExampleSubModel> toModels() => map((e) => e.toModel()).toList();
}
