import 'package:flutter/material.dart';

import '../gen/locale_keys.g.dart';

class AppLocales {
  static const en = Locale('en', 'GB');
  static const ne = Locale('ne', 'NP');
  // static const es = Locale('es', 'ES');

  static List<String> appLocalesNames = [
    LocaleKeys.common_languages_english,
    LocaleKeys.common_languages_nepali,
    // LocaleKeys.common_languages_spanish,
  ];

  static List<Locale> appLocales = [en, ne];

  static Locale fromString({required String languageCode}) {
    switch (languageCode) {
      case 'en':
        return en;
      case 'ne':
        return ne;
      default:
        return en;
    }
  }
}
