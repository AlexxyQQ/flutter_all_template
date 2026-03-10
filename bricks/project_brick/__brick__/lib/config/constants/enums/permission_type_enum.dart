import 'package:json_annotation/json_annotation.dart';

@JsonEnum(alwaysCreate: true)
enum PermissionTypeEnum {
  @JsonValue('notification')
  notification,

  @JsonValue('location')
  location,

  @JsonValue('camera')
  camera,

  @JsonValue('storage')
  storage;

  static PermissionTypeEnum fromString(String? value) =>
      PermissionTypeEnum.values.firstWhere(
        (element) => element.name.toLowerCase() == value?.toLowerCase(),
        orElse: () => PermissionTypeEnum.notification,
      );
}

class PermissionTypeEnumConverter
    implements JsonConverter<PermissionTypeEnum, String?> {
  const PermissionTypeEnumConverter();

  @override
  PermissionTypeEnum fromJson(String? json) {
    if (json == null) {
      return PermissionTypeEnum.notification;
    }
    return PermissionTypeEnum.values.firstWhere(
      (e) => e.name.toLowerCase() == json.toLowerCase(),
      orElse: () => PermissionTypeEnum.notification,
    );
  }

  @override
  String? toJson(PermissionTypeEnum object) {
    return object.name;
  }
}
