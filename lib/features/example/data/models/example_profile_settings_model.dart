import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../config/constants/enums/app_specifics/role.dart';
import '../../domain/entities/example_profile_settings_entity.dart';
import 'example_address_model.dart';

// TODO: Ensure all nested models are imported here

part 'example_profile_settings_model.freezed.dart';
part 'example_profile_settings_model.g.dart';

@freezed
abstract class ExampleProfileSettingsModel with _$ExampleProfileSettingsModel {
  const ExampleProfileSettingsModel._();

  @JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
  const factory ExampleProfileSettingsModel({
    @RoleConverter() required Role userRole,
    @RoleConverter() @Default(Role.guest) Role fallbackRole,
    @Default(true) bool emailNotificationsEnabled,
    @Default(false) bool smsNotificationsEnabled,
    ExampleAddressModel? billingAddress,
  }) = _ExampleProfileSettingsModel;

  factory ExampleProfileSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$ExampleProfileSettingsModelFromJson(json);
}

// -----------------------------------------------------------------------------
// MODEL -> ENTITY
// -----------------------------------------------------------------------------
extension ExampleProfileSettingsModelMapper on ExampleProfileSettingsModel {
  ExampleProfileSettingsEntity toEntity() {
    return ExampleProfileSettingsEntity(
      userRole: userRole,
      fallbackRole: fallbackRole,
      emailNotificationsEnabled: emailNotificationsEnabled,
      smsNotificationsEnabled: smsNotificationsEnabled,
      billingAddress: billingAddress?.toEntity(),
    );
  }
}

// -----------------------------------------------------------------------------
// ENTITY -> MODEL
// -----------------------------------------------------------------------------
extension ExampleProfileSettingsEntityMapper on ExampleProfileSettingsEntity {
  ExampleProfileSettingsModel toModel() {
    return ExampleProfileSettingsModel(
      userRole: userRole,
      fallbackRole: fallbackRole,
      emailNotificationsEnabled: emailNotificationsEnabled,
      smsNotificationsEnabled: smsNotificationsEnabled,
      billingAddress: billingAddress?.toModel(),
    );
  }
}

// -----------------------------------------------------------------------------
// HELPER LIST MAPPERS
// -----------------------------------------------------------------------------
extension ExampleProfileSettingsModelListMapper
    on List<ExampleProfileSettingsModel> {
  List<ExampleProfileSettingsEntity> toEntities() =>
      map((e) => e.toEntity()).toList();
}

extension ExampleProfileSettingsEntityListMapper
    on List<ExampleProfileSettingsEntity> {
  List<ExampleProfileSettingsModel> toModels() =>
      map((e) => e.toModel()).toList();
}
