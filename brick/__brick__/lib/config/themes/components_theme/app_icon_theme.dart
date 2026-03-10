import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/common/presentation/views/components/app_color.dart';

part 'app_icon_theme.freezed.dart';

@freezed
abstract class AppIconTheme with _$AppIconTheme {
  const factory AppIconTheme({
    KAppColor? color,
    double? size,
    KAppColor? backgroundColor,
    double? containerHeight,
    double? containerWidth,
    EdgeInsets? containerPadding,
    KAppColor? borderColor,
    double? borderWidth,
    BorderRadius? borderRadius,
    BoxShape? shape,
    bool? isCircular,
  }) = _AppIconTheme;
}
