import 'dart:async';

import 'package:flutter_all_template/core/error/app_exception.dart';
import 'package:flutter_all_template/core/storage/key_value_stores.dart';

/// In-memory [IPreferencesStore] shared by every test.
///
/// [writeDelay] makes writes complete later (lost-update races show up);
/// [failWrites] makes every write throw a `StorageException`.
class InMemoryPreferencesStore implements IPreferencesStore {
  InMemoryPreferencesStore({this.writeDelay = Duration.zero});

  final Duration writeDelay;
  final Map<String, Object> values = {};
  bool failWrites = false;

  Future<void> _write(void Function() body) async {
    if (writeDelay != Duration.zero) {
      await Future<void>.delayed(writeDelay);
    }
    if (failWrites) {
      throw const StorageException(debugMessage: 'write failed');
    }
    body();
  }

  @override
  String? getString({required String key}) {
    final value = values[key];
    return value is String ? value : null;
  }

  @override
  Future<void> setString({required String key, required String value}) =>
      _write(() => values[key] = value);

  @override
  bool? getBool({required String key}) {
    final value = values[key];
    return value is bool ? value : null;
  }

  @override
  Future<void> setBool({required String key, required bool value}) =>
      _write(() => values[key] = value);

  @override
  Future<void> remove({required String key}) =>
      _write(() => values.remove(key));

  @override
  Future<void> removeByPrefix({required String prefix}) =>
      _write(() => values.removeWhere((key, _) => key.startsWith(prefix)));

  @override
  Future<void> clear() => _write(values.clear);
}
