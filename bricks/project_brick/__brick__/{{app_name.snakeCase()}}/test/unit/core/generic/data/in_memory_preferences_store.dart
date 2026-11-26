import 'dart:async';

import 'package:flutter_all_template/core/storage/key_value_stores.dart';

/// In-memory [PreferencesStore] for tests. Writes complete asynchronously
/// (after [writeDelay]) so lost-update races would show up.
class InMemoryPreferencesStore implements PreferencesStore {
  InMemoryPreferencesStore({this.writeDelay = Duration.zero});

  final Duration writeDelay;
  final Map<String, Object> values = {};

  @override
  String? getString(String key) => values[key] as String?;

  @override
  Future<void> setString(String key, String value) async {
    await Future<void>.delayed(writeDelay);
    values[key] = value;
  }

  @override
  bool? getBool(String key) => values[key] as bool?;

  @override
  Future<void> setBool(String key, {required bool value}) async {
    values[key] = value;
  }

  @override
  int? getInt(String key) => values[key] as int?;

  @override
  Future<void> setInt(String key, int value) async {
    values[key] = value;
  }

  @override
  Future<void> remove(String key) async {
    values.remove(key);
  }

  @override
  Future<void> clear() async => values.clear();
}
