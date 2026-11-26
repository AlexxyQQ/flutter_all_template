import 'package:flutter/material.dart';

/// Non-nullable view over a [TextTheme].
///
/// [TextTheme] getters are nullable; the app theme always fills every slot,
/// so this wrapper lets widgets write `context.textStyles.bodyLarge.copyWith()`
/// without `!`. Falls back to an empty [TextStyle] for foreign themes.
@immutable
class AppTextStyles {
  const AppTextStyles(this.textTheme);

  final TextTheme textTheme;

  static const TextStyle _fallback = TextStyle();

  TextStyle get displayLarge => textTheme.displayLarge ?? _fallback;
  TextStyle get displayMedium => textTheme.displayMedium ?? _fallback;
  TextStyle get displaySmall => textTheme.displaySmall ?? _fallback;
  TextStyle get headlineLarge => textTheme.headlineLarge ?? _fallback;
  TextStyle get headlineMedium => textTheme.headlineMedium ?? _fallback;
  TextStyle get headlineSmall => textTheme.headlineSmall ?? _fallback;
  TextStyle get titleLarge => textTheme.titleLarge ?? _fallback;
  TextStyle get titleMedium => textTheme.titleMedium ?? _fallback;
  TextStyle get titleSmall => textTheme.titleSmall ?? _fallback;
  TextStyle get bodyLarge => textTheme.bodyLarge ?? _fallback;
  TextStyle get bodyMedium => textTheme.bodyMedium ?? _fallback;
  TextStyle get bodySmall => textTheme.bodySmall ?? _fallback;
  TextStyle get labelLarge => textTheme.labelLarge ?? _fallback;
  TextStyle get labelMedium => textTheme.labelMedium ?? _fallback;
  TextStyle get labelSmall => textTheme.labelSmall ?? _fallback;
}
