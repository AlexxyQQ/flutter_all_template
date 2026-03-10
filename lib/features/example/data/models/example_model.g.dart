// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExampleModel _$ExampleModelFromJson(
  Map<String, dynamic> json,
) => _ExampleModel(
  id: ModelGeneratorHelper.generateUuidFromJson(json['id']),
  emptyId: json['empty_id'] as String?,
  defaultId: json['default_id'] as String? ?? 'id',
  age: (json['age'] as num).toInt(),
  emptyAge: (json['empty_age'] as num?)?.toInt(),
  defaultAge: (json['default_age'] as num?)?.toInt() ?? 18,
  grade: (json['grade'] as num).toDouble(),
  emptyGrade: (json['empty_grade'] as num?)?.toDouble(),
  defaultGrade: (json['default_grade'] as num?)?.toDouble() ?? 99.6,
  friends: (json['friends'] as List<dynamic>).map((e) => e as String).toList(),
  emptyFriends: (json['empty_friends'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  defaultFriends:
      (json['default_friends'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const ['a', 'b', 'c'],
  group: json['group'] as Map<String, dynamic>,
  emptyGroup: json['empty_group'] as Map<String, dynamic>?,
  defaultGroup:
      json['default_group'] as Map<String, dynamic>? ??
      const {'a': 1, 'b': 2, 'c': 3},
  listedGroup: (json['listed_group'] as List<dynamic>)
      .map((e) => e as Map<String, dynamic>)
      .toList(),
  emptyListedGroup: (json['empty_listed_group'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList(),
  defaultListedGroup:
      (json['default_listed_group'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList() ??
      const [
        {'a': 1, 'b': 2, 'c': 3},
        {'d': 4, 'e': 5, 'f': 6},
      ],
  status: $enumDecode(_$AccountStatusEnumMap, json['status']),
  defaultStatus: json['default_status'] == null
      ? AccountStatus.pending
      : const AccountStatusConverter().fromJson(
          json['default_status'] as String?,
        ),
  mainSubEntity: ExampleSubModel.fromJson(
    json['main_sub_entity'] as Map<String, dynamic>,
  ),
  optionalSubEntity: json['optional_sub_entity'] == null
      ? null
      : ExampleSubModel.fromJson(
          json['optional_sub_entity'] as Map<String, dynamic>,
        ),
  primaryAddress: ExampleAddressModel.fromJson(
    json['primary_address'] as Map<String, dynamic>,
  ),
  secondaryAddress: json['secondary_address'] == null
      ? null
      : ExampleAddressModel.fromJson(
          json['secondary_address'] as Map<String, dynamic>,
        ),
  settings: ExampleProfileSettingsModel.fromJson(
    json['settings'] as Map<String, dynamic>,
  ),
  pastAddresses:
      (json['past_addresses'] as List<dynamic>?)
          ?.map((e) => ExampleAddressModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ExampleModelToJson(_ExampleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'empty_id': instance.emptyId,
      'default_id': instance.defaultId,
      'age': instance.age,
      'empty_age': instance.emptyAge,
      'default_age': instance.defaultAge,
      'grade': instance.grade,
      'empty_grade': instance.emptyGrade,
      'default_grade': instance.defaultGrade,
      'friends': instance.friends,
      'empty_friends': instance.emptyFriends,
      'default_friends': instance.defaultFriends,
      'group': instance.group,
      'empty_group': instance.emptyGroup,
      'default_group': instance.defaultGroup,
      'listed_group': instance.listedGroup,
      'empty_listed_group': instance.emptyListedGroup,
      'default_listed_group': instance.defaultListedGroup,
      'status': instance.status.toJson(),
      'default_status': const AccountStatusConverter().toJson(
        instance.defaultStatus,
      ),
      'main_sub_entity': instance.mainSubEntity.toJson(),
      'optional_sub_entity': instance.optionalSubEntity?.toJson(),
      'primary_address': instance.primaryAddress.toJson(),
      'secondary_address': instance.secondaryAddress?.toJson(),
      'settings': instance.settings.toJson(),
      'past_addresses': instance.pastAddresses?.map((e) => e.toJson()).toList(),
    };

const _$AccountStatusEnumMap = {
  AccountStatus.active: 'active',
  AccountStatus.inactive: 'inactive',
  AccountStatus.suspended: 'suspended',
  AccountStatus.pending: 'pending',
};
