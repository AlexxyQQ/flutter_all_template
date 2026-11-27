import 'package:flutter/widgets.dart';
import 'package:flutter_all_template/config/constants/locales/app_locales.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseTag', () {
    test('parses dash, underscore, language-only and script tags', () {
      expect(AppLocales.parseTag(tag: 'en-GB'), AppLocales.en);
      expect(AppLocales.parseTag(tag: 'en_GB'), AppLocales.en);
      expect(AppLocales.parseTag(tag: 'ne'), const Locale('ne'));
      expect(
        AppLocales.parseTag(tag: 'zh-Hant-TW'),
        const Locale.fromSubtags(
          languageCode: 'zh',
          scriptCode: 'Hant',
          countryCode: 'TW',
        ),
      );
    });

    test('round-trips with toLanguageTag', () {
      expect(
        AppLocales.parseTag(tag: AppLocales.ne.toLanguageTag()),
        AppLocales.ne,
      );
    });
  });

  group('match', () {
    test('prefers the exact language and country', () {
      expect(AppLocales.match(locale: const Locale('ne', 'NP')), AppLocales.ne);
    });

    test('falls back to the same language', () {
      expect(AppLocales.match(locale: const Locale('en', 'US')), AppLocales.en);
      expect(AppLocales.match(locale: const Locale('ne')), AppLocales.ne);
    });

    test('is null for an unsupported language', () {
      expect(AppLocales.match(locale: const Locale('fr', 'FR')), isNull);
    });
  });

  group('resolveStart', () {
    test('uses the device locale on first run when supported', () {
      expect(
        AppLocales.resolveStart(
          savedTag: null,
          deviceLocale: const Locale('ne'),
        ),
        AppLocales.ne,
      );
    });

    test('falls back for an unsupported device locale', () {
      expect(
        AppLocales.resolveStart(
          savedTag: null,
          deviceLocale: const Locale('fr', 'FR'),
        ),
        AppLocales.fallback,
      );
    });

    test('the saved locale wins over the device locale', () {
      expect(
        AppLocales.resolveStart(savedTag: 'ne-NP', deviceLocale: AppLocales.en),
        AppLocales.ne,
      );
    });

    test('an unsupported or empty saved tag is ignored', () {
      expect(
        AppLocales.resolveStart(savedTag: 'de-DE', deviceLocale: AppLocales.ne),
        AppLocales.ne,
      );
      expect(
        AppLocales.resolveStart(savedTag: '', deviceLocale: AppLocales.ne),
        AppLocales.ne,
      );
    });
  });
}
