import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../config/constants/gen/locale_keys.g.dart';

/// A failed validation, expressed as localization keys (never as translated
/// text) so it can be asserted in tests and translated at the widget layer.
class ValidationFailure extends Equatable {
  const ValidationFailure(
    this.key, {
    this.fieldKey,
    this.args = const <String, String>{},
  });

  /// Message key, e.g. [LocaleKeys.common_errors_validation_required].
  final String key;

  /// Localization key of the field title; injected as the `{field}` argument.
  final String? fieldKey;

  /// Extra literal named arguments (e.g. `{'minLength': '8'}`).
  final Map<String, String> args;

  /// Translates [key] with [fieldKey] (translated) and [args].
  String translate() => key.tr(
    namedArgs: <String, String>{
      if (fieldKey != null) 'field': fieldKey!.tr(),
      ...args,
    },
  );

  @override
  List<Object?> get props => [key, fieldKey, args];
}

/// Result of a validator: `Left(failure)` or `Right(unit)`.
typedef ValidationResult = Either<ValidationFailure, Unit>;

extension ValidationResultX on ValidationResult {
  /// Translated error text for `TextFormField.validator`, or `null` if valid.
  String? get errorText => fold((f) => f.translate(), (_) => null);

  bool get isValid => isRight();
}

/// Pure validators. Every pattern is anchored and free of nested/overlapping
/// quantifiers (no catastrophic backtracking), and inputs are length-capped
/// before any regex runs.
extension FormFieldValidator on String? {
  static const int _maxInputLength = 256;

  static final RegExp _email = RegExp(
    r'^[A-Za-z0-9._%+\-]+@[A-Za-z0-9\-]+(?:\.[A-Za-z0-9\-]+)*\.[A-Za-z]{2,63}$',
  );
  static final RegExp _upper = RegExp(r'\p{Lu}', unicode: true);
  static final RegExp _lower = RegExp(r'\p{Ll}', unicode: true);
  static final RegExp _digit = RegExp(r'\p{Nd}', unicode: true);
  static final RegExp _special = RegExp(r'[^\p{L}\p{N}\s]', unicode: true);
  static final RegExp _phone = RegExp(r'^\+?[0-9]{7,15}$');
  static final RegExp _phoneSeparators = RegExp(r'[\s\-().]');
  static final RegExp _postal = RegExp(
    r'^[A-Za-z0-9][A-Za-z0-9 \-]{2,8}[A-Za-z0-9]$',
  );

  /// Letters (any script) and combining marks, optionally separated by single
  /// runs of space, apostrophe, hyphen or dot: "José", "राम बहादुर",
  /// "O'Neil", "Anne-Marie", "J. R.".
  static final RegExp _name = RegExp(
    r"^[\p{L}\p{M}]+(?:[ '’\-.]+[\p{L}\p{M}]+)*\.?$",
    unicode: true,
  );
  static final RegExp _nonDigit = RegExp(r'\D');
  static final RegExp _alnum = RegExp(r'^[A-Za-z0-9]+$');
  static final RegExp _money = RegExp(r'^[0-9]{1,15}(?:\.[0-9]{1,2})?$');
  static final RegExp _handle = RegExp(r'^@?[A-Za-z0-9._]{1,30}$');
  static final RegExp _username = RegExp(r'^[A-Za-z0-9_.]{3,20}$');

  static ValidationResult _ok() => const Right(unit);

  static ValidationResult _fail(
    String key, {
    String? field,
    Map<String, String> args = const <String, String>{},
  }) => Left(ValidationFailure(key, fieldKey: field, args: args));

  static ValidationResult _required(String field) =>
      _fail(LocaleKeys.common_errors_validation_required, field: field);

  static ValidationResult _invalid(String field) =>
      _fail(LocaleKeys.common_errors_validation_invalid, field: field);

  /// Trimmed value, or `null` when missing/blank.
  String? get _trimmed {
    final value = this?.trim();
    return (value == null || value.isEmpty) ? null : value;
  }

  bool get _tooLong => (this?.length ?? 0) > _maxInputLength;

