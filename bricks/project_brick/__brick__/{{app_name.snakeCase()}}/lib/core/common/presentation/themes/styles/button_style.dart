import 'package:flutter/material.dart';

import '../../../../../config/themes/components_theme/app_button_theme.dart';
import '../../../../../config/themes/components_theme/app_radio_button_theme.dart';
import '../../extensions/size/size_extension.dart';

/// Visual variants supported by `AppButton`.
enum ButtonVariant { primary, secondary, tertiary, stroke, ghost, destructive }

/// Resolves [CustomButtonTheme]s from the active [ColorScheme].
///
/// Everything is a pure function of the scheme, so light/dark switches and
/// local `Theme` overrides are picked up automatically.
abstract final class ButtonStyles {
  static CustomButtonTheme of(ButtonVariant variant, ColorScheme cs) {
    final radius = 12.borderCircular;
    final padding = 16.horizontalPadding + 12.verticalPadding;
    return switch (variant) {
      ButtonVariant.primary => _filled(
        cs.primary,
        cs.onPrimary,
        cs.primaryFixedDim,
        cs,
        radius,
        padding,
      ),
      ButtonVariant.secondary => _filled(
        cs.secondary,
        cs.onSecondary,
        cs.secondaryFixedDim,
        cs,
        radius,
        padding,
      ),
      ButtonVariant.tertiary => _filled(
        cs.tertiary,
        cs.onTertiary,
        cs.tertiaryFixedDim,
        cs,
        radius,
        padding,
      ),
      ButtonVariant.destructive => _filled(
        cs.error,
        cs.onError,
        cs.errorContainer,
        cs,
        radius,
        padding,
      ),
      ButtonVariant.stroke => CustomButtonTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: cs.primary,
        backgroundDisabledColor: Colors.transparent,
        foregroundDisabledColor: cs.outline,
        radius: radius,
        padding: padding,
        showBorder: true,
        loaderColor: cs.primary,
      ),
      ButtonVariant.ghost => CustomButtonTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: cs.primary,
        backgroundDisabledColor: Colors.transparent,
        foregroundDisabledColor: cs.outline,
        radius: radius,
        padding: padding,
        loaderColor: cs.primary,
      ),
    };
  }

  static CustomButtonTheme _filled(
    Color background,
    Color foreground,
    Color disabledBackground,
    ColorScheme cs,
    BorderRadius radius,
    EdgeInsets padding,
  ) => CustomButtonTheme(
    backgroundColor: background,
    foregroundColor: foreground,
    backgroundDisabledColor: disabledBackground,
    foregroundDisabledColor: cs.outline,
    radius: radius,
    padding: padding,
    loaderColor: foreground,
  );

  static CustomButtonTheme primary(ColorScheme cs) =>
      of(ButtonVariant.primary, cs);
  static CustomButtonTheme secondary(ColorScheme cs) =>
      of(ButtonVariant.secondary, cs);
  static CustomButtonTheme tertiary(ColorScheme cs) =>
      of(ButtonVariant.tertiary, cs);
  static CustomButtonTheme stroke(ColorScheme cs) =>
      of(ButtonVariant.stroke, cs);
  static CustomButtonTheme ghost(ColorScheme cs) => of(ButtonVariant.ghost, cs);
  static CustomButtonTheme destructive(ColorScheme cs) =>
      of(ButtonVariant.destructive, cs);

  static CustomRadioButtonTheme radioButton(
    ColorScheme cs, {
    TextStyle? labelStyle,
  }) => CustomRadioButtonTheme(
    indicatorColor: cs.primary,
    selectedColor: cs.primaryFixedDim,
    unselectedColor: cs.primaryFixed,
    borderColor: cs.scrim,
    fillColor: cs.surface,
    contentPadding: 10.verticalPadding + 10.horizontalPadding,
    selectedIndicatorPadding: 1,
    labelStyle: labelStyle,
  );
}
