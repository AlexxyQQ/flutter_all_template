import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/constants/locales/app_locales.dart';
import '../../../../core/services/logger/data/app_logger.dart';
import '../../domain/usecases/set_locale_tag_use_case.dart';

part 'locale_state.dart';

/// Single source of truth for the app locale.
///
/// Starts with the locale bootstrap already resolved
/// (`AppLocales.resolveStart`) and persists user choices through
/// [SetLocaleTagUseCase] (EasyLocalization runs with `saveLocale: false`). The
/// widget tree mirrors [LocaleState.currentLocale] into EasyLocalization; the
/// cubit itself never touches a `BuildContext`.
@injectable
class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit({
    required SetLocaleTagUseCase setLocaleTag,
    @factoryParam required Locale startLocale,
  }) : _setLocaleTag = setLocaleTag,
       super(LocaleState(currentLocale: startLocale));

  final SetLocaleTagUseCase _setLocaleTag;

  Future<void> changeLocale({required Locale locale}) async {
    final supported = AppLocales.match(locale: locale);
    if (supported == null) {
      AppLogger.warning(
        'Unsupported locale ${locale.toLanguageTag()} ignored',
        name: 'LocaleCubit',
      );
      return;
    }
    emit(LocaleState(currentLocale: supported));
    final result = await _setLocaleTag(localeTag: supported.toLanguageTag());
    result.match(
      (failure) => AppLogger.warning(
        'Failed to persist locale (${failure.type.name})',
        name: 'LocaleCubit',
      ),
      (_) {},
    );
  }
}
