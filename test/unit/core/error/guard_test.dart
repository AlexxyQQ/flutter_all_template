import 'package:flutter_all_template/core/common/domain/entities/failure.dart';
import 'package:flutter_all_template/core/error/app_exception.dart';
import 'package:flutter_all_template/core/error/guard.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() => guardErrorReporter = (_, _) {});

  test('returns Right on success', () async {
    final result = await guard(() async => 42);
    expect(result.getRight().toNullable(), 42);
  });

  test('maps AppException to a typed Failure', () async {
    final cases = <AppException, FailureType>{
      const NetworkException(): FailureType.network,
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
      expect(failure.message, 'Email taken');
      expect(failure.fieldErrors, {'email': 'taken'});
    },
  );

  test('unexpected errors are reported and become Failure.unknown', () async {
    Object? reported;
    guardErrorReporter = (e, _) => reported = e;
    final error = StateError('bug');

    final result = await guard<void>(() async => throw error);

    expect(result.getLeft().toNullable(), const Failure.unknown());
    expect(reported, same(error));
  });
}
