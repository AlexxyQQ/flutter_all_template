import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_icon_theme.freezed.dart';

@freezed
abstract class AppIconTheme with _$AppIconTheme {
  const factory AppIconTheme({
    Color? color,
    double? size,
    Color? backgroundColor,
    double? containerHeight,
    double? containerWidth,
    EdgeInsets? containerPadding,
    Color? borderColor,
    double? borderWidth,
    BorderRadius? borderRadius,
    BoxShape? shape,
    bool? isCircular,
  }) = _AppIconTheme;
}
