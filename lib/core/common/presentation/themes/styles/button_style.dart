import '../../../../../config/constants/colors/material/material_primitive_colors.dart';
import '../../../../../config/constants/text/material/app_material_text_style.dart';
import '../../../../../config/themes/components_theme/app_button_theme.dart';
import '../../../../../config/themes/components_theme/app_radio_button_theme.dart';
import '../../extensions/size/size_extension.dart';
import '../colors/app_material_colors.dart';

class ButtonStyles {
  /// Primary button theme
  static CustomButtonTheme get primaryTheme => CustomButtonTheme(
    backgroundColor: AppMaterialColors.primary,
    foregroundColor: AppMaterialColors.onPrimary,
    backgroundDisabledColor: AppMaterialColors.primaryFixedDim,
    foregroundDisabledColor: AppMaterialColors.outline,
    radius: 12.borderCircular,
    padding: 16.horizontalPadding + 12.verticalPadding,
    loaderColor: AppMaterialColors.onPrimary,
  );

  /// Secondary button theme
  static CustomButtonTheme get secondaryTheme => CustomButtonTheme(
    backgroundColor: AppMaterialColors.secondary,
    foregroundColor: AppMaterialColors.onSecondary,
    backgroundDisabledColor: AppMaterialColors.secondaryFixedDim,
    foregroundDisabledColor: AppMaterialColors.outline,
    radius: 12.borderCircular,
    padding: 8.verticalPadding + 16.horizontalPadding,
    loaderColor: AppMaterialColors.onSecondary,
  );

  /// Tertiary button theme
  static CustomButtonTheme get tertiaryTheme => CustomButtonTheme(
    backgroundColor: AppMaterialColors.tertiary,
    foregroundColor: AppMaterialColors.onTertiary,
    backgroundDisabledColor: AppMaterialColors.tertiaryFixedDim,
    foregroundDisabledColor: AppMaterialColors.outline,
    radius: 12.borderCircular,
    padding: 8.verticalPadding + 16.horizontalPadding,
    loaderColor: AppMaterialColors.onTertiary,
  );

  /// Stroke button theme
  static CustomButtonTheme get strokeTheme => CustomButtonTheme(
    backgroundColor: AppMaterialPrimitives.transparent,
    foregroundColor: AppMaterialColors.primary,
    backgroundDisabledColor: AppMaterialPrimitives.transparent,
    foregroundDisabledColor: AppMaterialColors.outline,
    radius: 12.borderCircular,
    padding: 16.horizontalPadding + 12.verticalPadding,
    showBorder: true,
    loaderColor: AppMaterialColors.primary,
  );

  /// Ghost button theme
  static CustomButtonTheme get ghostTheme => CustomButtonTheme(
    backgroundColor: AppMaterialPrimitives.transparent,
    foregroundColor: AppMaterialColors.primary,
    backgroundDisabledColor: AppMaterialPrimitives.transparent,
    foregroundDisabledColor: AppMaterialColors.outline,
    radius: 12.borderCircular,
    padding: 16.horizontalPadding + 12.verticalPadding,
    loaderColor: AppMaterialColors.primary,
  );

  // Destructive button theme
  static CustomButtonTheme get destructiveTheme => CustomButtonTheme(
    backgroundColor: AppMaterialColors.error,
    foregroundColor: AppMaterialColors.onError,
    backgroundDisabledColor: AppMaterialColors.errorContainer,
    foregroundDisabledColor: AppMaterialColors.outline,
    radius: 12.borderCircular,
    padding: 16.horizontalPadding + 12.verticalPadding,
    loaderColor: AppMaterialColors.onError,
  );

  static CustomRadioButtonTheme get radioButton => CustomRadioButtonTheme(
    indicatorColor: AppMaterialColors.primary,
    selectedColor: AppMaterialColors.primaryFixedDim,
    unselectedColor: AppMaterialColors.primaryFixed,
    borderColor: AppMaterialColors.scrim,
    fillColor: AppMaterialColors.surface,
    contentPadding: 10.verticalPadding + 10.horizontalPadding,
    selectedIndicatorPadding: 1,
    labelStyle: AppMaterialTextStyles.labelSmall,
  );

  /// Primary button theme
  static CustomButtonTheme get icon => CustomButtonTheme(
    backgroundColor: AppMaterialColors.primary,
    foregroundColor: AppMaterialColors.onSurface,
    backgroundDisabledColor: AppMaterialColors.primaryFixedDim,
    foregroundDisabledColor: AppMaterialColors.outline,
    radius: 12.borderCircular,
    padding: 16.horizontalPadding + 12.verticalPadding,
    expanded: true,
    loaderColor: AppMaterialColors.onSurface,
  );
}
