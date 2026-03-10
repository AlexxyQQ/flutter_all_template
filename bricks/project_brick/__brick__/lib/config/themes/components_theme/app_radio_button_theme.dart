import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/common/presentation/views/components/app_color.dart';

part 'app_radio_button_theme.freezed.dart';

@freezed
abstract class CustomRadioButtonTheme with _$CustomRadioButtonTheme {
  const factory CustomRadioButtonTheme({
    @Default(20) double indicatorHeight,
    @Default(20) double indicatorWidth,
    @Default(2) double selectedIndicatorPadding,
    @Default(8) double borderRadius,
    @Default(true) bool rightAligned,
    @Default(BoxShape.circle) BoxShape indicatorShape,
    double? indicatorBorder,
    EdgeInsets? contentPadding,
    KAppColor? selectedColor,
    KAppColor? unselectedColor,
    KAppColor? indicatorColor,
    KAppColor? fillColor,
    KAppColor? borderColor,
    TextStyle? labelStyle,
  }) = _CustomRadioButtonTheme;
}
