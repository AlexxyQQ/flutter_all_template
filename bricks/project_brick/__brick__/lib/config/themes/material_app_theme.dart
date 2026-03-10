import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../core/common/presentation/extensions/size/size_extension.dart';
import '../../core/common/presentation/extensions/theme/theme_extension.dart';

class MaterialAppTheme {
  static ThemeData getTheme({
    required ThemeMode theme,
    required BuildContext context,
  }) {
    final Brightness brightness;
    if (theme == ThemeMode.light) {
      brightness = Brightness.light;
    } else if (theme == ThemeMode.dark) {
      brightness = Brightness.dark;
    } else {
      brightness =
          SchedulerBinding.instance.platformDispatcher.platformBrightness;
    }

    return ThemeData(
      useMaterial3: true,

      // Backgrounds
      scaffoldBackgroundColor: context.colors.surface,
      canvasColor: context.colors.surfaceContainerLow,

      // Bridge the entire M3 ColorScheme manually
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: context.colors.primary,
        onPrimary: context.colors.onPrimary,
        primaryContainer: context.colors.primaryContainer,
        onPrimaryContainer: context.colors.onPrimaryContainer,
        secondary: context.colors.secondary,
        onSecondary: context.colors.onSecondary,
        secondaryContainer: context.colors.secondaryContainer,
        onSecondaryContainer: context.colors.onSecondaryContainer,
        tertiary: context.colors.tertiary,
        onTertiary: context.colors.onTertiary,
        tertiaryContainer: context.colors.tertiaryContainer,
        onTertiaryContainer: context.colors.onTertiaryContainer,
        error: context.colors.error,
        onError: context.colors.onError,
        errorContainer: context.colors.errorContainer,
        onErrorContainer: context.colors.onErrorContainer,
        surface: context.colors.surface,
        onSurface: context.colors.onSurface,
        surfaceContainerHighest:
            context.colors.surfaceContainerHigh, // M3 approximation
        onSurfaceVariant: context.colors.onSurfaceVariant,
        outline: context.colors.outline,
        outlineVariant: context.colors.outlineVariant,
        shadow: context.colors.shadow,
        scrim: context.colors.scrim,
        inverseSurface: context.colors.inverseSurface,
        onInverseSurface: context.colors.inverseOnSurface,
        inversePrimary: context.colors.inversePrimary,
        surfaceTint: context.colors.surfaceTint,
      ),

      // Component Overrides to ensure they use your Semantics
      appBarTheme: AppBarTheme(
        backgroundColor: context.colors.surface,
        foregroundColor: context.colors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),

      cardTheme: CardThemeData(
        color: context.colors.surfaceContainerLow,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: context.colors.outlineVariant),
          borderRadius: 12.borderCircular,
        ),
      ),

      dividerTheme: DividerThemeData(
        color: context.colors.outlineVariant,
        thickness: 1,
      ),

      textTheme: TextTheme(
        displayLarge: context.textStyles.displayLarge,
        displayMedium: context.textStyles.displayMedium,
        displaySmall: context.textStyles.displaySmall,
        headlineLarge: context.textStyles.headlineLarge,
        headlineMedium: context.textStyles.headlineMedium,
        headlineSmall: context.textStyles.headlineSmall,
        titleLarge: context.textStyles.titleLarge,
        titleMedium: context.textStyles.titleMedium,
        titleSmall: context.textStyles.titleSmall,
        bodyLarge: context.textStyles.bodyLarge,
        bodyMedium: context.textStyles.bodyMedium,
        bodySmall: context.textStyles.bodySmall,
        labelLarge: context.textStyles.labelLarge,
        labelMedium: context.textStyles.labelMedium,
        labelSmall: context.textStyles.labelSmall,
      ),
    );
  }
}
