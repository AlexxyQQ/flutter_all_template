import 'package:flutter/material.dart';

import '../../../../../config/themes/components_theme/app_chip_theme.dart';
import '../../extensions/size/size_extension.dart';
import '../../extensions/theme/theme_extension.dart';

/// Chip themes resolved from the ambient theme.
abstract final class AppChipStyle {
  static CustomAppChipTheme primary(BuildContext context) =>
      _build(context, selected: context.colors.primary);

  static CustomAppChipTheme disabled(BuildContext context) =>
      _build(context, selected: context.colors.primaryFixedDim);

  static CustomAppChipTheme _build(
    BuildContext context, {
    required Color selected,
  }) {
    final cs = context.colors;
    return CustomAppChipTheme(
      selectedColor: selected,
      disabledColor: cs.onPrimaryFixedVariant,
      labelStyle: context.textStyles.labelSmall,
      borderRadius: 12.borderCircular,
      padding: 12.horizontalPadding + 8.verticalPadding,
      selectedBackgroundOpacity: 1,
      disabledLabelColor: cs.onPrimary,
      selectedLabelColor: cs.onPrimary,
    );
  }
}
