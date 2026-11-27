import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../error/app_exception.dart';
import '../../../../error/failure.dart';

/// Turns arbitrary names, parameters and errors into values that are safe to
/// send to analytics backends.
///
/// Fail-closed: anything that looks like personal data or a credential
/// (e-mails, phone/card numbers, tokens, URLs, free text) is dropped rather
/// than masked, and so are parameter keys that usually carry such data.
/// Limits follow Firebase Analytics (names/keys 40, values 100 characters,
/// 25 parameters per event) so every destination accepts the same events.
@lazySingleton
class AnalyticsSanitizer {
  const AnalyticsSanitizer();

  static const int maxNameLength = 40;
  static const int maxValueLength = 100;
  static const int maxParameters = 25;
  static const int maxUserIdLength = 128;

  /// Key segments (split on `_`) that disqualify a parameter.
  static const Set<String> blockedKeySegments = {
    'address',
    'auth',
    'authorization',
    'birthday',
    'body',
    'card',
    'comment',
    'content',
    'cookie',
    'description',
    'dob',
    'email',
    'iban',
    'ip',
    'lat',
    'latitude',
    'lng',
    'location',
    'longitude',
    'mail',
    'message',
    'note',
    'pass',
    'passwd',
    'password',
    'phone',
    'pin',
    'query',
    'secret',
    'ssn',
    'text',
    'title',
    'token',
  };

  /// A blocked key is still allowed when it only *describes* the data with a
  /// number or a bool: `title_length`, `has_email`, `is_note_empty`.
  static const Set<String> derivedSuffixes = {
    'count',
    'empty',
    'length',
    'present',
    'size',
  };
  static const Set<String> derivedPrefixes = {'has', 'is'};

  static const List<String> _reservedPrefixes = ['firebase_', 'google_', 'ga_'];

  static final RegExp _camelBoundary = RegExp('(?<=[a-z0-9])(?=[A-Z])');
  static final RegExp _notNameChar = RegExp('[^a-z0-9_]+');
  static final RegExp _repeatedUnderscore = RegExp('_+');
  static final RegExp _notScreenChar = RegExp('[^A-Za-z0-9_]+');
  static final RegExp _localizationKey = RegExp(
    r'^[A-Za-z0-9_]+(\.[A-Za-z0-9_]+)+$',
  );
  static final RegExp _opaqueId = RegExp(r'^[A-Za-z0-9_\-:.]+$');
  static final List<RegExp> _sensitiveValues = [
    RegExp(r'[^@\s]+@[^@\s]+\.[^@\s]+'), // e-mail
    RegExp(r'\d[\d\s\-().]{6,}\d'), // phone / card / account numbers
    RegExp(r'eyJ[A-Za-z0-9_\-]+\.'), // JWT
    RegExp(r'\bbearer\s', caseSensitive: false),
    RegExp(r'[a-z][a-z0-9+.\-]*://', caseSensitive: false), // URLs
    RegExp(r'[A-Za-z0-9+/_\-]{32,}'), // long opaque secrets / keys
  ];

  /// `TodoCreated` / `todo-created` -> `todo_created`; `null` if nothing
  /// usable is left.
  String? eventName({required String raw}) {
    var name = raw
        .trim()
        .replaceAll(_camelBoundary, '_')
        .toLowerCase()
        .replaceAll(_notNameChar, '_')
        .replaceAll(_repeatedUnderscore, '_');
    name = _trimUnderscores(name);
    if (name.isEmpty) {
      return null;
    }
    if (!RegExp('^[a-z]').hasMatch(name) ||
        _reservedPrefixes.any(name.startsWith)) {
      name = 'app_$name';
    }
    return _trimUnderscores(_truncate(name, maxNameLength));
  }

  /// Route/screen names keep their casing (`TodoListRoute`); anything but
  /// letters, digits and `_` is removed.
  String? screenName({required String raw}) {
    final name = _truncate(raw.replaceAll(_notScreenChar, ''), maxValueLength);
    return name.isEmpty ? null : name;
  }

  /// Keeps only safe keys with `String`/`num`/`bool` values.
  Map<String, Object> parameters({required Map<String, Object?> raw}) {
    final result = <String, Object>{};
    for (final entry in raw.entries) {
      if (result.length >= maxParameters) {
        break;
      }
      final key = eventName(raw: entry.key);
      if (key == null) {
        continue;
      }
      final value = _value(entry.value);
      if (value == null || (_isBlockedKey(key) && !_isDerived(key, value))) {
        continue;
      }
      result[key] = value;
    }
    return result;
  }

  /// Returns [raw] when it is an opaque id; `null` for e-mails, phone
  /// numbers and other values that identify a person directly.
  String? userId({required String raw}) {
    final id = raw.trim();
    if (id.isEmpty ||
        id.length > maxUserIdLength ||
        !_opaqueId.hasMatch(id) ||
        id.contains('@') ||
        RegExp(r'^\+?\d{7,}$').hasMatch(id)) {
      return null;
    }
    return id;
  }

  /// Describes the *kind* of [error], never its message.
  Map<String, Object> describeError({required Object error}) {
    if (error is Failure) {
      return {
        'error_type': 'failure_${error.type.name}',
        'status_code': ?error.statusCode,
        if (_localizationKey.hasMatch(error.messageKey) &&
            error.messageKey.length <= maxValueLength)
          'error_key': error.messageKey,
      };
    }
    return {'error_type': _errorCategory(error)};
  }

  /// A fixed vocabulary instead of `runtimeType.toString()`, which is mangled
  /// by `--obfuscate` and would make release data meaningless.
  static String _errorCategory(Object error) => switch (error) {
    NetworkException() => 'app_network',
    RequestTimeoutException() => 'app_timeout',
    RequestCancelledException() => 'app_cancelled',
    UnauthorizedException() => 'app_unauthorized',
    ForbiddenException() => 'app_forbidden',
    NotFoundException() => 'app_not_found',
    ValidationException() => 'app_validation',
    ServerException() => 'app_server',
    ParseException() => 'app_parse',
    StorageException() => 'app_storage',
    CacheMissException() => 'app_cache_miss',
    PermissionException() => 'app_permission',
    UnknownException() => 'app_unknown',
    TimeoutException() => 'timeout',
    FormatException() => 'format',
    StateError() => 'state',
    ArgumentError() => 'argument',
    UnsupportedError() => 'unsupported',
    FlutterError() => 'flutter', // before AssertionError, which it implements
    AssertionError() => 'assertion',
    TypeError() => 'type',
    _ => 'unknown',
  };

  bool _isBlockedKey(String key) =>
      key.split('_').any(blockedKeySegments.contains);

  bool _isDerived(String key, Object value) {
    if (value is! num && value is! bool) {
      return false;
    }
    final segments = key.split('_');
    return derivedSuffixes.contains(segments.last) ||
        derivedPrefixes.contains(segments.first);
  }

  Object? _value(Object? value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value.isFinite ? value : null;
    }
    if (value is Enum) {
      return value.name;
    }
    if (value is String) {
      final text = value.trim();
      if (text.isEmpty ||
          text.length > maxValueLength ||
          _sensitiveValues.any((p) => p.hasMatch(text))) {
        return null;
      }
      return text;
    }
    return null;
  }

  static String _truncate(String value, int max) =>
      value.length <= max ? value : value.substring(0, max);

  static String _trimUnderscores(String value) {
    var start = 0;
    var end = value.length;
    while (start < end && value[start] == '_') {
      start++;
    }
    while (end > start && value[end - 1] == '_') {
      end--;
    }
    return value.substring(start, end);
  }
}
