import 'package:flutter/material.dart';

/// The app's Material 3 theme, built once and shared with widget tests so they
/// render what users see.
abstract final class AppTheme {
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.blue,
  );
}
