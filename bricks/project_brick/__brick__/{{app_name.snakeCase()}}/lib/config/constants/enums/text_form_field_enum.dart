import 'package:json_annotation/json_annotation.dart';

@JsonEnum(alwaysCreate: true)
enum AppInputTypeEnum {
  @JsonValue('text')
  text,

  @JsonValue('password')
  password,

  @JsonValue('search')
  search,

  @JsonValue('datePicker')
  datePicker,

  @JsonValue('dateRangePicker')
  dateRangePicker,

  @JsonValue('timePicker')
  timePicker,

  @JsonValue('number')
  number,

  @JsonValue('phone')
  phone,

  @JsonValue('email')
  email,

  @JsonValue('multiline')
  multiline;

  static AppInputTypeEnum fromString(String? value) =>
      AppInputTypeEnum.values.firstWhere(
        (element) => element.name.toLowerCase() == value?.toLowerCase(),
        orElse: () => AppInputTypeEnum.text,
      );
}

class AppInputTypeEnumConverter
    implements JsonConverter<AppInputTypeEnum, String?> {
  const AppInputTypeEnumConverter();

  @override
  AppInputTypeEnum fromJson(String? json) {
    if (json == null) {
      return AppInputTypeEnum.text;
    }
    return AppInputTypeEnum.values.firstWhere(
      (e) => e.name.toLowerCase() == json.toLowerCase(),
      orElse: () => AppInputTypeEnum.text,
    );
  }

  @override
  String? toJson(AppInputTypeEnum object) {
    return object.name;
  }
}
