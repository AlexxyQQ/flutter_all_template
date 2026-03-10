// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppSetting _$AppSettingFromJson(Map<String, dynamic> json) => _AppSetting(
  hasOnboarded: json['has_onboarded'] as bool? ?? false,
  notification: json['notification'] as bool? ?? false,
  rememberUser: json['remember_user'] as bool? ?? true,
  loggedUser: json['logged_user'],
  theme:
      $enumDecodeNullable(_$ThemeModeEnumMap, json['theme']) ??
      ThemeMode.system,
  token: json['token'] as String?,
  refreshToken: json['refresh_token'] as String?,
  locale: json['locale'] == null
      ? AppLocales.en
      : const LocaleConverter().fromJson(json['locale'] as String?),
);

Map<String, dynamic> _$AppSettingToJson(_AppSetting instance) =>
    <String, dynamic>{
      'has_onboarded': instance.hasOnboarded,
      'notification': instance.notification,
      'remember_user': instance.rememberUser,
      'logged_user': instance.loggedUser,
      'theme': _$ThemeModeEnumMap[instance.theme]!,
      'token': instance.token,
      'refresh_token': instance.refreshToken,
      'locale': _$JsonConverterToJson<String?, Locale>(
        instance.locale,
        const LocaleConverter().toJson,
      ),
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
