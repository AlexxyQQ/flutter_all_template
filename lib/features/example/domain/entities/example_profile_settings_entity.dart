import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../config/constants/enums/app_specifics/role.dart';
import 'example_address_entity.dart';

part 'example_profile_settings_entity.freezed.dart';

@freezed
abstract class ExampleProfileSettingsEntity
    with _$ExampleProfileSettingsEntity {
  const ExampleProfileSettingsEntity._();

  const factory ExampleProfileSettingsEntity({
    required Role userRole,
    @Default(Role.guest) Role fallbackRole,
    @Default(true) bool emailNotificationsEnabled,
    @Default(false) bool smsNotificationsEnabled,
    ExampleAddressEntity? billingAddress,
  }) = _ExampleProfileSettingsEntity;
}
