import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_all_template/config/constants/locales/app_locales.dart';
import 'package:flutter_all_template/features/app_settings/data/repositories/app_preferences_repository_impl.dart';
import 'package:flutter_all_template/features/app_settings/domain/usecases/set_locale_tag_use_case.dart';
import 'package:flutter_all_template/features/app_settings/presentation/bloc/locale_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/in_memory_preferences_store.dart';

void main() {
  late InMemoryPreferencesStore store;
  late AppPreferencesRepositoryImpl repository;

  setUp(() {
    store = InMemoryPreferencesStore();
    repository = AppPreferencesRepositoryImpl(store: store);
  });

  LocaleCubit build({Locale start = AppLocales.en}) => LocaleCubit(
    setLocaleTag: SetLocaleTagUseCase(repository: repository),
    startLocale: start,
  );

  test('starts with the locale bootstrap resolved, without persisting', () {
    final cubit = build(start: AppLocales.ne);

    expect(cubit.state.currentLocale, AppLocales.ne);
    expect(store.values, isEmpty);
  });

  blocTest<LocaleCubit, LocaleState>(
    'changeLocale persists the full tag including country code',
    build: build,
    act: (cubit) => cubit.changeLocale(locale: AppLocales.ne),
    expect: () => const [LocaleState(currentLocale: AppLocales.ne)],
    verify: (_) => expect(repository.read().localeTag, 'ne-NP'),
  );

  blocTest<LocaleCubit, LocaleState>(
    'changeLocale maps a regional variant to the supported locale',
    build: build,
    act: (cubit) => cubit.changeLocale(locale: const Locale('ne')),
    expect: () => const [LocaleState(currentLocale: AppLocales.ne)],
  );

  blocTest<LocaleCubit, LocaleState>(
    'changeLocale ignores unsupported locales',
    build: build,
    act: (cubit) => cubit.changeLocale(locale: const Locale('de')),
    expect: () => const <LocaleState>[],
    verify: (_) => expect(store.values, isEmpty),
  );
}
