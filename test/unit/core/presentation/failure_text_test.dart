import 'package:flutter_all_template/core/error/failure.dart';
import 'package:flutter_all_template/core/presentation/failure_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('displayText shows the server message verbatim', () {
    const failure = Failure(
      messageKey: 'common.errors.network.case400',
      serverMessage: 'Title.is taken',
    );

    expect(failure.displayText, 'Title.is taken');
  });

  test('displayText falls back to the (translated) message key', () {
    const failure = Failure(messageKey: 'common.errors.network.case400');

    // Without an initialised EasyLocalization the key is returned unchanged.
    expect(failure.displayText, 'common.errors.network.case400');
  });
}
