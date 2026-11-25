import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../error/app_exception.dart';
import 'key_value_stores.dart';

/// [PreferencesStore] backed by [SharedPreferencesWithCache] (values are
/// loaded once at startup, so reads are synchronous).
@LazySingleton(as: PreferencesStore)
class SharedPreferencesStore implements PreferencesStore {
  SharedPreferencesStore(this._prefs);

  final SharedPreferencesWithCache _prefs;

  @override
  String? getString(String key) => _read(key, () => _prefs.getString(key));

  @override
  Future<void> setString(String key, String value) =>
      _write('setString', key, () => _prefs.setString(key, value));

  @override
  bool? getBool(String key) => _read(key, () => _prefs.getBool(key));

  @override
  Future<void> setBool(String key, {required bool value}) =>
      _write('setBool', key, () => _prefs.setBool(key, value));

  @override
  int? getInt(String key) => _read(key, () => _prefs.getInt(key));

  @override
  Future<void> setInt(String key, int value) =>
      _write('setInt', key, () => _prefs.setInt(key, value));

  @override
  Future<void> remove(String key) =>
      _write('remove', key, () => _prefs.remove(key));

  @override
  Future<void> clear() => _write('clear', null, _prefs.clear);

  /// A stored value of the wrong type is treated as absent instead of crashing.
  T? _read<T>(String key, T? Function() body) {
    try {
      return body();
    } on TypeError {
      return null;
    }
  }

  Future<void> _write(
    String operation,
    String? key,
    Future<void> Function() body,
  ) async {
    try {
      await body();
    } catch (e) {
      throw StorageException(
        debugMessage:
            'PreferencesStore.$operation${key == null ? '' : '($key)'} failed '
            '(${e.runtimeType})',
        cause: e,
      );
    }
  }
}