  ValidationResult validateNotEmpty({required String fieldName}) =>
      _trimmed == null ? _required(fieldName) : _ok();

  ValidationResult validateEmail({
    String fieldName = LocaleKeys.common_form_field_titles_email,
  }) {
    final value = _trimmed;
    if (value == null) {
      return _required(fieldName);
    }
    if (value.length > 254 || !_email.hasMatch(value)) {
      return _invalid(fieldName);
    }
    return _ok();
  }

  ValidationResult validatePassword({
    int minLength = 8,
    bool requireSpecialCharacter = false,
    String fieldName = LocaleKeys.common_form_field_titles_password,
  }) {
    final value = this;
    if (value == null || value.isEmpty) {
      return _required(fieldName);
    }
    if (value.length < minLength) {
      return _fail(
        LocaleKeys.common_errors_validation_minLength,
        field: fieldName,
        args: {'minLength': '$minLength'},
      );
    }
    if (_tooLong) {
      return _invalid(fieldName);
    }
    if (!_upper.hasMatch(value)) {
      return _fail(
        LocaleKeys.common_errors_validation_uppercaseRequired,
        field: fieldName,
      );
    }
    if (!_lower.hasMatch(value)) {
      return _fail(
        LocaleKeys.common_errors_validation_lowercaseRequired,
        field: fieldName,
      );
    }
    if (!_digit.hasMatch(value)) {
      return _fail(
        LocaleKeys.common_errors_validation_numberRequired,
        field: fieldName,
      );
    }
    if (requireSpecialCharacter && !_special.hasMatch(value)) {
      return _fail(
        LocaleKeys.common_errors_validation_specialCharacterRequired,
        field: fieldName,
      );
    }
    return _ok();
  }

  ValidationResult validateConfirmPassword(
    String password, {
    String fieldName = LocaleKeys.common_form_field_titles_confirmPassword,
  }) {
    final value = this;
    if (value == null || value.isEmpty) {
      return _required(fieldName);
    }
    if (value != password) {
      return _fail(LocaleKeys.common_errors_validation_passwordsDoNotMatch);
    }
    return _ok();
  }

  /// Accepts an optional leading `+` and 7–15 digits; spaces, dashes, dots
  /// and parentheses are ignored.
  ValidationResult validatePhoneNumber({
    String fieldName = LocaleKeys.common_form_field_titles_phoneNumber,
  }) {
    final value = _trimmed;
    if (value == null) {
      return _required(fieldName);
    }
    if (_tooLong || !_phone.hasMatch(value.replaceAll(_phoneSeparators, ''))) {
      return _invalid(fieldName);
    }
    return _ok();
  }

  /// `http`, `https` or `ftp` URL with a host.
  ValidationResult validateUrl({
    String fieldName = LocaleKeys.common_form_field_titles_url,
  }) {
    final value = _trimmed;
    if (value == null) {
      return _required(fieldName);
    }
    final uri = _tooLong || value.contains(' ') ? null : Uri.tryParse(value);
    final valid =
        uri != null &&
        const {'http', 'https', 'ftp'}.contains(uri.scheme.toLowerCase()) &&
        uri.host.isNotEmpty;
    return valid ? _ok() : _invalid(fieldName);
  }

  ValidationResult validatePostalCode({
    String fieldName = LocaleKeys.common_form_field_titles_postalCode,
  }) {
    final value = _trimmed;
    if (value == null) {
      return _required(fieldName);
    }
    return _postal.hasMatch(value) ? _ok() : _invalid(fieldName);
  }

  /// Unicode-aware person name (any script). See [_name].
  ValidationResult validateName({
    String fieldName = LocaleKeys.common_form_field_titles_fullName,
    int maxLength = 100,
  }) {
    final value = _trimmed;
    if (value == null) {
      return _required(fieldName);
    }
    if (value.length > maxLength || !_name.hasMatch(value)) {
      return _invalid(fieldName);
    }
    return _ok();
  }

  /// Alias of [validateName] kept for source compatibility.
  ValidationResult validateFullName({
    String fieldName = LocaleKeys.common_form_field_titles_fullName,
  }) => validateName(fieldName: fieldName);

