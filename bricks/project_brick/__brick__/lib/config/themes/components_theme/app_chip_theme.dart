import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/common/presentation/views/components/app_color.dart';
part 'app_chip_theme.freezed.dart';

@freezed
abstract class CustomAppChipTheme with _$CustomAppChipTheme {
  const factory CustomAppChipTheme({
    required KAppColor disabledColor,
    required KAppColor selectedColor,
    required KAppColor selectedLabelColor,
    required KAppColor disabledLabelColor,
    TextStyle? labelStyle,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    @Default(0.2) double selectedBackgroundOpacity,
    @Default(24.0) double iconSize,
    @Default(20.0) double svgSize,
    @Default(8.0) double gap,
    @Default(false) bool border,
  }) = _CustomAppChipTheme;

  const CustomAppChipTheme._();
}
