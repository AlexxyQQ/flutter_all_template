import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/constants/locales/app_locales.dart';
import '../../../data/models/helpers/model_conversion_helper.dart';
import '../../../features/app_settings/domain/repositories/app_setting_repository.dart';
import '../../../features/app_settings/domain/services/cache/app_setting_cache.dart';
import '../../../locator/service_locator.dart';
part 'locale_state.dart';

@injectable
class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(_initialState());

  static LocaleState _initialState() {
    // Check for saved theme
    final savedLocale = sl<AppSettingCache>().getSync()?.locale;
    if (savedLocale != null) {
      return LocaleState(currentLocale: savedLocale, isInitialized: true);
    } else {
      return const LocaleState(isInitialized: true);
    }
  }

  void changeLocale(Locale locale) {
    _updateState(locale);
  }

  void getSavedLocale({required BuildContext context}) async {
    final savedLocale =
        (await sl<IAppSettingRepository>().getSetting().rightOrNull)?.locale;

    if (savedLocale != null) {
      // Sync with EasyLocalization
      if (context.mounted) {
        context.setLocale(savedLocale);
      }
      _updateState(savedLocale);
    } else {
      // Mark initialized even if we stick to default
      emit(
        LocaleState(currentLocale: state.currentLocale, isInitialized: true),
      );
    }
  }

  void _updateState(Locale locale) async {
    await sl<IAppSettingRepository>().updateSetting(
      data: (data) => data.copyWith(locale: locale),
    );
    emit(LocaleState(currentLocale: locale, isInitialized: true));
  }
}
