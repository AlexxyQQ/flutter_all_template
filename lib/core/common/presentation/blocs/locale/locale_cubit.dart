import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/constants/locales/app_locales.dart';
import '../../../domain/services/logger/logger_service.dart';
import '../../../features/app_settings/domain/repositories/app_preferences_repository.dart';

part 'locale_state.dart';

/// Single source of truth for the app locale.
///
/// Persisted through [IAppPreferencesRepository] (EasyLocalization runs with
/// `saveLocale: false`). The widget tree mirrors [LocaleState.currentLocale]
/// into EasyLocalization; the cubit itself never touches a `BuildContext`.
@injectable
class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit(
    this._repository, {
    @ignoreParam List<Locale>? supportedLocales,
    @ignoreParam Locale Function()? deviceLocale,
  }) : _supportedLocales = supportedLocales ?? AppLocales.appLocales,
       _deviceLocale =
           deviceLocale ?? (() => PlatformDispatcher.instance.locale),
       super(const LocaleState());

  final IAppPreferencesRepository _repository;
  final List<Locale> _supportedLocales;
  final Locale Function() _deviceLocale;

  /// Saved locale, else the device locale if supported, else the fallback.
  /// Never persists (the device locale is not a user choice).
  Future<void> load() async {
    final locale = resolveStartLocale(
      savedTag: _repository.read().localeTag,
      deviceLocale: _deviceLocale(),
      supportedLocales: _supportedLocales,
    );
    emit(LocaleState(currentLocale: locale, isInitialized: true));
  }

  Future<void> changeLocale(Locale locale) async {
    final supported = _match(locale, _supportedLocales);
    if (supported == null) {
      AppLogger.warning(
        'Unsupported locale ${locale.toLanguageTag()} ignored',
        name: 'LocaleCubit',
      );
      return;
    }
    emit(LocaleState(currentLocale: supported, isInitialized: true));
    final result = await _repository.setLocaleTag(supported.toLanguageTag());
    result.match(
      (failure) => AppLogger.warning(
        'Failed to persist locale (${failure.type.name})',
        name: 'LocaleCubit',
      ),
      (_) {},
    );
  }

  /// Pure resolution logic, shared with bootstrap (`startLocale`).
  static Locale resolveStartLocale({
    required String? savedTag,
    required Locale deviceLocale,
    required List<Locale> supportedLocales,
    Locale fallback = AppLocales.en,
  }) {
    if (savedTag != null && savedTag.isNotEmpty) {
      final saved = _match(localeFromTag(savedTag), supportedLocales);
      if (saved != null) {
        return saved;
      }
    }
    return _match(deviceLocale, supportedLocales) ?? fallback;
  }

  /// Parses `en-GB`, `en_GB`, `en` and `zh-Hant-TW`.
  static Locale localeFromTag(String tag) {
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

  /// Exact language+country match first, then same language code.
  static Locale? _match(Locale locale, List<Locale> supported) {
    for (final s in supported) {
      if (s.languageCode == locale.languageCode &&
          s.countryCode == locale.countryCode) {
        return s;
      }
    }
    for (final s in supported) {
      if (s.languageCode == locale.languageCode) {
        return s;
      }
    }
    return null;
  }
}
