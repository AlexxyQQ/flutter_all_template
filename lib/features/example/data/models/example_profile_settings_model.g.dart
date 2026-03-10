// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example_profile_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExampleProfileSettingsModel _$ExampleProfileSettingsModelFromJson(
  Map<String, dynamic> json,
) => _ExampleProfileSettingsModel(
  userRole: const RoleConverter().fromJson(json['user_role'] as String?),
  fallbackRole: json['fallback_role'] == null
      ? Role.guest
      : const RoleConverter().fromJson(json['fallback_role'] as String?),
  emailNotificationsEnabled:
      json['email_notifications_enabled'] as bool? ?? true,
  smsNotificationsEnabled: json['sms_notifications_enabled'] as bool? ?? false,
  billingAddress: json['billing_address'] == null
      ? null
      : ExampleAddressModel.fromJson(
          json['billing_address'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$ExampleProfileSettingsModelToJson(
  _ExampleProfileSettingsModel instance,
) => <String, dynamic>{
  'user_role': const RoleConverter().toJson(instance.userRole),
  'fallback_role': const RoleConverter().toJson(instance.fallbackRole),
  'email_notifications_enabled': instance.emailNotificationsEnabled,
  'sms_notifications_enabled': instance.smsNotificationsEnabled,
  'billing_address': instance.billingAddress?.toJson(),
};
