import 'package:flutter/services.dart';
import 'package:flutter_all_template/core/error/app_exception.dart';
import 'package:flutter_all_template/core/storage/flutter_secure_store.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late _MockStorage storage;
  late FlutterSecureStore store;

  setUp(() {
    storage = _MockStorage();
    store = FlutterSecureStore(storage: storage);
  });

  test('read/write/delete delegate to the plugin', () async {
    when(() => storage.read(key: 'k')).thenAnswer((_) async => 'v');
    when(() => storage.write(key: 'k', value: 'v')).thenAnswer((_) async {});
    when(() => storage.delete(key: 'k')).thenAnswer((_) async {});
    when(storage.deleteAll).thenAnswer((_) async {});

    expect(await store.read('k'), 'v');
    await store.write('k', 'v');
    await store.delete('k');
    await store.deleteAll();

    verify(() => storage.write(key: 'k', value: 'v')).called(1);
    verify(() => storage.delete(key: 'k')).called(1);
    verify(storage.deleteAll).called(1);
  });

  test('platform errors become StorageException without the value', () async {
    when(
      () => storage.write(key: 'token', value: 'super-secret'),
    ).thenThrow(PlatformException(code: 'KeystoreError'));

    await expectLater(
      store.write('token', 'super-secret'),
      throwsA(
        isA<StorageException>().having(
          (e) => e.debugMessage,
          'debugMessage',
          allOf(contains('token'), isNot(contains('super-secret'))),
        ),
      ),
    );
  });

  test('read errors become StorageException', () async {
    when(() => storage.read(key: 'k')).thenThrow(Exception('boom'));
    await expectLater(store.read('k'), throwsA(isA<StorageException>()));
  });
}
