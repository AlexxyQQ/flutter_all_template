import 'package:json_annotation/json_annotation.dart';

@JsonEnum(alwaysCreate: true)
enum AppImageType {
  @JsonValue('asset')
  asset,

  @JsonValue('memory')
  memory,

  @JsonValue('file')
  file;

  static AppImageType fromString(String? value) =>
      AppImageType.values.firstWhere(
        (element) => element.name.toLowerCase() == value?.toLowerCase(),
        orElse: () => AppImageType.asset,
      );
}

class AppImageTypeConverter implements JsonConverter<AppImageType, String?> {
  const AppImageTypeConverter();

  @override
  AppImageType fromJson(String? json) {
    if (json == null) {
      return AppImageType.asset;
    }
    return AppImageType.values.firstWhere(
      (e) => e.name.toLowerCase() == json.toLowerCase(),
      orElse: () => AppImageType.asset,
    );
  }

  @override
  String? toJson(AppImageType object) {
    return object.name;
  }
}
