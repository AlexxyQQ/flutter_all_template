import 'package:flutter_all_template/config/constants/gen/locale_keys.g.dart';
import 'package:flutter_all_template/core/error/app_exception.dart';
import 'package:flutter_all_template/core/error/failure.dart';
import 'package:flutter_all_template/core/error/guard.dart';
import 'package:flutter_all_template/core/error/guard_error_hook.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() => GuardErrorHook.onUnexpectedError = (_, _) {});

  test('returns Right on success', () async {
    final result = await guard(() async => 42);
    expect(result.getRight().toNullable(), 42);
  });

  test('maps AppException to a typed Failure', () async {
    final cases = <AppException, FailureType>{
      const NetworkException(): FailureType.network,
      const BadCertificateException(): FailureType.certificate,
      const RequestTimeoutException(): FailureType.timeout,
      const UnauthorizedException(): FailureType.unauthorized,
      const ForbiddenException(): FailureType.forbidden,
      const NotFoundException(): FailureType.notFound,
      const ValidationException(): FailureType.validation,
      const ServerException(statusCode: 502): FailureType.server,
      const ParseException(): FailureType.parse,
      const StorageException(): FailureType.storage,
    };
    for (final entry in cases.entries) {
      final result = await guard<void>(() async => throw entry.key);
      expect(result.getLeft().toNullable()?.type, entry.value);
    }
  });

  test(
    'validation server message and field errors are passed through',
    () async {
      final result = await guard<void>(
        () async => throw const ValidationException(
          serverMessage: 'Email taken',
          fieldErrors: {'email': 'taken'},
        ),
      );
      final failure = result.getLeft().toNullable()!;
      expect(failure.serverMessage, 'Email taken');
      expect(failure.messageKey, LocaleKeys.common_errors_network_case400);
      expect(failure.fieldErrors, {'email': 'taken'});
    },
  );

  test('a 422 keeps its real status code', () async {
    final result = await guard<void>(
      () async => throw const ValidationException(statusCode: 422),
    );
    expect(result.getLeft().toNullable()?.statusCode, 422);
  });

  test('a bad certificate has its own message, not "no internet"', () async {
    final result = await guard<void>(
      () async => throw const BadCertificateException(),
    );
    expect(
      result.getLeft().toNullable()?.messageKey,
      LocaleKeys.common_errors_network_badCertificate,
    );
  });

  test('a server message is shown for 4xx but never for 5xx', () async {
    final conflict = await guard<void>(
      () async => throw const ServerException(
        statusCode: 409,
        serverMessage: 'Already exists',
      ),
    );
    expect(conflict.getLeft().toNullable()?.serverMessage, 'Already exists');
  });

  test('unexpected errors are reported and become Failure.unknown', () async {
    Object? reported;
    GuardErrorHook.onUnexpectedError = (e, _) => reported = e;
    final error = StateError('bug');

    final result = await guard<void>(() async => throw error);

    expect(result.getLeft().toNullable(), const Failure.unknown());
    expect(reported, same(error));
  });
}
