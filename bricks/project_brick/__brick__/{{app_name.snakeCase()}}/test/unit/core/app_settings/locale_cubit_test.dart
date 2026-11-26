import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_all_template/core/common/features/app_settings/data/repositories/app_preferences_repository_impl.dart';
import 'package:flutter_all_template/core/common/features/app_settings/domain/usecases/get_app_preferences_use_case.dart';
import 'package:flutter_all_template/core/common/features/app_settings/domain/usecases/set_locale_tag_use_case.dart';
import 'package:flutter_all_template/core/common/presentation/blocs/locale/locale_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/in_memory_preferences_store.dart';

const _en = Locale('en', 'GB');
const _ne = Locale('ne', 'NP');
const _supported = [_en, _ne];

void main() {
  late InMemoryPreferencesStore store;
  late AppPreferencesRepositoryImpl repository;

  setUp(() {
    store = InMemoryPreferencesStore();
    repository = AppPreferencesRepositoryImpl(store: store);
  });

  LocaleCubit build({Locale device = const Locale('fr', 'FR')}) => LocaleCubit(
    getPreferences: GetAppPreferencesUseCase(repository: repository),
    setLocaleTag: SetLocaleTagUseCase(repository: repository),
    supportedLocales: _supported,
    deviceLocale: () => device,
  );

  blocTest<LocaleCubit, LocaleState>(
    'first run uses the device locale when supported (no persist)',
    build: () => build(device: const Locale('ne')),
    act: (cubit) => cubit.load(),
    expect: () => const [LocaleState(currentLocale: _ne, isInitialized: true)],
    verify: (_) => expect(store.values, isEmpty),
  );

  blocTest<LocaleCubit, LocaleState>(
    'first run falls back to en-GB for an unsupported device locale',
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => const [LocaleState(isInitialized: true)],
  );

  blocTest<LocaleCubit, LocaleState>(
    'saved locale wins over the device locale',
    setUp: () => store.values[AppPreferencesRepositoryImpl.localeKey] = 'ne-NP',
    build: () => build(device: _en),
    act: (cubit) => cubit.load(),
    expect: () => const [LocaleState(currentLocale: _ne, isInitialized: true)],
  );

  blocTest<LocaleCubit, LocaleState>(
    'changeLocale persists the full tag including country code',
    build: build,
    act: (cubit) => cubit.changeLocale(_ne),
    expect: () => const [LocaleState(currentLocale: _ne, isInitialized: true)],
    verify: (_) => expect(repository.read().localeTag, 'ne-NP'),
  );

  blocTest<LocaleCubit, LocaleState>(
    'changeLocale ignores unsupported locales',
    build: build,
    act: (cubit) => cubit.changeLocale(const Locale('de')),
    expect: () => const <LocaleState>[],
  );

  group('localeFromTag', () {
    test('parses dash, underscore, language-only and script tags', () {
      expect(LocaleCubit.localeFromTag('en-GB'), _en);
      expect(LocaleCubit.localeFromTag('en_GB'), _en);
      expect(LocaleCubit.localeFromTag('ne'), const Locale('ne'));
      expect(
        LocaleCubit.localeFromTag('zh-Hant-TW'),
        const Locale.fromSubtags(
          languageCode: 'zh',
          scriptCode: 'Hant',
          countryCode: 'TW',
        ),
      );
    });

    test('round-trips with toLanguageTag', () {
      expect(LocaleCubit.localeFromTag(_ne.toLanguageTag()), _ne);
    });
  });
}
