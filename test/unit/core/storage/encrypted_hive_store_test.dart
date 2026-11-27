import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_all_template/core/error/app_exception.dart';
import 'package:flutter_all_template/core/services/analytics/data/destinations/local_analytics_destination.dart';
import 'package:flutter_all_template/core/services/analytics/data/encrypted_hive_analytics_storage.dart';
import 'package:flutter_all_template/core/services/analytics/domain/analytics_event.dart';
import 'package:flutter_all_template/core/services/analytics/domain/analytics_event_type.dart';
import 'package:flutter_all_template/core/services/analytics/domain/analytics_identity.dart';
import 'package:flutter_all_template/core/storage/encrypted_hive_store.dart';
import 'package:flutter_all_template/core/storage/key_value_stores.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';

void main() {
  const boxName = 'secure_records_v2';

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

  /// Edits the box behind the store's back; the store must be closed.
  Future<void> tamper(Future<void> Function(Box<String> box) edit) async {
    final box = await Hive.openBox<String>(boxName, path: directory.path);
    try {
      await edit(box);
    } finally {
      await box.close();
    }
  }

  test('persists values without putting them in the file', () async {
    const value = 'private payload with unicode: नमस्ते';

    await Future.wait([
      store.write(key: 'first_id', value: value),
      store.write(key: 'second_id', value: 'another_value'),
    ]);
    await store.close();

    final file = directory.listSync().whereType<File>().singleWhere(
      (entry) => entry.path.endsWith('.hive'),
    );
    final raw = utf8.decode(await file.readAsBytes(), allowMalformed: true);
    expect(raw, isNot(contains(value)));
    expect(raw, isNot(contains(vault.value)));
    expect(await store.keys(), unorderedEquals(['first_id', 'second_id']));
    expect(await store.read(key: 'first_id'), value);
    await store.delete(key: 'first_id');
    expect(await store.read(key: 'first_id'), isNull);
    expect(await store.keys(), ['second_id']);
  });

  test('keys() lists records without decrypting them', () async {
    await store.write(key: 'record', value: 'value');
    await store.close();
    await tamper((box) => box.put('record', 'not-valid-ciphertext'));

    expect(await store.keys(), ['record']);
    await expectLater(
      store.read(key: 'record'),
      throwsA(isA<StorageException>()),
    );
  });

  test('recovers when the key is missing for an existing store', () async {
    await store.write(key: 'key', value: 'value');
    await store.close();
    final original = vault.value;

    vault.value = null;

    expect(await store.read(key: 'key'), isNull);
    expect(vault.value, isNotNull);
    expect(vault.value, isNot(original));
    await store.write(key: 'key', value: 'fresh');
    expect(await store.read(key: 'key'), 'fresh');
  });

  test('recovers when the stored key is malformed or replaced', () async {
    await store.write(key: 'key', value: 'value');
    await store.close();

    vault.value = 'not base64 at all!';
    expect(await store.read(key: 'key'), isNull);
    await store.write(key: 'key', value: 'second');
    await store.close();

    vault.value = base64UrlEncode(List<int>.filled(32, 0));
    expect(await store.read(key: 'key'), isNull);
    expect(await store.keys(), isEmpty);
  });

  test('rejects ciphertext copied to another record', () async {
    await store.write(key: 'first', value: 'one');
    await store.write(key: 'second', value: 'two');
    await store.close();
    await tamper((box) => box.put('first', box.get('second')!));

    await expectLater(
      store.read(key: 'first'),
      throwsA(
        isA<StorageException>().having(
          (e) => e.cause,
          'the real error is kept as the cause',
          isA<SecretBoxAuthenticationError>(),
        ),
      ),
    );
    expect(await store.read(key: 'second'), 'two');
  });

  test('local analytics events survive closing the store', () async {
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

    expect(await store.keys(), hasLength(3));
  });
}

class InMemoryHiveKeyVault implements ISecureStore {
  String? value;

  @override
  Future<String?> read({required String key}) async => value;

  @override
  Future<void> write({required String key, required String value}) async =>
      this.value = value;

  @override
  Future<void> delete({required String key}) async => value = null;

  @override
  Future<void> deleteAll() async => value = null;
}
