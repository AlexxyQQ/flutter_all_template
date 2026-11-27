import 'package:flutter/widgets.dart';

/// The locales the app ships and the one place locale tags are parsed and
/// matched.
abstract final class AppLocales {
  static const Locale en = Locale('en', 'GB');
  static const Locale ne = Locale('ne', 'NP');

  /// Add a locale here, to `assets/translations/` and to the platform
  /// configuration (`ios/Runner/Info.plist` `CFBundleLocalizations`).
  static const List<Locale> appLocales = [en, ne];

  /// Used when neither the saved nor the device locale is supported.
  static const Locale fallback = en;

  /// Parses `en-GB`, `en_GB`, `en` and `zh-Hant-TW`.
  static Locale parseTag({required String tag}) {
    final parts = tag.split(RegExp('[-_]'));
    String? script;
    String? country;
    for (final part in parts.skip(1)) {
      if (part.length == 4) {
        script = part;
      } else if (part.isNotEmpty) {
        country = part;
      }
    }
    return Locale.fromSubtags(
      languageCode: parts.first,
      scriptCode: script,
      countryCode: country,
    );
  }

  /// The supported locale for [locale]: exact language + country first, then
  /// the same language; `null` when the language is not supported.
  static Locale? match({required Locale locale}) {
    for (final supported in appLocales) {
      if (supported.languageCode == locale.languageCode &&
          supported.countryCode == locale.countryCode) {
        return supported;
      }
    }
    for (final supported in appLocales) {
      if (supported.languageCode == locale.languageCode) {
        return supported;
      }
    }
    return null;
  }

  /// The locale to start with: the saved one, else the device locale if
  /// supported, else [fallback]. Resolved once, in bootstrap; the device
  /// locale is not a user choice, so nothing is persisted here.
  static Locale resolveStart({
    required String? savedTag,
    required Locale deviceLocale,
  }) {
    if (savedTag != null && savedTag.isNotEmpty) {
      final saved = match(locale: parseTag(tag: savedTag));
      if (saved != null) {
        return saved;
      }
    }
    return match(locale: deviceLocale) ?? fallback;
  }
}
