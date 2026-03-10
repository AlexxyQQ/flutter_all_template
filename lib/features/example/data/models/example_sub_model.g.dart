// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example_sub_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExampleSubModel _$ExampleSubModelFromJson(
  Map<String, dynamic> json,
) => _ExampleSubModel(
  subId: json['sub_id'] as String,
  description: json['description'] as String,
  isActive: json['is_active'] as bool,
  isVisible: json['is_visible'] as bool? ?? true,
  createdAt: ModelGeneratorHelper.generateCreatedAtFromJson(json['created_at']),
  updatedAt: ModelGeneratorHelper.generateUpdatedAtFromJson(json['updated_at']),
);

Map<String, dynamic> _$ExampleSubModelToJson(_ExampleSubModel instance) =>
    <String, dynamic>{
      'sub_id': instance.subId,
      'description': instance.description,
      'is_active': instance.isActive,
      'is_visible': instance.isVisible,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
