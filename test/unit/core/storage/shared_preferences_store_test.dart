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
    when(() => prefs.getString('s')).thenReturn('x');
    when(() => prefs.getBool('b')).thenReturn(true);
    when(() => prefs.getInt('i')).thenReturn(3);

    expect(store.getString('s'), 'x');
    expect(store.getBool('b'), isTrue);
    expect(store.getInt('i'), 3);
  });

  test('a value of the wrong type reads as null', () {
    when(() => prefs.getBool('b')).thenThrow(TypeError());
    expect(store.getBool('b'), isNull);
  });

  test('writes delegate to the cache', () async {
    when(() => prefs.setString('s', 'x')).thenAnswer((_) async {});
    when(() => prefs.setBool('b', true)).thenAnswer((_) async {});
    when(() => prefs.setInt('i', 1)).thenAnswer((_) async {});
    when(() => prefs.remove('s')).thenAnswer((_) async {});
    when(prefs.clear).thenAnswer((_) async {});

    await store.setString('s', 'x');
    await store.setBool('b', value: true);
    await store.setInt('i', 1);
    await store.remove('s');
    await store.clear();

    verify(() => prefs.setBool('b', true)).called(1);
    verify(prefs.clear).called(1);
  });

  test('write errors become StorageException', () async {
    when(() => prefs.setString('s', 'x')).thenThrow(Exception('disk full'));
    await expectLater(
      store.setString('s', 'x'),
      throwsA(isA<StorageException>()),
    );
  });
}
