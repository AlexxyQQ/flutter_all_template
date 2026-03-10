import 'package:easy_localization/easy_localization.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../config/constants/gen/locale_keys.g.dart';

extension FormFieldValidator on String? {
  // Validate email
  Either<String, bool> validateEmail({
    String fieldName =
        LocaleKeys.common_form_field_titles_email, // Default to "Email"
  }) {
    final value = this;
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9]+[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    );
    if (value == null || value.isEmpty) {
      return Left(
        LocaleKeys.common_errors_validation_required.tr(
          namedArgs: {'field': fieldName.tr()},
        ),
      );
    } else if (!emailRegExp.hasMatch(value)) {
      return Left(
        LocaleKeys.common_errors_validation_invalid.tr(
          namedArgs: {'field': fieldName.tr()},
        ),
      );
    }
    return const Right(true);
  }

  // Validate password
  Either<String, bool> validatePassword({
    int minLength = 8,
    String fieldName =
        LocaleKeys.common_form_field_titles_password, // Default to "Password"
  }) {
    final value = this;
    if (value == null || value.isEmpty) {
      return Left(
        LocaleKeys.common_errors_validation_required.tr(
          namedArgs: {'field': fieldName.tr()},
        ),
      );
    }
    if (value.length < minLength) {
      return Left(
        LocaleKeys.common_errors_validation_minLength.tr(
          namedArgs: {
            'field': fieldName.tr(),
            'minLength': minLength.toString(),
          },
        ),
      );
    }
    final hasUppercase = value.contains(RegExp(r'[A-Z]'));
    final hasDigits = value.contains(RegExp(r'[0-9]'));
    final hasLowercase = value.contains(RegExp(r'[a-z]'));
    // final hasSpecialCharacters = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (!hasUppercase) {
      return Left(
        LocaleKeys.common_errors_validation_uppercaseRequired.tr(
          namedArgs: {'field': fieldName.tr()},
        ),
      );
    }
    if (!hasLowercase) {
      return Left(
        LocaleKeys.common_errors_validation_lowercaseRequired.tr(
          namedArgs: {'field': fieldName.tr()},
        ),
      );
    }
    if (!hasDigits) {
      return Left(
        LocaleKeys.common_errors_validation_numberRequired.tr(
          namedArgs: {'field': fieldName.tr()},
        ),
      );
    }
    // if (!hasSpecialCharacters) {
    //   return Left(
    //     LocaleKeys.common_errors_validation_specialCharacterRequired
    //         .tr(namedArgs: {'field': fieldName.tr()}),
    //   );
    // }

    return const Right(true);
  }

  // Validate Confirm password
  Either<String, bool> validateConfirmPassword(
    String password, {
    String fieldName = LocaleKeys.common_form_field_titles_confirmPassword,
  }) {
    final value = this;
    if (value == null || value.isEmpty) {
      return Left(
        LocaleKeys.common_errors_validation_required.tr(
          namedArgs: {'field': fieldName.tr()},
        ),
      );
    }
    if (value != password) {
      return Left(
        LocaleKeys.common_errors_validation_doesNotMatch.tr(
          namedArgs: {
            'newField': fieldName.tr(),
            'oldField': LocaleKeys.common_form_field_titles_password.tr(),
          },
        ),
      );
    }
    return const Right(true);
  }

  // Validate phone number
  Either<String, bool> validatePhoneNumber({
    String fieldName = LocaleKeys
        .common_form_field_titles_phoneNumber, // Default to "Phone number"
  }) {
    final value = this;
    final phoneRegExp = RegExp(r'^\+?[0-9]{7,15}$');
    if (value == null || value.isEmpty) {
      return Left(
        LocaleKeys.common_errors_validation_required.tr(
          namedArgs: {'field': fieldName.tr()},
        ),
      );
    } else if (!phoneRegExp.hasMatch(value)) {
      return Left(
        LocaleKeys.common_errors_validation_invalid.tr(
          namedArgs: {'field': fieldName.tr()},
        ),
      );
    }
    return const Right(true);
  }

  // Validate if it's not empty
  Either<String, bool> validateNotEmpty({required String fieldName}) {
    final value = this;
    if (value == null || value.trim().isEmpty) {
      return Left(
        LocaleKeys.common_errors_validation_required.tr(
          namedArgs: {'field': fieldName.tr()},
        ),
      );
    }
    return const Right(true);
  }

  // Validate URL
  Either<String, bool> validateUrl({
    String fieldName = LocaleKeys.common_form_field_titles_url,
  }) {
    final value = this;
    // Basic URL regex
    final urlRegExp = RegExp(
      r'^(https?|ftp)://[^\s/$.?#].[^\s]*$',
      caseSensitive: false,
    );
    if (value == null || value.isEmpty) {
      return Left(
        LocaleKeys.common_errors_validation_required.tr(
          namedArgs: {'field': fieldName.tr()},
        ),
      );
    } else if (!urlRegExp.hasMatch(value)) {
      return Left(
        LocaleKeys.common_errors_validation_invalid.tr(
          namedArgs: {'field': fieldName.tr()},
        ),
      );
    }
    return const Right(true);
  }

  // Validate postal code
  Either<String, bool> validatePostalCode({
    String fieldName = LocaleKeys.common_form_field_titles_postalCode,
  }) {
    final value = this;
    // Numbers and letters(upper or lower) and spaces and hyphens
    final postalRegExp = RegExp(r'^[a-zA-Z0-9\s\-]{4,10}$');
    if (value == null || value.isEmpty) {
      return Left(
        LocaleKeys.common_errors_validation_required.tr(
          namedArgs: {'field': fieldName.tr()},
        ),
      );
    } else if (!postalRegExp.hasMatch(value)) {
      return Left(
        LocaleKeys.common_errors_validation_invalid.tr(
          namedArgs: {'field': fieldName.tr()},
        ),
      );
    }
    return const Right(true);
  }

  // Validate name
  Either<String, bool> validateName({
    String fieldName = LocaleKeys.common_form_field_titles_fullName,
  }) {
    final value = this;
    final nameRegExp = RegExp(r'^[a-zA-Z\s]+$');
    if (value == null || value.isEmpty) {
      return Left(
        LocaleKeys.common_errors_validation_required.tr(
          namedArgs: {'field': fieldName.tr()},
        ),
      );
    } else if (!nameRegExp.hasMatch(value)) {
      return Left(
        LocaleKeys.common_errors_validation_invalid.tr(
          namedArgs: {'field': fieldName.tr()},
        ),
      );
    }
    return const Right(true);
  }

  // Validate credit card using Luhn Algorithm
  Either<String, bool> validateCreditCard({
    String fieldName = LocaleKeys.common_form_field_titles_creditCardNumber,
  }) {
    final value = this;
    if (value == null || value.isEmpty) {
      return Left(
        LocaleKeys.common_errors_validation_required.tr(
          namedArgs: {'field': fieldName.tr()},
        ),
      );
    }
    final sanitized = value.replaceAll(RegExp(r'\D'), '');
    if (sanitized.length < 13 || sanitized.length > 19) {
      return Left(
        LocaleKeys.common_errors_validation_minLength.tr(
          namedArgs: {'field': fieldName.tr(), 'minLength': '13'},
        ),
      );
    }

    int sum = 0;
    bool shouldDouble = false;
    for (int i = sanitized.length - 1; i >= 0; i--) {
      int digit = int.parse(sanitized[i]);

      if (shouldDouble) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }

      sum += digit;
      shouldDouble = !shouldDouble;
    }

    if (sum % 10 != 0) {
      return Left(LocaleKeys.common_errors_validation_invalidCreditCard.tr());
    }

    return const Right(true);
  }

  Either<String, bool> validateAccountNumber({
    String fieldName = LocaleKeys.common_form_field_titles_accountNumber,
  }) {
    final value = this;
    final accountNumberRegex = RegExp(r'^[A-Z0-9]+$');

    if (value == null || value.isEmpty) {
      return Left(
        LocaleKeys.common_errors_validation_required.tr(
          namedArgs: {'field': fieldName.tr()},
        ),
      );
    }

    final sanitized = value.replaceAll(' ', '');

    if (sanitized.length < 8 || sanitized.length > 20) {
      return Left(
        LocaleKeys.common_errors_validation_minLength.tr(
          namedArgs: {'field': fieldName.tr(), 'minLength': '8'},
        ),
      );
    }

    if (!accountNumberRegex.hasMatch(sanitized)) {
      return Left(
        LocaleKeys.common_errors_validation_invalid.tr(
          namedArgs: {'field': fieldName.tr()},
        ),
      );
    }

    return const Right(true);
  }

  // Validate OTP
  /// Requires the OTP to be exactly 6 characters long
  /// Requires the OTP to be numeric
  /// Requires the OTP to be not empty

  Either<String, bool> validateOtp({
    String fieldName =
        'LocaleKeys.common_commonErrors_otpFill', // FIXED: Removed quotes
  }) {
    final value = this;
    final otpRegExp = RegExp(r'^[0-9]{6}$');
    if (value == null || value.isEmpty) {
      return Left(
        LocaleKeys.common_errors_validation_required.tr(
          namedArgs: {'field': fieldName.tr()},
        ),
      );
    } else if (!otpRegExp.hasMatch(value)) {
      return Left(
        LocaleKeys.common_errors_validation_invalid.tr(
          namedArgs: {'field': fieldName.tr()},
        ),
      );
    }
    return const Right(true);
  }

  // Validate Money
  Either<String, bool> validateMoney({required String fieldName}) {
    final value = this;
    final moneyRegExp = RegExp(r'^[0-9]+(\.[0-9]{1,2})?$');
    if (value == null || value.isEmpty) {
      return Left(
        LocaleKeys.common_errors_validation_required.tr(
          namedArgs: {'field': fieldName.tr()},
        ),
      );
    } else if (!moneyRegExp.hasMatch(value)) {
      return Left(
        LocaleKeys.common_errors_validation_invalid.tr(
          namedArgs: {'field': fieldName.tr()},
        ),
      );
    }
    return const Right(true);
  }

  // Social Media Handle
  Either<String, bool> validateSocialMediaHandle({required String fieldName}) {
    // FIXED: Typo
    final value = this;
    final socialMediaValidationRegExp = RegExp(
      r'^(?:(?=.{1,30}$)[A-Za-z0-9._]+|(?=.{2,24}$)[A-Za-z0-9._]+|(?=.{1,15}$)[A-Za-z0-9_]+|@[A-Za-z0-9_]{3,15})$',
    );
    if (value == null || value.isEmpty) {
      return Left(
        LocaleKeys.common_errors_validation_required.tr(
          namedArgs: {'field': fieldName.tr()},
        ),
      );
    } else if (!socialMediaValidationRegExp.hasMatch(value)) {
      return Left(
        LocaleKeys.common_errors_validation_invalid.tr(
          namedArgs: {'field': fieldName.tr()},
        ),
      );
    }
    return const Right(true);
  }

  Either<String, bool> validateHours({
    String fieldName =
        'Hours', // Replace with LocaleKeys.common_form_field_titles_hours if available
    int min = 0,
    int max = 23,
  }) {
    final value = this;

    // 1. Check if empty
    if (value == null || value.trim().isEmpty) {
      return Left(
        LocaleKeys.common_errors_validation_required.tr(
          namedArgs: {'field': fieldName.tr()},
        ),
      );
    }

    final intValue = int.tryParse(value);

    // 2. Check if it is a valid number
    if (intValue == null) {
      return Left(
        LocaleKeys.common_errors_validation_invalid.tr(
          namedArgs: {'field': fieldName.tr()},
        ),
      );
    }

    // 3. Check Range (Default 0 - 23)
    if (intValue < min || intValue > max) {
      return Left(
        LocaleKeys.common_errors_validation_invalid.tr(
          namedArgs: {'field': fieldName.tr()},
        ),
      );
    }

    return const Right(true);
  }

  // Validate Minutes
  /// Validates if the string is a valid minute (0-59)
  Either<String, bool> validateMinutes({
    String fieldName =
        'Minutes', // Replace with LocaleKeys.common_form_field_titles_minutes if available
    int min = 0,
    int max = 59,
  }) {
    final value = this;

    // 1. Check if empty
    if (value == null || value.trim().isEmpty) {
      return Left(
        LocaleKeys.common_errors_validation_required.tr(
          namedArgs: {'field': fieldName.tr()},
        ),
      );
    }

    final intValue = int.tryParse(value);

    // 2. Check if it is a valid number
    if (intValue == null) {
      return Left(
        LocaleKeys.common_errors_validation_invalid.tr(
          namedArgs: {'field': fieldName.tr()},
        ),
      );
    }

    // 3. Check Range (Default 0 - 59)
    if (intValue < min || intValue > max) {
      return Left(
        LocaleKeys.common_errors_validation_invalid.tr(
          namedArgs: {'field': fieldName.tr()},
        ),
      );
    }

    return const Right(true);
  }

  // Username Validation
  Either<String, bool> validateUsername({
    String fieldName = LocaleKeys.common_form_field_titles_username,
  }) {
    final value = this;

    // Updated Regex: Allows lowercase/uppercase letters, numbers, underscores, and dots.
    // Disallows spaces. Enforces a length between 3 and 20 characters.
    final usernameRegExp = RegExp(r'^[a-zA-Z0-9_.]{3,20}$');

    // Added .trim() to ensure a string of just spaces is caught as empty
    if (value == null || value.trim().isEmpty) {
      return Left(
        LocaleKeys.common_errors_validation_required.tr(
          namedArgs: {'field': fieldName.tr()},
        ),
      );
    } else if (!usernameRegExp.hasMatch(value)) {
      return Left(
        LocaleKeys.common_errors_validation_invalid.tr(
          namedArgs: {'field': fieldName.tr()},
        ),
      );
    }

    return const Right(true);
  }

  Either<String, bool> validateFullName({
    // Assuming you have a locale key for full name, adjust if needed
    String fieldName = LocaleKeys.common_form_field_titles_fullName,
  }) {
    final value = this;

    // Regex: Allows upper/lowercase letters, spaces, hyphens, and apostrophes.
    final fullNameRegExp = RegExp(r"^[a-zA-Z\s\-']+$");

    if (value == null || value.trim().isEmpty) {
      return Left(
        LocaleKeys.common_errors_validation_required.tr(
          namedArgs: {'field': fieldName.tr()},
        ),
      );
    } else if (!fullNameRegExp.hasMatch(value.trim())) {
      return Left(
        LocaleKeys.common_errors_validation_invalid.tr(
          namedArgs: {'field': fieldName.tr()},
        ),
      );
    }

    return const Right(true);
  }
}
