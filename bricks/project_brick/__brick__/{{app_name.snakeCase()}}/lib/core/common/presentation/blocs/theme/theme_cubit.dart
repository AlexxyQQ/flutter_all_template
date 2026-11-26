import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/services/logger/logger_service.dart';
import '../../../features/app_settings/domain/entities/app_preferences.dart';
import '../../../features/app_settings/domain/repositories/app_preferences_repository.dart';

part 'theme_state.dart';

/// Holds the user's [ThemeMode] only. Colours/text styles come from
/// `Theme.of(context)` (and its extensions); `MaterialApp` resolves
/// [ThemeMode.system] against the platform brightness itself, so no
/// `WidgetsBindingObserver` is needed.
@injectable
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(this._repository) : super(const ThemeState());

  final IAppPreferencesRepository _repository;

  /// Loads the saved preference. Never persists.
  Future<void> load() async {
    final saved = _repository.read().theme;
    emit(ThemeState(themeMode: _toThemeMode(saved), isInitialized: true));
  }

  Future<void> changeTheme(ThemeMode mode) async {
    emit(ThemeState(themeMode: mode, isInitialized: true));
    final result = await _repository.setTheme(_toPreference(mode));
    result.match(
      (failure) => AppLogger.warning(
        'Failed to persist theme (${failure.type.name})',
        name: 'ThemeCubit',
      ),
      (_) {},
    );
  }

  /// Switches between light and dark. From [ThemeMode.system] it switches to
  /// the opposite of [platformBrightness].
  Future<void> toggleTheme({Brightness? platformBrightness}) {
    final isDark = switch (state.themeMode) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system => platformBrightness == Brightness.dark,
    };
    return changeTheme(isDark ? ThemeMode.light : ThemeMode.dark);
  }

  static ThemeMode _toThemeMode(AppThemePreference preference) =>
      switch (preference) {
        AppThemePreference.system => ThemeMode.system,
        AppThemePreference.light => ThemeMode.light,
        AppThemePreference.dark => ThemeMode.dark,
      };

  static AppThemePreference _toPreference(ThemeMode mode) => switch (mode) {
    ThemeMode.system => AppThemePreference.system,
    ThemeMode.light => AppThemePreference.light,
    ThemeMode.dark => AppThemePreference.dark,
  };
}
