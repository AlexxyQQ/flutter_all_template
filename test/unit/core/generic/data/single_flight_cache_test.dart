import 'dart:async';

import 'package:flutter_all_template/core/generic/data/single_flight_cache.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late int fetches;
  late DateTime now;
  late Completer<String> pending;

  SingleFlightCache<String> build({Duration? ttl}) => SingleFlightCache<String>(
    fetch: () {
      fetches++;
      return pending.future;
    },
    ttl: ttl,
    now: () => now,
  );

  setUp(() {
    fetches = 0;
    now = DateTime(2026);
    pending = Completer<String>();
  });

  test('concurrent gets share one fetch, later gets hit the cache', () async {
    final cache = build();

    final a = cache.get();
    final b = cache.get();
    pending.complete('value');

    expect(await a, 'value');
    expect(await b, 'value');
    expect(await cache.get(), 'value');
    expect(fetches, 1);
  });

  test('expired values are fetched again', () async {
    final cache = build(ttl: const Duration(minutes: 1));
    pending.complete('v1');
    await cache.get();

    now = now.add(const Duration(minutes: 2));
    pending = Completer<String>()..complete('v2');

    expect(cache.peek(), isNull);
    expect(await cache.get(), 'v2');
    expect(fetches, 2);
  });

  test(
    'errors propagate, are not cached and clear the in-flight fetch',
    () async {
      final cache = build();
      pending.completeError(StateError('offline'));

      await expectLater(cache.get(), throwsStateError);

      pending = Completer<String>()..complete('ok');
      expect(await cache.get(), 'ok');
      expect(fetches, 2);
    },
  );

  test(
    'a fetch started before invalidate does not repopulate the cache',
    () async {
      final cache = build();
      final inFlight = cache.get();
      cache.invalidate();
      pending.complete('stale');

      expect(await inFlight, 'stale');
      expect(cache.peek(), isNull);
    },
  );

  test(
    'set stores a value without fetching; forceRefresh bypasses it',
    () async {
      final cache = build()..set('manual');
      expect(await cache.get(), 'manual');
      expect(fetches, 0);

      pending.complete('fresh');
      expect(await cache.get(forceRefresh: true), 'fresh');
      expect(cache.peek()?.value, 'fresh');
    },
  );
}
