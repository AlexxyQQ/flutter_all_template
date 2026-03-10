import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../../config/constants/locales/app_locales.dart';
import '../../../../data/models/helpers/model_annotation_helper.dart';

part 'app_setting.freezed.dart';
part 'app_setting.g.dart';

@freezed
abstract class AppSetting with _$AppSetting {
  const AppSetting._();

  @JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
  const factory AppSetting({
    @Default(false) bool hasOnboarded,
    @Default(false) bool notification,
    @Default(true) bool rememberUser,
    dynamic loggedUser,
    @Default(ThemeMode.system) ThemeMode theme,
    String? token,
    String? refreshToken,
    @LocaleConverter() @Default(AppLocales.en) Locale? locale,
  }) = _AppSetting;

  factory AppSetting.fromJson(Map<String, dynamic> json) =>
      _$AppSettingFromJson(json);
}
