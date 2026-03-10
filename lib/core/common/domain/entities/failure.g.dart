// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'failure.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Failure _$FailureFromJson(Map<String, dynamic> json) => _Failure(
  message: json['message'] as String,
  code: json['code'] as String?,
  data: json['data'] as String?,
  path: json['path'] as String?,
);

Map<String, dynamic> _$FailureToJson(_Failure instance) => <String, dynamic>{
  'message': instance.message,
  'code': instance.code,
  'data': instance.data,
  'path': instance.path,
};
