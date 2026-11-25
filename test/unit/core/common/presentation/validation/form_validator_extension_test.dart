import 'package:flutter_all_template/config/constants/gen/locale_keys.g.dart';
import 'package:flutter_all_template/core/common/presentation/extensions/validation/form_validator_extension.dart';
import 'package:flutter_test/flutter_test.dart';

ValidationFailure? failureOf(ValidationResult result) =>
    result.fold((l) => l, (_) => null);

void expectValid(ValidationResult result) =>
    expect(result.isValid, isTrue, reason: '${failureOf(result)}');

void expectKey(ValidationResult result, String key, {String? field}) {
  final failure = failureOf(result);
  expect(failure, isNotNull);
  expect(failure!.key, key);
  if (field != null) {
    expect(failure.fieldKey, field);
  }
}

void main() {
  const required = LocaleKeys.common_errors_validation_required;
  const invalid = LocaleKeys.common_errors_validation_invalid;

  group('validateName (Unicode, S21)', () {
    for (final name in [
      'John',
      'Anne-Marie',
      "O'Neil",
      'José Álvarez',
      'राम बहादुर',
      'Zoë  Smith',
      'J. R. Tolkien',
      '李小龙',
    ]) {
      test('accepts "$name"', () => expectValid(name.validateName()));
    }

    for (final name in ['John3', 'a_b', '<script>', '--', "'", 'Jo@hn']) {
      test('rejects "$name"', () => expectKey(name.validateName(), invalid));
    }

    test('returns keys, not translated text', () {
      final failure = failureOf(''.validateName())!;
      expect(failure.key, required);
      expect(failure.fieldKey, LocaleKeys.common_form_field_titles_fullName);
    });

    test('null and whitespace are required', () {
      expectKey((null as String?).validateName(), required);
      expectKey('   '.validateName(), required);
    });

    test('enforces max length', () {
      expectKey(('a' * 101).validateName(), invalid);
    });

    test('validateFullName delegates to validateName', () {
      expectValid('राम'.validateFullName());
    });
  });

  group('validateEmail', () {
    test('accepts common addresses', () {
      expectValid('a@b.co'.validateEmail());
      expectValid('first.last+tag@sub.example.museum'.validateEmail());
    });
    test('rejects malformed addresses', () {
      for (final e in ['a@b', 'a b@c.com', '@b.com', 'a@.com', 'a@b.c']) {
        expectKey(e.validateEmail(), invalid);
      }
    });
    test('required', () => expectKey(''.validateEmail(), required));
  });

  group('validatePassword', () {
    test('min length carries the argument', () {
      final f = failureOf('Ab1'.validatePassword())!;
      expect(f.key, LocaleKeys.common_errors_validation_minLength);
      expect(f.args, {'minLength': '8'});
    });
    test('character classes', () {
      expectKey(
        'abcdefg1'.validatePassword(),
        LocaleKeys.common_errors_validation_uppercaseRequired,
      );
      expectKey(
        'ABCDEFG1'.validatePassword(),
        LocaleKeys.common_errors_validation_lowercaseRequired,
      );
      expectKey(
        'Abcdefgh'.validatePassword(),
        LocaleKeys.common_errors_validation_numberRequired,
      );
      expectKey(
        'Abcdefg1'.validatePassword(requireSpecialCharacter: true),
        LocaleKeys.common_errors_validation_specialCharacterRequired,
      );
      expectValid('Abcdefg1!'.validatePassword(requireSpecialCharacter: true));
    });
    test('confirm password', () {
      expectValid('Abcdefg1'.validateConfirmPassword('Abcdefg1'));
      expectKey(
        'x'.validateConfirmPassword('y'),
        LocaleKeys.common_errors_validation_passwordsDoNotMatch,
      );
    });
  });

  group('other validators', () {
    test('phone', () {
      expectValid('+977 (98) 123-45678'.validatePhoneNumber());
      expectKey('12ab'.validatePhoneNumber(), invalid);
    });
    test('url', () {
      expectValid('https://example.com/path?q=1'.validateUrl());
      expectKey('javascript:alert(1)'.validateUrl(), invalid);
      expectKey('http://'.validateUrl(), invalid);
    });
    test('credit card (Luhn)', () {
      expectValid('4111 1111 1111 1111'.validateCreditCard());
      expectKey(
        '4111 1111 1111 1112'.validateCreditCard(),
        LocaleKeys.common_errors_validation_invalidCreditCard,
      );
    });
    test('otp', () {
      expectValid('123456'.validateOtp());
      expectKey('12345'.validateOtp(), invalid);
      expectKey('١٢٣٤٥٦'.validateOtp(), invalid);
    });
    test('hours / minutes', () {
      expectValid('23'.validateHours());
      expectKey('24'.validateHours(), invalid);
      expectValid('0'.validateMinutes());
      expectKey('60'.validateMinutes(), invalid);
      expectKey('99999999999999999999'.validateMinutes(), invalid);
    });
    test('money, handle, username, postal, account', () {
      expectValid('10.50'.validateMoney());
      expectKey('10.505'.validateMoney(), invalid);
      expectValid('@flutter_dev'.validateSocialMediaHandle());
      expectKey('bad handle'.validateSocialMediaHandle(), invalid);
      expectValid('user.name_1'.validateUsername());
      expectKey('ab'.validateUsername(), invalid);
      expectValid('SW1A 1AA'.validatePostalCode());
      expectValid('44600'.validatePostalCode());
      expectValid('AB12 3456 78'.validateAccountNumber());
      expectKey(
        'AB12'.validateAccountNumber(),
        LocaleKeys.common_errors_validation_minLength,
      );
    });
  });

  group('ReDoS resistance', () {
    test('pathological inputs are rejected quickly', () {
      final inputs = [
        '${'a' * 5000}!',
        '${"a'" * 5000}1',
        '${'a.' * 5000}@',
        '${'a' * 5000}@${'b' * 5000}',
      ];
      final sw = Stopwatch()..start();
      for (final input in inputs) {
        input
          ..validateName()
          ..validateEmail()
          ..validateSocialMediaHandle()
          ..validateUrl();
      }
      expect(sw.elapsed, lessThan(const Duration(seconds: 1)));
    });
  });
}
