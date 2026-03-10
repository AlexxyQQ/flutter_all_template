// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example_request_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExampleRequestParams _$ExampleRequestParamsFromJson(
  Map<String, dynamic> json,
) => _ExampleRequestParams(
  age: (json['age'] as num).toInt(),
  grade: (json['grade'] as num).toDouble(),
  friends: (json['friends'] as List<dynamic>).map((e) => e as String).toList(),
  group: json['group'] as Map<String, dynamic>,
  listedGroup: (json['listed_group'] as List<dynamic>)
      .map((e) => e as Map<String, dynamic>)
      .toList(),
  status: $enumDecode(_$AccountStatusEnumMap, json['status']),
  mainSubEntity: const ExampleSubEntityConverter().fromJson(
    json['main_sub_entity'] as Map<String, dynamic>,
  ),
  primaryAddress: const ExampleAddressEntityConverter().fromJson(
    json['primary_address'] as Map<String, dynamic>,
  ),
  settings: const ExampleProfileSettingsEntityConverter().fromJson(
    json['settings'] as Map<String, dynamic>,
  ),
  id: json['id'] as String?,
  emptyId: json['empty_id'] as String?,
  defaultId: json['default_id'] as String? ?? 'id',
  emptyAge: (json['empty_age'] as num?)?.toInt(),
  defaultAge: (json['default_age'] as num?)?.toInt() ?? 18,
  emptyGrade: (json['empty_grade'] as num?)?.toDouble(),
  defaultGrade: (json['default_grade'] as num?)?.toDouble() ?? 99.6,
  emptyFriends: (json['empty_friends'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  defaultFriends:
      (json['default_friends'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const ['a', 'b', 'c'],
  emptyGroup: json['empty_group'] as Map<String, dynamic>?,
  defaultGroup:
      json['default_group'] as Map<String, dynamic>? ??
      const {'a': 1, 'b': 2, 'c': 3},
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
  defaultStatus:
      $enumDecodeNullable(_$AccountStatusEnumMap, json['default_status']) ??
      AccountStatus.pending,
  optionalSubEntity: const NullableExampleSubEntityConverter().fromJson(
    json['optional_sub_entity'] as Map<String, dynamic>?,
  ),
  secondaryAddress: const NullableExampleAddressEntityConverter().fromJson(
    json['secondary_address'] as Map<String, dynamic>?,
  ),
  pastAddresses:
      (json['past_addresses'] as List<dynamic>?)
          ?.map(
            (e) => const ExampleAddressEntityConverter().fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$ExampleRequestParamsToJson(
  _ExampleRequestParams instance,
) => <String, dynamic>{
  'age': instance.age,
  'grade': instance.grade,
  'friends': instance.friends,
  'group': instance.group,
  'listed_group': instance.listedGroup,
  'status': instance.status.toJson(),
  'main_sub_entity': const ExampleSubEntityConverter().toJson(
    instance.mainSubEntity,
  ),
  'primary_address': const ExampleAddressEntityConverter().toJson(
    instance.primaryAddress,
  ),
  'settings': const ExampleProfileSettingsEntityConverter().toJson(
    instance.settings,
  ),
  'id': instance.id,
  'empty_id': instance.emptyId,
  'default_id': instance.defaultId,
  'empty_age': instance.emptyAge,
  'default_age': instance.defaultAge,
  'empty_grade': instance.emptyGrade,
  'default_grade': instance.defaultGrade,
  'empty_friends': instance.emptyFriends,
  'default_friends': instance.defaultFriends,
  'empty_group': instance.emptyGroup,
  'default_group': instance.defaultGroup,
  'empty_listed_group': instance.emptyListedGroup,
  'default_listed_group': instance.defaultListedGroup,
  'default_status': instance.defaultStatus.toJson(),
  'optional_sub_entity': const NullableExampleSubEntityConverter().toJson(
    instance.optionalSubEntity,
  ),
  'secondary_address': const NullableExampleAddressEntityConverter().toJson(
    instance.secondaryAddress,
  ),
  'past_addresses': instance.pastAddresses
      .map(const ExampleAddressEntityConverter().toJson)
      .toList(),
};

const _$AccountStatusEnumMap = {
  AccountStatus.active: 'active',
  AccountStatus.inactive: 'inactive',
  AccountStatus.suspended: 'suspended',
  AccountStatus.pending: 'pending',
};
