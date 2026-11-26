import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_picture_theme.freezed.dart';

@freezed
abstract class PictureTheme with _$PictureTheme {
  const factory PictureTheme({
    Color? color,
    BoxFit? fit,
    Alignment? alignment,
    String? semanticsLabel,
    bool? matchTextDirection,
    Color? backgroundColor,
    double? containerHeight,
    double? containerWidth,
    EdgeInsets? containerPadding,
    Color? borderColor,
    double? borderWidth,
    BorderRadius? borderRadius,
    BoxShape? shape,
    TextStyle? altTextStyle,
  }) = _PictureTheme;
}
