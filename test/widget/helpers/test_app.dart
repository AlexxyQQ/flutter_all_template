import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
// ignore: implementation_imports
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_all_template/config/themes/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Loads the real `en-GB` translations so `.tr()` works without the
/// `EasyLocalization` widget (no SharedPreferences / asset bundle needed).
void loadTestTranslations() {
  GoogleFonts.config.allowRuntimeFetching = false;
  EasyLocalization.logger.enableBuildModes = [];
  final json =
      jsonDecode(File('assets/translations/en-GB.json').readAsStringSync())
          as Map<String, dynamic>;
  Localization.load(const Locale('en', 'GB'), translations: Translations(json));
}

ThemeData testTheme(Brightness brightness) => brightness == Brightness.dark
    ? AppTheme.dark(useBrandFonts: false)
    : AppTheme.light(useBrandFonts: false);

Widget _screenUtil(Widget Function() builder) => ScreenUtilInit(
  designSize: const Size(428, 926),
  builder: (_, _) => builder(),
);

/// Hosts [child] in a themed [MaterialApp] (logical size 428×926).
Widget themedApp(Widget child, {Brightness brightness = Brightness.light}) =>
    _screenUtil(
      () => MaterialApp(
        theme: testTheme(brightness),
        home: Scaffold(body: Center(child: child)),
      ),
    );

/// Hosts a router config in a themed [MaterialApp.router].
Widget themedRouterApp(
  RouterConfig<Object> config, {
  Brightness brightness = Brightness.light,
}) => _screenUtil(
  () => MaterialApp.router(theme: testTheme(brightness), routerConfig: config),
);
