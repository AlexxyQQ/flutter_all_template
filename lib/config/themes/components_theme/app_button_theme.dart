import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_button_theme.freezed.dart';

@freezed
abstract class CustomButtonTheme with _$CustomButtonTheme {
  const factory CustomButtonTheme({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? backgroundDisabledColor,
    Color? foregroundDisabledColor,
    Color? labelColor,
    BorderRadius? radius,
    EdgeInsets? padding,
    @Default(false) bool? showBorder,
    BorderSide? border,
    Color? loaderColor,
    @Default(false) bool? fixSize,
    @Default(false) bool? expanded,
    @Default(true) bool? translate,
  }) = _CustomButtonTheme;
}
