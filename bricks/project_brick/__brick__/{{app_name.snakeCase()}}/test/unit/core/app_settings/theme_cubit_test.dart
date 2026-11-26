import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_all_template/core/common/features/app_settings/data/repositories/app_preferences_repository_impl.dart';
import 'package:flutter_all_template/core/common/features/app_settings/domain/entities/app_preferences.dart';
import 'package:flutter_all_template/core/common/presentation/blocs/theme/theme_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/in_memory_preferences_store.dart';

void main() {
  late InMemoryPreferencesStore store;
  late AppPreferencesRepositoryImpl repository;

  setUp(() {
    store = InMemoryPreferencesStore();
    repository = AppPreferencesRepositoryImpl(store);
  });

  test('initial state is system and not initialized', () {
    expect(ThemeCubit(repository).state, const ThemeState());
  });

  blocTest<ThemeCubit, ThemeState>(
    'load emits the saved mode without persisting',
    setUp: () => store.values[AppPreferencesRepositoryImpl.themeKey] = 'dark',
    build: () => ThemeCubit(repository),
    act: (cubit) => cubit.load(),
    expect: () => const [
      ThemeState(themeMode: ThemeMode.dark, isInitialized: true),
    ],
  );

  blocTest<ThemeCubit, ThemeState>(
    'changeTheme emits and persists',
    build: () => ThemeCubit(repository),
    act: (cubit) => cubit.changeTheme(ThemeMode.light),
    expect: () => const [
      ThemeState(themeMode: ThemeMode.light, isInitialized: true),
    ],
    verify: (_) => expect(repository.read().theme, AppThemePreference.light),
  );

  blocTest<ThemeCubit, ThemeState>(
    'changeTheme still emits when persisting fails',
    setUp: () => store.failWrites = true,
    build: () => ThemeCubit(repository),
    act: (cubit) => cubit.changeTheme(ThemeMode.dark),
    expect: () => const [
      ThemeState(themeMode: ThemeMode.dark, isInitialized: true),
    ],
  );

  blocTest<ThemeCubit, ThemeState>(
    'toggleTheme from system uses the platform brightness',
    build: () => ThemeCubit(repository),
    act: (cubit) => cubit.toggleTheme(platformBrightness: Brightness.dark),
    expect: () => const [
      ThemeState(themeMode: ThemeMode.light, isInitialized: true),
    ],
  );
}
