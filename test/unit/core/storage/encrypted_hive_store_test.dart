import 'dart:convert';
import 'dart:io';

import 'package:flutter_all_template/core/common/domain/services/analytics/data/destinations/local_analytics_destination.dart';
import 'package:flutter_all_template/core/common/domain/services/analytics/data/encrypted_hive_analytics_storage.dart';
import 'package:flutter_all_template/core/common/domain/services/analytics/domain/analytics_event.dart';
import 'package:flutter_all_template/core/common/domain/services/analytics/domain/analytics_event_type.dart';
import 'package:flutter_all_template/core/common/domain/services/analytics/domain/analytics_identity.dart';
import 'package:flutter_all_template/core/error/app_exception.dart';
import 'package:flutter_all_template/core/storage/encrypted_hive_store.dart';
import 'package:flutter_all_template/core/storage/key_value_stores.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';

void main() {
  late Directory directory;
  late InMemoryHiveKeyVault vault;
  late EncryptedHiveStore store;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('encrypted_hive_test');
    vault = InMemoryHiveKeyVault();
    store = EncryptedHiveStore(keyVault: vault, directoryPath: directory.path);
  });

  tearDown(() async {
    await store.close();
    await for (final file in directory.list()) {
      await file.delete();
    }
    await directory.delete();
  });

  test('persists records without putting keys or values in the file', () async {
    const key = 'account_private_key_for_a_record';
    const value = 'private payload with unicode: नमस्ते';

    await Future.wait([
      store.write(key: key, value: value),
      store.write(key: 'another_key', value: 'another_value'),
    ]);
    await store.close();

    final file = directory.listSync().whereType<File>().singleWhere(
      (entry) => entry.path.endsWith('.hive'),
    );
    final raw = utf8.decode(await file.readAsBytes(), allowMalformed: true);
    expect(raw, isNot(contains(key)));
    expect(raw, isNot(contains(value)));
    expect(raw, isNot(contains(vault.value)));
    expect(await store.keys(), unorderedEquals([key, 'another_key']));
    expect(await store.read(key: key), value);
    await store.delete(key: key);
    expect(await store.read(key: key), isNull);
    expect(await store.keys(), ['another_key']);
  });

  test('rejects a missing or replaced key for existing data', () async {
    await store.write(key: 'key', value: 'value');
    await store.close();
    final original = vault.value;

    vault.value = null;
    await expectLater(store.read(key: 'key'), throwsA(isA<StorageException>()));
    expect(vault.value, isNull);

    vault.value = base64UrlEncode(List<int>.filled(64, 0));
    await expectLater(
      store.write(key: 'key', value: 'replacement'),
      throwsA(isA<StorageException>()),
    );

    vault.value = original;
    expect(await store.read(key: 'key'), 'value');
  });

  test('rejects ciphertext copied to another record', () async {
    await store.write(key: 'first', value: 'one');
    await store.write(key: 'second', value: 'two');
    await store.close();

    final box = await Hive.openBox<String>(
      'secure_records_v1',
      path: directory.path,
    );
    try {
      final ids = box.keys.cast<String>().where((key) => key != 'format');
      await box.put(ids.first, box.get(ids.last)!);
    } finally {
      await box.close();
    }

    await expectLater(store.keys(), throwsA(isA<StorageException>()));
  });

  test('local analytics survives reopening and filters by identity', () async {
    final destination = LocalAnalyticsDestination(
      storage: EncryptedHiveAnalyticsStorage(store: store),
    );
    const first = AnalyticsIdentity(anonymousId: 'install', userId: 'user_a');
    const second = AnalyticsIdentity(anonymousId: 'install', userId: 'user_b');
    const guest = AnalyticsIdentity(anonymousId: 'install');
    final timestamp = DateTime.utc(2026);

    await destination.send(
      events: [
        for (final (index, identity) in [first, second, guest].indexed)
          AnalyticsEvent(
            id: 'event_$index',
            type: AnalyticsEventType.action,
            name: 'todo_create',
            occurredAt: timestamp,
            anonymousId: identity.anonymousId,
            userId: identity.userId,
            sessionId: 'session',
          ),
      ],
    );
    await store.close();

    for (final (index, identity) in [first, second, guest].indexed) {
      final events = await destination.readRecent(identity: identity);
      expect(events.map((event) => event.id), ['event_$index']);
    }
  });
}

class InMemoryHiveKeyVault implements SecureStore {
  String? value;

  @override
  Future<String?> read(String key) async => value;

  @override
  Future<void> write(String key, String value) async => this.value = value;

  @override
  Future<void> delete(String key) async => value = null;

  @override
  Future<void> deleteAll() async => value = null;
}
