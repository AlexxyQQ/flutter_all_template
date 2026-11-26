import 'package:flutter/material.dart';

import 'app_material_text_primitives.dart';

/// Material 3 type scale for the app.
///
/// Sizes are logical pixels (no ScreenUtil `.sp`): the platform text scaler
/// (see `AppTextScaler.clamp`) is responsible for accessibility scaling, and
/// the theme can be built without a `ScreenUtilInit` ancestor (e.g. in tests).
///
/// Colours are intentionally omitted; [ThemeData] applies `onSurface` via
/// `Typography`/`TextTheme.apply`.
abstract final class AppMaterialTextStyles {
  /// Builds the app [TextTheme] using the families declared in
  /// [AppMaterialTextPrimitives]. Pass [useBrandFonts] = false to fall back to
  /// the platform font (no Google Fonts lookup), e.g. in tests.
  static TextTheme textTheme({bool useBrandFonts = true}) {
    final String? heading = useBrandFonts
        ? AppMaterialTextPrimitives.fontHeadings
        : null;
    final String? body = useBrandFonts
        ? AppMaterialTextPrimitives.fontBody
        : null;

    TextStyle style(
      String? family,
      double size,
      FontWeight weight,
      double height, [
      double letterSpacing = 0,
    ]) => TextStyle(
      fontFamily: family,
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
      leadingDistribution: TextLeadingDistribution.even,
    );

    const p = AppMaterialTextPrimitives.regular;
    const m = AppMaterialTextPrimitives.medium;

    return TextTheme(
      // Headings (Eczar)
      displayLarge: style(
        heading,
        AppMaterialTextPrimitives.s57,
        p,
        1.12,
        -0.25,
      ),
      displayMedium: style(heading, AppMaterialTextPrimitives.s45, p, 1.16),
      displaySmall: style(heading, AppMaterialTextPrimitives.s36, p, 1.22),
      headlineLarge: style(heading, AppMaterialTextPrimitives.s32, p, 1.25),
      headlineMedium: style(heading, AppMaterialTextPrimitives.s28, p, 1.29),
      headlineSmall: style(heading, AppMaterialTextPrimitives.s24, p, 1.33),
      titleLarge: style(heading, AppMaterialTextPrimitives.s22, m, 1.27),
      titleMedium: style(heading, AppMaterialTextPrimitives.s16, m, 1.5, 0.15),
      titleSmall: style(heading, AppMaterialTextPrimitives.s14, m, 1.43, 0.1),
      // Body & labels (Manrope)
      bodyLarge: style(body, AppMaterialTextPrimitives.s16, p, 1.5, 0.5),
      bodyMedium: style(body, AppMaterialTextPrimitives.s14, p, 1.43, 0.25),
      bodySmall: style(body, AppMaterialTextPrimitives.s12, p, 1.33, 0.4),
      labelLarge: style(body, AppMaterialTextPrimitives.s14, m, 1.43, 0.1),
      labelMedium: style(body, AppMaterialTextPrimitives.s12, m, 1.33, 0.5),
      labelSmall: style(body, AppMaterialTextPrimitives.s11, m, 1.45, 0.5),
    );
  }
}
