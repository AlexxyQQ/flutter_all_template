import 'package:flutter/material.dart';

import '../../../../../config/themes/components_theme/app_icon_theme.dart';
import '../../extensions/size/size_extension.dart';
import '../colors/app_material_colors.dart';

class AppIconStyles {
  static AppIconTheme getTheme(AppIconTheme? theme) {
    final defaultTheme = AppIconTheme(
      size: 24.0,
      isCircular: false,
      shape: BoxShape.circle,
      color: AppMaterialColors.onSurface, // Material Default
      containerPadding: 8.allPadding,
    );

    if (theme == null) return defaultTheme;

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
