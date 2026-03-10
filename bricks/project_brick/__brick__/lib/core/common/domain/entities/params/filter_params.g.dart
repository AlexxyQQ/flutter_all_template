// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FilterParams _$FilterParamsFromJson(Map<String, dynamic> json) =>
    _FilterParams(
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 10,
      query: json['query'] as String?,
    );

Map<String, dynamic> _$FilterParamsToJson(_FilterParams instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'query': instance.query,
    };
