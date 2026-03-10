import 'package:flutter/material.dart';

import '../../../../../../config/themes/components_theme/app_chip_theme.dart';
import '../../../../../../config/themes/components_theme/app_picture_theme.dart';
import '../../../extensions/size/size_extension.dart';
import '../../../extensions/theme/theme_extension.dart';
import '../../../themes/styles/app_chip_style.dart';
import '../../components/app_color.dart';
import 'icon/app_icon_widget.dart';
import 'images/app_svg_picture_widget.dart';
import 'text/app_text_widget.dart';

class AppChipWidget extends StatelessWidget {
  factory AppChipWidget.icon({
    required bool isSelected,
    required IconData selectedIcon,
    required IconData unselectedIcon,
    required VoidCallback onTap,
    required String title,
    CustomAppChipTheme? theme,
    Key? key,
  }) {
    return AppChipWidget._(
      key: key,
      isSelected: isSelected,
      selectedIcon: selectedIcon,
      unselectedIcon: unselectedIcon,
      onTap: onTap,
      title: title,
      theme: theme,
      noBlend: false,
    );
  }

  factory AppChipWidget.svg({
    required bool isSelected,
    required KAppColor color,
    required String selectedSvgAsset,
    required String unselectedSvgAsset,
    required VoidCallback onTap,
    required String title,
    CustomAppChipTheme? theme,
    bool noBlend = false,
    Key? key,
  }) {
    return AppChipWidget._(
      key: key,
      isSelected: isSelected,
      selectedSvgAsset: selectedSvgAsset,
      unselectedSvgAsset: unselectedSvgAsset,
      onTap: onTap,
      title: title,
      theme: theme,
      noBlend: noBlend,
    );
  }

  factory AppChipWidget.detail({
    required bool isSelected,
    required VoidCallback onTap,
    required String title,
    CustomAppChipTheme? theme,
    Key? key,
  }) {
    return AppChipWidget._(
      key: key,
      isSelected: isSelected,
      onTap: onTap,
      title: title,
      theme: theme,
      noBlend: false,
    );
  }

  const AppChipWidget._({
    required this.isSelected,
    required this.noBlend,
    required this.onTap,
    required this.title,
    super.key,
    this.theme,
    this.unselectedIcon,
    this.selectedIcon,
    this.selectedSvgAsset,
    this.unselectedSvgAsset,
  });

  final bool isSelected;
  final IconData? unselectedIcon;
  final IconData? selectedIcon;
  final String? selectedSvgAsset;
  final String? unselectedSvgAsset;
  final VoidCallback onTap;
  final String title;
  final bool noBlend;
  final CustomAppChipTheme? theme;

  @override
  Widget build(BuildContext context) {
    final CustomAppChipTheme effectiveTheme =
        theme ?? AppChipStyle.primaryTheme;

    final KAppColor effectiveTextColor = isSelected
        ? (effectiveTheme.selectedLabelColor)
        : (effectiveTheme.disabledLabelColor);

    final effectiveBorderColor = isSelected
        ? effectiveTheme.selectedColor
        : effectiveTheme.disabledColor;

    final effectiveBgColor = isSelected
        ? effectiveTheme.selectedColor.withValues(
            alpha: effectiveTheme.selectedBackgroundOpacity,
          )
        : effectiveTheme.disabledColor;

    final iconToUse = isSelected
        ? selectedIcon ?? unselectedIcon
        : unselectedIcon ?? selectedIcon;

    final svgToUse = isSelected
        ? selectedSvgAsset ?? unselectedSvgAsset
        : unselectedSvgAsset ?? selectedSvgAsset;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            effectiveTheme.padding ??
            (12.horizontalPadding + 8.verticalPadding),
        decoration: BoxDecoration(
          color: effectiveBgColor,
          borderRadius: effectiveTheme.borderRadius,
          border: effectiveTheme.border
              ? Border.all(color: effectiveBorderColor)
              : null,
        ),
        child: (svgToUse != null || iconToUse != null)
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (svgToUse != null)
                    AppSvgPicture.fromAsset(
                      svgToUse,
                      height: effectiveTheme.svgSize,
                      theme: (isSelected && noBlend)
                          ? null
                          : PictureTheme(color: effectiveTextColor),
                    )
                  else if (iconToUse != null)
                    AppIcon(
                      iconToUse,
                      size: effectiveTheme.iconSize,
                      color: effectiveTextColor,
                    ),
                  effectiveTheme.gap.horizontalGap,
                  Flexible(
                    child: AppText(
                      title,
                      style:
                          (effectiveTheme.labelStyle ??
                                  context.textStyles.labelSmall)
                              .copyWith(color: effectiveTextColor),
                    ),
                  ),
                ],
              )
            : AppText(
                title,
                style:
                    (effectiveTheme.labelStyle ?? context.textStyles.labelSmall)
                        .copyWith(color: effectiveTextColor),
              ),
      ),
    );
  }
}
