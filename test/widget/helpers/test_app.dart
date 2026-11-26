import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
// ignore: implementation_imports
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/material.dart';

/// Loads the real `en-GB` translations so `.tr()` works without the
/// `EasyLocalization` widget (no SharedPreferences / asset bundle needed).
void loadTestTranslations() {
  EasyLocalization.logger.enableBuildModes = [];
  final json =
      jsonDecode(File('assets/translations/en-GB.json').readAsStringSync())
          as Map<String, dynamic>;
  Localization.load(const Locale('en', 'GB'), translations: Translations(json));
}

/// Hosts a router config in a [MaterialApp.router] with the default theme.
Widget routerApp(RouterConfig<Object> config) => MaterialApp.router(
  theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
  routerConfig: config,
);
