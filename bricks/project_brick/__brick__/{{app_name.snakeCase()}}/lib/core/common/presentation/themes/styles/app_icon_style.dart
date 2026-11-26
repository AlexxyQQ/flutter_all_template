import 'package:flutter/material.dart';

import '../../../../../config/themes/components_theme/app_icon_theme.dart';
import '../../extensions/size/size_extension.dart';

abstract final class AppIconStyles {
  static AppIconTheme getTheme(AppIconTheme? theme, {required Color color}) {
    final defaultTheme = AppIconTheme(
      size: 24.0,
      isCircular: false,
      shape: BoxShape.circle,
      color: color,
      containerPadding: 8.allPadding,
    );

    if (theme == null) {
      return defaultTheme;
    }

    return defaultTheme.copyWith(
      color: theme.color,
      size: theme.size,
      backgroundColor: theme.backgroundColor,
      containerHeight: theme.containerHeight,
      containerWidth: theme.containerWidth,
      containerPadding: theme.containerPadding,
      borderColor: theme.borderColor,
      borderWidth: theme.borderWidth,
      borderRadius: theme.borderRadius,
      shape: theme.shape,
      isCircular: theme.isCircular,
    );
  }
}
