import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/constants/colors/material/material_semantics.dart';
import '../../../../abstract/presentation/abstract_material_app_text_style.dart';
import '../../../../abstract/presentation/abstract_material_color_semantic.dart';
import '../../../data/models/helpers/model_conversion_helper.dart';
import '../../../features/app_settings/domain/repositories/app_setting_repository.dart';
import '../../../locator/service_locator.dart';
import '../../themes/colors/app_material_colors.dart';
import '../../themes/text/context_material_text_styles.dart';
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
    // 1. Determine the mode
    const ThemeMode mode = ThemeMode.system;

    // 2. Determine the colors based on the resolved mode
    final brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    final isDarkMode = mode == ThemeMode.system
        ? brightness == Brightness.dark
        : mode == ThemeMode.dark;

    final colors = isDarkMode
        ? MaterialDarkSemantic()
        : MaterialLightSemantic();

    // Keep the static AppMaterialColors API in sync
    AppMaterialColors.load(isDarkMode ? Brightness.dark : Brightness.light);

    return ThemeState(
      themeMode: mode,
      colors: colors,
      textStyles: ContextMaterialTextStyles(colors),
      isInitialized: true,
    );
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
    final Brightness resolvedBrightness;
    if (mode == ThemeMode.system) {
      resolvedBrightness =
          SchedulerBinding.instance.platformDispatcher.platformBrightness;
    } else {
      resolvedBrightness =
          mode == ThemeMode.dark ? Brightness.dark : Brightness.light;
    }

    final newColors = resolvedBrightness == Brightness.dark
        ? MaterialDarkSemantic()
        : MaterialLightSemantic();

    // Keep the static AppMaterialColors API in sync
    AppMaterialColors.load(resolvedBrightness);

    if (persist) {
      await sl<IAppSettingRepository>().updateSetting(
        data: (data) => data.copyWith(theme: mode),
      );
    }
    emit(
      ThemeState(
        themeMode: mode,
        colors: newColors,
        textStyles: ContextMaterialTextStyles(newColors),
        isInitialized: true,
      ),
    );
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
