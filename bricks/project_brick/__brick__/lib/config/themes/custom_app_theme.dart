import 'package:flutter/material.dart';

import '../../core/common/presentation/themes/colors/app_custom_colors.dart';

class CustomAppTheme {
  // Pass the brightness and isDark flag explicitly from the Cubit/UI
  static ThemeData getTheme({
    required ThemeMode theme,
    required BuildContext context,
  }) {
    // 1. Sync your custom semantic system
    AppCustomColors.of(context);

    return ThemeData(
      // useMaterial3: true,

      // // Backgrounds
      // scaffoldBackgroundColor: context.colors.background,

      // // Component Overrides
      // appBarTheme: AppBarTheme(
      //   backgroundColor: context.colors.background,
      //   foregroundColor: context.colors.text,
      //   elevation: 0,
      //   scrolledUnderElevation: 0,
      // ),

      // cardTheme: CardThemeData(
      //   elevation: 0,
      //   shape: RoundedRectangleBorder(
      //     side: BorderSide(color: context.colors.border),
      //     borderRadius: BorderRadius.circular(12),
      //   ),
      // ),

      // dividerTheme: DividerThemeData(
      //   color: context.colors.border,
      //   thickness: 1,
      //   space: 1,
      // ),

      // textTheme: TextTheme(
      //   displayLarge: context.textStyles.h1,
      //   headlineMedium: context.textStyles.h2,
      //   titleMedium: context.textStyles.h3,
      //   bodyLarge: context.textStyles.body,
      //   bodyMedium: context.textStyles.bodySmall,
      //   labelLarge: context.textStyles.buttonMedium,
      // ),
    );
  }
}
