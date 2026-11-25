import 'package:flutter/material.dart';

import '../constants/colors/material/material_semantics.dart';
import '../constants/text/material/app_material_text_style.dart';
import 'app_tokens.dart';

/// The single source of truth for the app's [ThemeData].
///
/// * Colours: Material 3 [ColorScheme] from [AppColorSchemes].
/// * Extra semantic colours (success, warning, …): [AppTokens] extension.
/// * Typography: [AppMaterialTextStyles.textTheme].
///
/// Pure functions of their inputs — no global state, no `BuildContext`.
abstract final class AppTheme {
  static ThemeData light({bool useBrandFonts = true}) => build(
    colorScheme: AppColorSchemes.light,
    tokens: AppTokens.light,
    useBrandFonts: useBrandFonts,
  );

  static ThemeData dark({bool useBrandFonts = true}) => build(
    colorScheme: AppColorSchemes.dark,
    tokens: AppTokens.dark,
    useBrandFonts: useBrandFonts,
  );

  static ThemeData forBrightness(
    Brightness brightness, {
    bool useBrandFonts = true,
  }) => brightness == Brightness.dark
      ? dark(useBrandFonts: useBrandFonts)
      : light(useBrandFonts: useBrandFonts);

  static ThemeData build({
    required ColorScheme colorScheme,
    required AppTokens tokens,
    bool useBrandFonts = true,
  }) {
    final textTheme =
        AppMaterialTextStyles.textTheme(useBrandFonts: useBrandFonts).apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        );
    const radius = BorderRadius.all(Radius.circular(12));

    return ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface,
      canvasColor: colorScheme.surfaceContainerLow,
      extensions: <ThemeExtension<dynamic>>[tokens],
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerLow,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: colorScheme.outlineVariant),
          borderRadius: radius,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        shape: const RoundedRectangleBorder(borderRadius: radius),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        showDragHandle: true,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        shape: const RoundedRectangleBorder(borderRadius: radius),
      ),
    );
  }
}
