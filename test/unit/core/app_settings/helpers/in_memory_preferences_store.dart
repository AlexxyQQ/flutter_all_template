import 'package:flutter_all_template/core/error/app_exception.dart';
import 'package:flutter_all_template/core/storage/key_value_stores.dart';

class InMemoryPreferencesStore implements PreferencesStore {
  final Map<String, Object> values = {};
  bool failWrites = false;

  Future<void> _write(void Function() body) async {
    if (failWrites) {
      throw const StorageException(debugMessage: 'write failed');
    }
    body();
  }

  @override
  String? getString(String key) => values[key] as String?;

  @override
  Future<void> setString(String key, String value) =>
      _write(() => values[key] = value);

  @override
  bool? getBool(String key) => values[key] as bool?;

  @override
  Future<void> setBool(String key, {required bool value}) =>
      _write(() => values[key] = value);

  @override
  int? getInt(String key) => values[key] as int?;

  @override
  Future<void> setInt(String key, int value) =>
      _write(() => values[key] = value);

  @override
  Future<void> remove(String key) => _write(() => values.remove(key));

  @override
  Future<void> clear() => _write(values.clear);
}
