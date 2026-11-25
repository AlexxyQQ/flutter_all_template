import 'package:flutter_all_template/core/generic/data/async_lock.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('runs bodies one at a time in call order', () async {
    final lock = AsyncLock();
    final log = <String>[];

    Future<void> job(String name, int delayMs) => lock.synchronized(() async {
      log.add('start $name');
      await Future<void>.delayed(Duration(milliseconds: delayMs));
      log.add('end $name');
    });

    await Future.wait([job('a', 20), job('b', 0), job('c', 5)]);

    expect(log, ['start a', 'end a', 'start b', 'end b', 'start c', 'end c']);
  });

  test('returns the body result and keeps working after an error', () async {
    final lock = AsyncLock();

    final failing = lock.synchronized<int>(() => throw StateError('boom'));
    final next = lock.synchronized(() async => 42);

    await expectLater(failing, throwsStateError);
    expect(await next, 42);
  });
}
