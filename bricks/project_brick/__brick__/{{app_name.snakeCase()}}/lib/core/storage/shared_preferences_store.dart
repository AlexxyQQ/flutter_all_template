import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../error/app_exception.dart';
import '../services/logger/data/app_logger.dart';
import 'key_value_stores.dart';

/// [IPreferencesStore] backed by [SharedPreferencesWithCache] (values are
/// loaded once at startup, so reads are synchronous).
@LazySingleton(as: IPreferencesStore)
class SharedPreferencesStore implements IPreferencesStore {
  SharedPreferencesStore({required SharedPreferencesWithCache prefs})
    : _prefs = prefs;

  static const String _name = 'PreferencesStore';

  final SharedPreferencesWithCache _prefs;

  @override
  String? getString({required String key}) => _read<String>(key: key);

  @override
  Future<void> setString({required String key, required String value}) =>
      _write('setString', key, () => _prefs.setString(key, value));

  @override
  bool? getBool({required String key}) => _read<bool>(key: key);

  @override
  Future<void> setBool({required String key, required bool value}) =>
      _write('setBool', key, () => _prefs.setBool(key, value));

  @override
  Future<void> remove({required String key}) =>
      _write('remove', key, () => _prefs.remove(key));

  @override
  Future<void> removeByPrefix({required String prefix}) => _write(
    'removeByPrefix',
    prefix,
    () async {
      // Copy: removing while iterating the live key set would throw.
      final keys = _prefs.keys.where((key) => key.startsWith(prefix)).toList();
      for (final key in keys) {
        await _prefs.remove(key);
      }
    },
  );

  @override
  Future<void> clear() => _write('clear', null, _prefs.clear);

  /// A stored value of another type is logged and treated as absent instead of
  /// crashing the caller.
  T? _read<T extends Object>({required String key}) {
    final value = _prefs.get(key);
    if (value == null || value is T) {
      return value as T?;
    }
    AppLogger.warning(
      'Preference "$key" holds a ${value.runtimeType}, expected $T; ignoring it',
      name: _name,
    );
    return null;
  }

  Future<void> _write(
    String operation,
    String? key,
    Future<void> Function() body,
  ) async {
    try {
      await body();
    } catch (e, s) {
      Error.throwWithStackTrace(
        StorageException(
          debugMessage:
              'IPreferencesStore.$operation${key == null ? '' : '($key)'} '
              'failed (${e.runtimeType})',
          cause: e,
        ),
        s,
      );
    }
  }
}
