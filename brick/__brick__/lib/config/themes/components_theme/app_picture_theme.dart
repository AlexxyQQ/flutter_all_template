import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/common/presentation/views/components/app_color.dart';

part 'app_picture_theme.freezed.dart';

@freezed
abstract class PictureTheme with _$PictureTheme {
  const factory PictureTheme({
    KAppColor? color,
    BoxFit? fit,
    Alignment? alignment,
    String? semanticsLabel,
    bool? matchTextDirection,
    KAppColor? backgroundColor,
    double? containerHeight,
    double? containerWidth,
    EdgeInsets? containerPadding,
    KAppColor? borderColor,
    double? borderWidth,
    BorderRadius? borderRadius,
    BoxShape? shape,
    TextStyle? altTextStyle,
  }) = _PictureTheme;
}
