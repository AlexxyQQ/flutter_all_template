import 'package:flutter_all_template/core/error/app_exception.dart';
import 'package:flutter_all_template/core/storage/shared_preferences_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockPrefs extends Mock implements SharedPreferencesWithCache {}

void main() {
  late _MockPrefs prefs;
  late SharedPreferencesStore store;

  setUp(() {
    prefs = _MockPrefs();
    store = SharedPreferencesStore(prefs: prefs);
  });

  test('synchronous reads delegate to the cache', () {
    when(() => prefs.get('s')).thenReturn('x');
    when(() => prefs.get('b')).thenReturn(true);

    expect(store.getString(key: 's'), 'x');
    expect(store.getBool(key: 'b'), isTrue);
  });

  test('an absent key reads as null', () {
    when(() => prefs.get('s')).thenReturn(null);
    expect(store.getString(key: 's'), isNull);
  });

  test('a value of the wrong type reads as null', () {
    when(() => prefs.get('b')).thenReturn('not a bool');
    expect(store.getBool(key: 'b'), isNull);
  });

  test('writes delegate to the cache', () async {
    when(() => prefs.setString('s', 'x')).thenAnswer((_) async {});
    when(() => prefs.setBool('b', true)).thenAnswer((_) async {});
    when(() => prefs.remove('s')).thenAnswer((_) async {});
    when(prefs.clear).thenAnswer((_) async {});

    await store.setString(key: 's', value: 'x');
    await store.setBool(key: 'b', value: true);
    await store.remove(key: 's');
    await store.clear();

    verify(() => prefs.setBool('b', true)).called(1);
    verify(prefs.clear).called(1);
  });

  test('removeByPrefix removes only keys with that prefix', () async {
    when(() => prefs.keys).thenReturn({'session.a', 'session.b', 'prefs.c'});
    when(() => prefs.remove(any())).thenAnswer((_) async {});

    await store.removeByPrefix(prefix: 'session.');

    verify(() => prefs.remove('session.a')).called(1);
    verify(() => prefs.remove('session.b')).called(1);
    verifyNever(() => prefs.remove('prefs.c'));
  });

  test('write errors become StorageException keeping the cause', () async {
    final diskFull = Exception('disk full');
    when(() => prefs.setString('s', 'x')).thenThrow(diskFull);

    await expectLater(
      store.setString(key: 's', value: 'x'),
      throwsA(
        isA<StorageException>().having((e) => e.cause, 'cause', same(diskFull)),
      ),
    );
  });
}
