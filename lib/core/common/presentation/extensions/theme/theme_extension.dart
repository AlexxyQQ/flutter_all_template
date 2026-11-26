import 'package:flutter/material.dart';

import '../../../../../config/themes/app_tokens.dart';
import '../../themes/text/app_text_styles.dart';

/// Theme access for widgets. Everything resolves from the nearest [Theme], so
/// light/dark switches and `Theme(...)` overrides work without any global or
/// bloc state.
extension ThemeContext on BuildContext {
  ThemeData get theme => Theme.of(this);

  /// Material 3 colour roles (`primary`, `onSurface`, `surfaceContainerHigh`…).
  ColorScheme get colors => Theme.of(this).colorScheme;

  /// Type scale with non-nullable getters.
  AppTextStyles get textStyles => AppTextStyles(Theme.of(this).textTheme);

  /// App-specific semantic colours (success, warning, info, …).
  ///
  /// Falls back to [AppTokens.light]/[AppTokens.dark] if the current theme was
  /// not built by `AppTheme` (e.g. a bare `MaterialApp` in a test).
  AppTokens get tokens {
    final theme = Theme.of(this);
    return theme.extension<AppTokens>() ??
        (theme.brightness == Brightness.dark
            ? AppTokens.dark
            : AppTokens.light);
  }

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
