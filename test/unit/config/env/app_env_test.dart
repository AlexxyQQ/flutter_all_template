import 'package:flutter_all_template/config/env/app_env.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppEnv.validate', () {
    test('accepts an absolute http(s) URL', () {
      expect(
        () => AppEnv.validate(url: 'https://api.example.com/v1/'),
        returnsNormally,
      );
      expect(
        () => AppEnv.validate(url: 'http://10.0.2.2:8080/api/v1/'),
        returnsNormally,
      );
    });

    test('fails fast with a fix hint when BASE_URL is empty', () {
      expect(
        () => AppEnv.validate(url: ''),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            allOf(contains('BASE_URL'), contains('--dart-define-from-file')),
          ),
        ),
      );
    });

    test('rejects relative URLs and other schemes', () {
      for (final url in ['api/v1', '/v1/', 'ftp://host/', 'https://']) {
        expect(() => AppEnv.validate(url: url), throwsStateError, reason: url);
      }
    });
  });
}
