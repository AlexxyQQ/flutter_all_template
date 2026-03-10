import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/common/presentation/views/components/app_color.dart';

part 'app_button_theme.freezed.dart';

@freezed
abstract class CustomButtonTheme with _$CustomButtonTheme {
  const factory CustomButtonTheme({
    KAppColor? backgroundColor,
    KAppColor? foregroundColor,
    KAppColor? backgroundDisabledColor,
    KAppColor? foregroundDisabledColor,
    KAppColor? labelColor,
    BorderRadius? radius,
    EdgeInsets? padding,
    @Default(false) bool? showBorder,
    BorderSide? border,
    KAppColor? loaderColor,
    @Default(false) bool? fixSize,
    @Default(false) bool? expanded,
    @Default(true) bool? translate,
  }) = _CustomButtonTheme;
}
