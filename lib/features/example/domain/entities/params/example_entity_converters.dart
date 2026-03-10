import 'package:json_annotation/json_annotation.dart';

import '../../../../../config/constants/enums/app_specifics/role.dart';
import '../example_address_entity.dart';
import '../example_profile_settings_entity.dart';
import '../example_sub_entity.dart';

class ExampleSubEntityConverter
    implements JsonConverter<ExampleSubEntity, Map<String, dynamic>> {
  const ExampleSubEntityConverter();

  @override
  ExampleSubEntity fromJson(Map<String, dynamic> json) => ExampleSubEntity(
        subId: json['sub_id'] as String,
        description: json['description'] as String,
        isActive: json['is_active'] as bool,
        isVisible: json['is_visible'] as bool? ?? true,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
      );

  @override
  Map<String, dynamic> toJson(ExampleSubEntity entity) => {
        'sub_id': entity.subId,
        'description': entity.description,
        'is_active': entity.isActive,
        'is_visible': entity.isVisible,
        'created_at': entity.createdAt.toIso8601String(),
        'updated_at': entity.updatedAt?.toIso8601String(),
      };
}

class ExampleAddressEntityConverter
    implements JsonConverter<ExampleAddressEntity, Map<String, dynamic>> {
  const ExampleAddressEntityConverter();

  @override
  ExampleAddressEntity fromJson(Map<String, dynamic> json) =>
      ExampleAddressEntity(
        street: json['street'] as String,
        city: json['city'] as String,
        zipCode: json['zip_code'] as String,
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        isVerified: json['is_verified'] as bool? ?? false,
      );

  @override
  Map<String, dynamic> toJson(ExampleAddressEntity entity) => {
        'street': entity.street,
        'city': entity.city,
        'zip_code': entity.zipCode,
        'latitude': entity.latitude,
        'longitude': entity.longitude,
        'is_verified': entity.isVerified,
      };
}

class NullableExampleSubEntityConverter
    implements JsonConverter<ExampleSubEntity?, Map<String, dynamic>?> {
  const NullableExampleSubEntityConverter();

  @override
  ExampleSubEntity? fromJson(Map<String, dynamic>? json) =>
      json == null ? null : const ExampleSubEntityConverter().fromJson(json);

  @override
  Map<String, dynamic>? toJson(ExampleSubEntity? entity) =>
      entity == null ? null : const ExampleSubEntityConverter().toJson(entity);
}

class NullableExampleAddressEntityConverter
    implements JsonConverter<ExampleAddressEntity?, Map<String, dynamic>?> {
  const NullableExampleAddressEntityConverter();

  @override
  ExampleAddressEntity? fromJson(Map<String, dynamic>? json) =>
      json == null ? null : const ExampleAddressEntityConverter().fromJson(json);

  @override
  Map<String, dynamic>? toJson(ExampleAddressEntity? entity) =>
      entity == null ? null : const ExampleAddressEntityConverter().toJson(entity);
}

class ExampleProfileSettingsEntityConverter
    implements
        JsonConverter<ExampleProfileSettingsEntity, Map<String, dynamic>> {
  const ExampleProfileSettingsEntityConverter();

  @override
  ExampleProfileSettingsEntity fromJson(Map<String, dynamic> json) =>
      ExampleProfileSettingsEntity(
        userRole: const RoleConverter().fromJson(json['user_role'] as String?),
        fallbackRole:
            const RoleConverter().fromJson(json['fallback_role'] as String?),
        emailNotificationsEnabled:
            json['email_notifications_enabled'] as bool? ?? true,
        smsNotificationsEnabled:
            json['sms_notifications_enabled'] as bool? ?? false,
        billingAddress: json['billing_address'] == null
            ? null
            : const ExampleAddressEntityConverter()
                .fromJson(json['billing_address'] as Map<String, dynamic>),
      );

  @override
  Map<String, dynamic> toJson(ExampleProfileSettingsEntity entity) => {
        'user_role': const RoleConverter().toJson(entity.userRole),
        'fallback_role': const RoleConverter().toJson(entity.fallbackRole),
        'email_notifications_enabled': entity.emailNotificationsEnabled,
        'sms_notifications_enabled': entity.smsNotificationsEnabled,
        'billing_address': entity.billingAddress == null
            ? null
            : const ExampleAddressEntityConverter()
                .toJson(entity.billingAddress!),
      };
}
