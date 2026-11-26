import 'package:injectable/injectable.dart';

import '../../../../../../config/constants/type_defs/typedef.dart';
import '../../../../../error/guard.dart';
import '../../../../../storage/key_value_stores.dart';
import '../../domain/entities/app_preferences.dart';
import '../../domain/repositories/app_preferences_repository.dart';

@LazySingleton(as: IAppPreferencesRepository)
class AppPreferencesRepositoryImpl implements IAppPreferencesRepository {
  AppPreferencesRepositoryImpl({required PreferencesStore store})
    : _store = store;

  static const String localeKey = 'prefs.locale';
  static const String hasOnboardedKey = 'prefs.has_onboarded';

  final PreferencesStore _store;

  @override
  AppPreferences read() {
    try {
      final localeTag = _store.getString(localeKey);
      return AppPreferences(
        localeTag: localeTag == null || localeTag.isEmpty ? null : localeTag,
        hasOnboarded: _store.getBool(hasOnboardedKey) ?? false,
      );
    } catch (_) {
      return const AppPreferences();
    }
  }

  @override
  ResultVoid setLocaleTag({required String localeTag}) =>
      guard(() => _store.setString(localeKey, localeTag));

  @override
  ResultVoid setHasOnboarded({required bool value}) =>
      guard(() => _store.setBool(hasOnboardedKey, value: value));
}
