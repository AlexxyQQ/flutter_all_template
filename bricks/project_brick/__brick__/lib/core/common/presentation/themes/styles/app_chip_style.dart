import '../../../../../config/constants/text/material/app_material_text_style.dart';
import '../../../../../config/themes/components_theme/app_chip_theme.dart';
import '../../extensions/size/size_extension.dart';
import '../colors/app_material_colors.dart';

class AppChipStyle {
  static CustomAppChipTheme get primaryTheme => CustomAppChipTheme(
    selectedColor: AppMaterialColors.primary,
    disabledColor: AppMaterialColors.onPrimaryFixedVariant, // M3 naming
    labelStyle: AppMaterialTextStyles.labelSmall,
    borderRadius: 12.borderCircular, // M3 uses 8 or 12 depending on type
    padding: 12.horizontalPadding + 8.verticalPadding, // M3 standard density
    selectedBackgroundOpacity: 1,
    disabledLabelColor: AppMaterialColors.onPrimary,
    selectedLabelColor: AppMaterialColors.onPrimary,
  );
  static CustomAppChipTheme get disabledTheme => CustomAppChipTheme(
    selectedColor: AppMaterialColors.primaryFixedDim,
    disabledColor: AppMaterialColors.onPrimaryFixedVariant, // M3 naming
    labelStyle: AppMaterialTextStyles.labelSmall,
    borderRadius: 12.borderCircular, // M3 uses 8 or 12 depending on type
    padding: 12.horizontalPadding + 8.verticalPadding, // M3 standard density
    selectedBackgroundOpacity: 1,
    disabledLabelColor: AppMaterialColors.onPrimary,
    selectedLabelColor: AppMaterialColors.onPrimary,
  );
}
