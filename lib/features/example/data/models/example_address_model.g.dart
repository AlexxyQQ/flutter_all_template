// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example_address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExampleAddressModel _$ExampleAddressModelFromJson(Map<String, dynamic> json) =>
    _ExampleAddressModel(
      street: json['street'] as String,
      city: json['city'] as String,
      zipCode: json['zip_code'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      isVerified: json['is_verified'] as bool? ?? false,
    );

Map<String, dynamic> _$ExampleAddressModelToJson(
  _ExampleAddressModel instance,
) => <String, dynamic>{
  'street': instance.street,
  'city': instance.city,
  'zip_code': instance.zipCode,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'is_verified': instance.isVerified,
};
