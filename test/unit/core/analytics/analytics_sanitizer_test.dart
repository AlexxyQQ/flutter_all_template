import 'package:flutter_all_template/core/common/domain/entities/failure.dart';
import 'package:flutter_all_template/core/common/domain/services/analytics/helpers/analytics_sanitizer.dart';
import 'package:flutter_all_template/core/error/app_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const sanitizer = AnalyticsSanitizer();

  group('eventName', () {
    test('normalizes to snake_case', () {
      expect(sanitizer.eventName(raw: 'TodoCreated'), 'todo_created');
      expect(sanitizer.eventName(raw: ' todo-create  now '), 'todo_create_now');
    });

    test('avoids reserved prefixes and leading digits', () {
      expect(sanitizer.eventName(raw: 'firebase_tap'), 'app_firebase_tap');
      expect(sanitizer.eventName(raw: '1st_tap'), 'app_1st_tap');
    });

    test('is at most 40 characters and null when nothing is left', () {
      expect(sanitizer.eventName(raw: 'a' * 60), hasLength(40));
      expect(sanitizer.eventName(raw: '!!!'), isNull);
    });
  });

  group('parameters', () {
    test('keeps safe primitive values', () {
      expect(
        sanitizer.parameters(
          raw: {'count': 3, 'is_done': true, 'filter': 'open', 'ratio': 0.5},
        ),
        {'count': 3, 'is_done': true, 'filter': 'open', 'ratio': 0.5},
      );
    });

    test('drops keys that usually carry personal data or secrets', () {
      expect(
        sanitizer.parameters(
          raw: {
            'email': 'x',
            'user_phone': 'x',
            'title': 'Buy milk',
            'search_query': 'milk',
            'auth_token': 'x',
            'error_message': 'x',
          },
        ),
        isEmpty,
      );
    });

    test('allows numeric/bool descriptions of sensitive fields', () {
      expect(
        sanitizer.parameters(
          raw: {
            'title_length': 8,
            'has_email': true,
            'query_length': 4,
            'title_present': 'yes', // a string could be the data itself
          },
        ),
        {'title_length': 8, 'has_email': true, 'query_length': 4},
      );
    });

    test('drops values that look like personal data or credentials', () {
      expect(
        sanitizer.parameters(
          raw: {
            'a': 'jane@example.com',
            'b': '+977 981-234-5678',
            'c': 'eyJhbGciOiJIUzI1NiJ9.payload.sig',
            'd': 'Bearer abc',
            'e': 'https://example.com/?code=1',
            'f': 'x' * 32,
            'g': 'x' * 101,
            'h': double.nan,
            'i': const Object(),
          },
        ),
        isEmpty,
      );
    });

    test('keeps at most 25 parameters', () {
      final raw = {for (var i = 0; i < 40; i++) 'p$i': i};
      expect(sanitizer.parameters(raw: raw), hasLength(25));
    });
  });

  group('userId', () {
    test('accepts opaque ids', () {
      expect(sanitizer.userId(raw: 'usr_123'), 'usr_123');
      expect(
        sanitizer.userId(raw: '9b2f6c1e-1d2a-4f3b-8c5d-6e7f8a9b0c1d'),
        '9b2f6c1e-1d2a-4f3b-8c5d-6e7f8a9b0c1d',
      );
    });

    test('rejects e-mails, phone numbers and free text', () {
      expect(sanitizer.userId(raw: 'jane@example.com'), isNull);
      expect(sanitizer.userId(raw: '+9779812345678'), isNull);
      expect(sanitizer.userId(raw: 'Jane Doe'), isNull);
      expect(sanitizer.userId(raw: ''), isNull);
    });
  });

  group('describeError', () {
    test('describes a failure by type, status and localization key', () {
      expect(
        sanitizer.describeError(
          error: const Failure(
            message: 'common.errors.network.case500',
            type: FailureType.server,
            statusCode: 500,
          ),
        ),
        {
          'error_type': 'failure_server',
          'status_code': 500,
          'error_key': 'common.errors.network.case500',
        },
      );
    });

    test('omits a failure message that is not a localization key', () {
      expect(
        sanitizer.describeError(
          error: const Failure(
            message: 'Email jane@example.com is taken',
            type: FailureType.validation,
          ),
        ),
        {'error_type': 'failure_validation'},
      );
    });

    test('describes other errors by type only', () {
      expect(
        sanitizer.describeError(
          error: const NetworkException(debugMessage: 'GET /users/jane'),
        ),
        {'error_type': 'NetworkException'},
      );
    });
  });
}
