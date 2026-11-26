import 'package:flutter_all_template/core/common/domain/entities/failure.dart';
import 'package:flutter_all_template/core/common/features/app_settings/data/repositories/app_preferences_repository_impl.dart';
import 'package:flutter_all_template/core/common/features/app_settings/domain/entities/app_preferences.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/in_memory_preferences_store.dart';

void main() {
  late InMemoryPreferencesStore store;
  late AppPreferencesRepositoryImpl repository;

  setUp(() {
    store = InMemoryPreferencesStore();
    repository = AppPreferencesRepositoryImpl(store: store);
  });

  test('defaults when nothing is stored', () {
    expect(repository.read(), const AppPreferences());
  });

  test('round-trips locale tag (with country) and onboarding', () async {
    await repository.setLocaleTag(localeTag: 'ne-NP');
    await repository.setHasOnboarded(value: true);

    expect(
      repository.read(),
      const AppPreferences(localeTag: 'ne-NP', hasOnboarded: true),
    );
  });

  test('corrupt values never throw from read()', () {
    store.values[AppPreferencesRepositoryImpl.hasOnboardedKey] = 'yes';
    expect(repository.read(), const AppPreferences());
  });

  test('write failures are returned as a storage Failure', () async {
    store.failWrites = true;
    final result = await repository.setLocaleTag(localeTag: 'en-GB');
    expect(result.getLeft().toNullable()?.type, FailureType.storage);
  });

  test('does not store any secrets', () async {
    await repository.setLocaleTag(localeTag: 'en-GB');
    expect(
      store.values.keys,
      everyElement(isNot(anyOf(contains('token'), contains('password')))),
    );
  });
}
