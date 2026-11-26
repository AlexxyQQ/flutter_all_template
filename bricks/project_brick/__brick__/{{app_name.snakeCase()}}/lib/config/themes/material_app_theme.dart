import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'app_theme.dart';

/// Backwards-compatible entry point used by `app.dart`.
///
/// Prefer [AppTheme.light] / [AppTheme.dark] directly.
abstract final class MaterialAppTheme {
  /// Returns the [ThemeData] for [theme]. [ThemeMode.system] resolves against
  /// the current platform brightness. [context] is unused (kept for source
  /// compatibility).
  static ThemeData getTheme({
    required ThemeMode theme,
    required BuildContext context,
  }) {
    return switch (theme) {
      ThemeMode.light => AppTheme.light(),
      ThemeMode.dark => AppTheme.dark(),
      ThemeMode.system => AppTheme.forBrightness(
        SchedulerBinding.instance.platformDispatcher.platformBrightness,
      ),
    };
  }
}