  /// Luhn check on 13–19 digits (spaces/dashes ignored).
  ValidationResult validateCreditCard({
    String fieldName = LocaleKeys.common_form_field_titles_creditCardNumber,
  }) {
    final value = _trimmed;
    if (value == null) {
      return _required(fieldName);
    }
    if (_tooLong) {
      return _fail(LocaleKeys.common_errors_validation_invalidCreditCard);
    }
    final digits = value.replaceAll(_nonDigit, '');
    if (digits.length < 13 || digits.length > 19) {
      return _fail(LocaleKeys.common_errors_validation_invalidCreditCard);
    }
    var sum = 0;
    var doubleIt = false;
    for (var i = digits.length - 1; i >= 0; i--) {
      var digit = digits.codeUnitAt(i) - 0x30;
      if (doubleIt) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }
      sum += digit;
      doubleIt = !doubleIt;
    }
    return sum % 10 == 0
        ? _ok()
        : _fail(LocaleKeys.common_errors_validation_invalidCreditCard);
  }

  /// 8–20 alphanumerics (spaces ignored).
  ValidationResult validateAccountNumber({
    String fieldName = LocaleKeys.common_form_field_titles_accountNumber,
  }) {
    final value = _trimmed;
    if (value == null) {
      return _required(fieldName);
    }
    final sanitized = value.replaceAll(' ', '');
    if (sanitized.length < 8) {
      return _fail(
        LocaleKeys.common_errors_validation_minLength,
        field: fieldName,
        args: const {'minLength': '8'},
      );
    }
    if (sanitized.length > 20 || !_alnum.hasMatch(sanitized)) {
      return _invalid(fieldName);
    }
    return _ok();
  }

  /// Exactly [length] digits.
  ValidationResult validateOtp({
    String fieldName = LocaleKeys.common_form_field_titles_otp,
    int length = 6,
  }) {
    final value = _trimmed;
    if (value == null) {
      return _required(fieldName);
    }
    final valid =
        value.length == length && value.codeUnits.every(_isAsciiDigit);
    return valid ? _ok() : _invalid(fieldName);
  }

  /// Non-negative amount with at most two decimals.
  ValidationResult validateMoney({
    String fieldName = LocaleKeys.common_form_field_titles_amount,
  }) {
    final value = _trimmed;
    if (value == null) {
      return _required(fieldName);
    }
    return _money.hasMatch(value) ? _ok() : _invalid(fieldName);
  }

  ValidationResult validateSocialMediaHandle({
    String fieldName = LocaleKeys.common_form_field_titles_socialMediaHandle,
  }) {
    final value = _trimmed;
    if (value == null) {
      return _required(fieldName);
    }
    return _handle.hasMatch(value) ? _ok() : _invalid(fieldName);
  }

  ValidationResult validateHours({
    String fieldName = LocaleKeys.common_form_field_titles_hours,
    int min = 0,
    int max = 23,
  }) => _validateIntRange(fieldName, min, max);

  ValidationResult validateMinutes({
    String fieldName = LocaleKeys.common_form_field_titles_minutes,
    int min = 0,
    int max = 59,
  }) => _validateIntRange(fieldName, min, max);

  /// 3–20 of `A-Z a-z 0-9 _ .`, no spaces.
  ValidationResult validateUsername({
    String fieldName = LocaleKeys.common_form_field_titles_username,
  }) {
    final value = _trimmed;
    if (value == null) {
      return _required(fieldName);
    }
    return _username.hasMatch(value) ? _ok() : _invalid(fieldName);
  }

  ValidationResult _validateIntRange(String fieldName, int min, int max) {
    final value = _trimmed;
    if (value == null) {
      return _required(fieldName);
    }
    final parsed = value.length > 9 ? null : int.tryParse(value);
    if (parsed == null || parsed < min || parsed > max) {
      return _invalid(fieldName);
    }
    return _ok();
  }

  static bool _isAsciiDigit(int c) => c >= 0x30 && c <= 0x39;
}
