import 'package:intl/intl.dart';

import '../../../../../config/constants/gen/locale_keys.g.dart';

// 1. Extension for Nullable Numbers (int?, double?, num?)
extension CurrencyNumExtension on num? {
  String toCurrency({
    String? locale = 'en_IN', // e.g. 'en_US' or 'en_IN'
    String? symbol = LocaleKeys.common_currencies_symbol_NPR,
    String? name, // e.g. 'USD'
    int decimalDigits = 2,
    bool enableSymbol = true,
  }) {
    // Treat null as 0.0
    final value = this ?? 0.0;

    final formatter = NumberFormat.currency(
      locale: locale ?? 'en_US',
      name: name,
      symbol: enableSymbol ? symbol : '',
      decimalDigits: decimalDigits,
    );

    return formatter.format(value);
  }
}

// 2. Extension for Nullable Strings
extension CurrencyStringExtension on String? {
  String toCurrency({
    String? locale = 'en_IN',
    String? symbol = LocaleKeys.common_currencies_symbol_NPR,
    String? name,
    int decimalDigits = 2,
    bool enableSymbol = true,
  }) {
    // 1. Handle Nulls and "null" strings
    if (this == null || this!.isEmpty || this == 'null') {
      return (0.0).toCurrency(
        locale: locale,
        symbol: symbol,
        name: name,
        decimalDigits: decimalDigits,
        enableSymbol: enableSymbol,
      );
    }

    // 2. Sanitize: Remove commas so parse doesn't fail (e.g. "1,000")
    final cleanString = this!.replaceAll(',', '').trim();

    // 3. Parse: If parse fails (e.g. "***"), default to 0.0
    final number = double.tryParse(cleanString) ?? 0.0;

    // 4. Format
    return number.toCurrency(
      locale: locale,
      symbol: symbol,
      name: name,
      decimalDigits: decimalDigits,
      enableSymbol: enableSymbol,
    );
  }
}
