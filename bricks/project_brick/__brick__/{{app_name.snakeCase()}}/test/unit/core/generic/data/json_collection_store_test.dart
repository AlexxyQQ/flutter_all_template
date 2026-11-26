import 'package:equatable/equatable.dart';
import 'package:flutter_all_template/core/error/app_exception.dart';
import 'package:flutter_all_template/core/generic/data/json_collection_store.dart';
import 'package:flutter_test/flutter_test.dart';

import 'in_memory_preferences_store.dart';

class _Item extends Equatable {
  const _Item(this.id, this.name);

  factory _Item.fromJson(Map<String, dynamic> json) =>
      _Item(json['id'] as String, json['name'] as String);

  final String id;
  final String name;

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  @override
  List<Object?> get props => [id, name];
}

void main() {
  late InMemoryPreferencesStore prefs;
  late JsonCollectionStore<_Item> store;

  JsonCollectionStore<_Item> buildStore() => JsonCollectionStore<_Item>(
    store: prefs,
    key: 'items',
    idOf: (item) => item.id,
    toJson: (item) => item.toJson(),
    fromJson: _Item.fromJson,
  );

  setUp(() {
    prefs = InMemoryPreferencesStore(
      writeDelay: const Duration(milliseconds: 1),
    );
    store = buildStore();
  });

  test('readAll is empty when nothing is stored', () async {
    expect(await store.readAll(), isEmpty);
  });

  test(
    'upsert inserts, then replaces only the item with the same id',
    () async {
      await store.upsertAll(const [_Item('1', 'a'), _Item('2', 'b')]);
      await store.upsert(const _Item('2', 'B'));

      expect(await store.readAll(), const [_Item('1', 'a'), _Item('2', 'B')]);
      expect(await store.read('1'), const _Item('1', 'a'));
    },
  );

  test('delete removes only the matching item', () async {
    await store.upsertAll(const [
      _Item('1', 'a'),
      _Item('2', 'b'),
      _Item('3', 'c'),
    ]);

    expect(await store.delete('2'), isTrue);
    expect(await store.delete('missing'), isFalse);
    expect(await store.readAll(), const [_Item('1', 'a'), _Item('3', 'c')]);
  });

  test('read throws CacheMissException for an unknown id', () async {
    await store.upsert(const _Item('1', 'a'));

    expect(() => store.read('2'), throwsA(isA<CacheMissException>()));
  });

  test('replaceAll and clear', () async {
    await store.upsertAll(const [_Item('1', 'a'), _Item('2', 'b')]);
    await store.replaceAll(const [_Item('3', 'c')]);
    expect(await store.readAll(), const [_Item('3', 'c')]);

    await store.clear();
    expect(await store.readAll(), isEmpty);
    expect(prefs.values.containsKey('items'), isFalse);
  });

  test('concurrent writes do not lose updates', () async {
    await Future.wait([
      for (var i = 0; i < 25; i++) store.upsert(_Item('$i', 'n$i')),
    ]);

    expect(await store.readAll(), hasLength(25));
  });

  test('data is shared through the preferences key', () async {
    await store.upsert(const _Item('1', 'a'));

    expect(await buildStore().readAll(), const [_Item('1', 'a')]);
  });

  test(
    'corrupt data throws StorageException without leaking the value',
    () async {
      prefs.values['items'] = '{"secret-value"';

      await expectLater(
        store.readAll(),
        throwsA(
          isA<StorageException>().having(
            (e) => e.debugMessage,
            'debugMessage',
            isNot(contains('secret-value')),
          ),
        ),
      );
    },
  );

  test('items missing required fields throw StorageException', () async {
    prefs.values['items'] = '[{"name":"no id"}]';

    expect(store.readAll, throwsA(isA<StorageException>()));
  });
}
