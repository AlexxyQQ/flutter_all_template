import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../data/models/helpers/model_conversion_helper.dart';
import '../../../features/app_settings/domain/repositories/app_setting_repository.dart';
import '../../../locator/service_locator.dart';
part 'theme_state.dart';

@injectable
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(_initialState()) {
    // Initialize the observer and pass 'this' so it can call functions on the Cubit
    _observer = _ThemeLifecycleObserver(this);
    WidgetsBinding.instance.addObserver(_observer);
  }
  // We keep a reference to the observer to remove it later
  late final _ThemeLifecycleObserver _observer;

  static ThemeState _initialState() {
    return const ThemeState(themeMode: ThemeMode.system, isInitialized: true);
  }

  void getSavedTheme() async {
    final theme =
        (await sl<IAppSettingRepository>().getSetting().rightOrNull)?.theme;

    if (theme != null) {
      _updateState(theme);
    }
  }

  void changeTheme(ThemeMode mode) {
    _updateState(mode);
  }

  void toggleTheme() {
    _updateState(
      state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
    );
  }

  /// Called by the internal observer when system settings change
  void onSystemThemeChanged() {
    if (state.themeMode == ThemeMode.system) {
      _updateState(ThemeMode.system, persist: false);
    }
  }

  void _updateState(ThemeMode mode, {bool persist = true}) async {
    if (persist) {
      await sl<IAppSettingRepository>().updateSetting(
        data: (data) => data.copyWith(theme: mode),
      );
    }
    emit(ThemeState(themeMode: mode, isInitialized: true));
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(_observer);
    return super.close();
  }
}

// --- PRIVATE HELPER CLASS ---
// This isolates the Flutter bindings from your Cubit logic
class _ThemeLifecycleObserver with WidgetsBindingObserver {
  _ThemeLifecycleObserver(this._cubit);
  final ThemeCubit _cubit;

  @override
  void didChangePlatformBrightness() {
    _cubit.onSystemThemeChanged();
  }
}
