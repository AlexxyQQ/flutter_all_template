/// An extension on the `String` class to provide easy-to-use case conversion getters.
extension CaseConverter on String {
  /// A robust private helper to split a string into a list of words.
  /// It handles various separators like spaces, underscores, hyphens,
  /// and transitions from lowercase to uppercase letters (camelCase).
  List<String> _getWords() {
    if (trim().isEmpty) return [];

    // This regex sequence first adds a space before any uppercase letter
    // that follows a lowercase letter or a number, effectively splitting camelCase.
    // It also handles acronyms by adding a space before the last capital in a sequence
    // followed by a lowercase letter (e.g., "HTTPRequest" -> "HTTP Request").
    // Finally, it replaces underscores and hyphens with spaces.
    final String spacedString =
        replaceAllMapped(
              RegExp(r'(?<=[a-z0-9])[A-Z]'),
              (Match match) => ' ${match.group(0)}',
            )
            .replaceAllMapped(
              RegExp(r'(?<=[A-Z])[A-Z](?=[a-z])'),
              (Match match) => ' ${match.group(0)}',
            )
            .replaceAll(RegExp(r'[-_]'), ' ');

    // The resulting string is split by whitespace, filtered for empty parts,
    // and converted to lowercase.
    return spacedString
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .map((word) => word.toLowerCase())
        .toList();
  }

  /// A private helper to capitalize the first letter of a string.
  String _capitalize() =>
      isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';

  /// Converts the string to **camelCase**.
  ///
  /// Example: `'convert this string'` -> `'convertThisString'`
  String get toCamelCase {
    final words = _getWords();
    if (words.isEmpty) return '';
    final firstWord = words.first;
    final otherWords = words.sublist(1).map((word) => word._capitalize());
    return [firstWord, ...otherWords].join();
  }

  /// Converts the string to **PascalCase** (or UpperCamelCase).
  ///
  /// Example: `'convert this string'` -> `'ConvertThisString'`
  String get toPascalCase {
    return _getWords().map((word) => word._capitalize()).join();
  }

  /// Converts the string to **snake_case**.
  ///
  /// Example: `'Convert This String'` -> `'convert_this_string'`
  String get toSnakeCase {
    return _getWords().join('_');
  }

  /// Converts the string to **kebab-case**.
  ///
  /// Example: `'Convert This String'` -> `'convert-this-string'`
  String get toKebabCase {
    return _getWords().join('-');
  }

  /// Converts the string to **CONSTANT_CASE** (or SCREAMING_SNAKE_CASE).
  ///
  /// Example: `'Convert This String'` -> `'CONVERT_THIS_STRING'`
  String get toConstantCase {
    return _getWords().map((word) => word.toUpperCase()).join('_');
  }

  /// Converts the string to **Title Case**.
  ///
  /// Example: `'convert_this_string'` -> `'Convert This String'`
  String get toTitleCase {
    return _getWords().map((word) => word._capitalize()).join(' ');
  }

  /// Converts the string to **Sentence case**.
  ///
  /// Example: `'convert_this_string'` -> `'Convert this string'`
  String get toSentenceCase {
    final words = _getWords();
    if (words.isEmpty) return '';
    return '${words.first._capitalize()} ${words.sublist(1).join(' ')}'.trim();
  }

  /// Converts the string to **dot.case**.
  ///
  /// Example: `'Convert This String'` -> `'convert.this.string'`
  String get toDotCase {
    return _getWords().join('.');
  }

  String get removeHtmlTags {
    if (isEmpty) return '';

    // 1. Remove HTML tags using Regex (matches <...>)
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true);
    String text = replaceAll(exp, '');

    // 2. Decode common HTML entities to make text readable
    // You can add more here if your API returns specific ones
    const Map<String, String> entityMap = {
      '&nbsp;': ' ',
      '&amp;': '&',
      '&quot;': '"',
      '&apos;': "'",
      '&lt;': '<',
      '&gt;': '>',
    };

    entityMap.forEach((key, value) {
      text = text.replaceAll(key, value);
    });

    // 3. Trim extra whitespace that might result from tag removal
    return text.trim();
  }
}
