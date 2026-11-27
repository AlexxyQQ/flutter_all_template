import 'package:flutter_all_template/config/constants/gen/locale_keys.g.dart';
import 'package:flutter_all_template/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('unknown failure uses the generic localization key', () {
    expect(
      const Failure.unknown().messageKey,
      LocaleKeys.common_errors_somethingWentWrong,
    );
    expect(
      Failure.unknownMessageKey,
      LocaleKeys.common_errors_somethingWentWrong,
    );
  });

  test('validation failure carries a key and is typed validation', () {
    const failure = Failure.validation(messageKey: 'features.todo.emptyTitle');

    expect(failure.type, FailureType.validation);
    expect(failure.messageKey, 'features.todo.emptyTitle');
    expect(failure.serverMessage, isNull);
  });

  test('serverMessage takes part in equality', () {
    const a = Failure(messageKey: 'k', serverMessage: 'one');
    const b = Failure(messageKey: 'k', serverMessage: 'two');

    expect(a, isNot(b));
    expect(a, const Failure(messageKey: 'k', serverMessage: 'one'));
  });
}
