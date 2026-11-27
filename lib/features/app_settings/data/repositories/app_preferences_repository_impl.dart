import 'package:injectable/injectable.dart';

import '../../../../core/error/guard.dart';
import '../../../../core/error/typedef.dart';
import '../../../../core/storage/key_value_stores.dart';
import '../../domain/entities/app_preferences.dart';
import '../../domain/repositories/app_preferences_repository.dart';

@LazySingleton(as: IAppPreferencesRepository)
class AppPreferencesRepositoryImpl implements IAppPreferencesRepository {
  AppPreferencesRepositoryImpl({required IPreferencesStore store})
    : _store = store;

  static const String localeKey = 'prefs.locale';
  static const String hasOnboardedKey = 'prefs.has_onboarded';

  final IPreferencesStore _store;

  /// No try/catch on purpose: `IPreferencesStore` reads are synchronous,
  /// pre-loaded and report a value of the wrong type as absent (it logs it),
  /// so the defaults below already cover "missing or unreadable".
  @override
  AppPreferences read() {
    final localeTag = _store.getString(key: localeKey);
    return AppPreferences(
      localeTag: localeTag == null || localeTag.isEmpty ? null : localeTag,
      hasOnboarded: _store.getBool(key: hasOnboardedKey) ?? false,
    );
  }

  @override
  ResultFuture<void> setLocaleTag({required String localeTag}) =>
      guard(() => _store.setString(key: localeKey, value: localeTag));

  @override
  ResultFuture<void> setHasOnboarded({required bool value}) =>
      guard(() => _store.setBool(key: hasOnboardedKey, value: value));
}
