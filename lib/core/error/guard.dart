import 'package:fpdart/fpdart.dart';

import '../../config/constants/gen/locale_keys.g.dart';
import '../../config/constants/type_defs/typedef.dart';
import '../common/domain/entities/failure.dart';
import 'app_exception.dart';

/// Hook used to report unexpected (non-[AppException]) errors caught by
/// [guard]. Set once in bootstrap to forward to the logger / crash reporter.
/// Defaults to a no-op so pure unit tests need no setup.
typedef GuardErrorReporter = void Function(Object error, StackTrace stackTrace);

GuardErrorReporter guardErrorReporter = (_, _) {};

/// Runs [body] and converts any thrown error into a `Left(Failure)`.
///
/// This is the **only** place exceptions become failures. Repositories wrap
/// every data-source call with it:
///
/// ```dart
/// @override
/// ResultFuture<Todo> getTodo(String id) =>
///     guard(() async => (await _remote.getTodo(id)).toEntity());
/// ```
ResultFuture<T> guard<T>(Future<T> Function() body) async {
  try {
    return Right(await body());
  } on AppException catch (e) {
    return Left(mapExceptionToFailure(e));
  } catch (e, s) {
    guardErrorReporter(e, s);
    return const Left(Failure.unknown());
  }
}

/// Maps a data-layer [AppException] to a user-safe domain [Failure].
Failure mapExceptionToFailure(AppException e) {
  return switch (e) {
    NetworkException() => const Failure(
      message: LocaleKeys.common_errors_network_noInternet,
      type: FailureType.network,
    ),
    RequestTimeoutException() => const Failure(
      message: LocaleKeys.common_errors_network_connectionTimeout,
      type: FailureType.timeout,
    ),
    RequestCancelledException() => const Failure(
      message: LocaleKeys.common_errors_network_canceledRequest,
      type: FailureType.cancelled,
    ),
    UnauthorizedException() => const Failure(
      message: LocaleKeys.common_errors_network_case401,
      type: FailureType.unauthorized,
      statusCode: 401,
    ),
    ForbiddenException() => const Failure(
      message: LocaleKeys.common_errors_network_case403,
      type: FailureType.forbidden,
      statusCode: 403,
    ),
    NotFoundException() => const Failure(
      message: LocaleKeys.common_errors_network_case404,
      type: FailureType.notFound,
      statusCode: 404,
    ),
    ValidationException(:final serverMessage, :final fieldErrors) => Failure(
      message: serverMessage ?? LocaleKeys.common_errors_network_case400,
      type: FailureType.validation,
      statusCode: 400,
      fieldErrors: fieldErrors,
    ),
    ServerException(:final statusCode, :final serverMessage) => Failure(
      message:
          serverMessage ??
          (statusCode == 503
              ? LocaleKeys.common_errors_network_case503
              : LocaleKeys.common_errors_network_case500),
      type: FailureType.server,
      statusCode: statusCode,
    ),
    ParseException() => const Failure(
      message: LocaleKeys.common_errors_somethingWentWrong,
      type: FailureType.parse,
    ),
    StorageException() => const Failure(
      message: LocaleKeys.common_errors_somethingWentWrong,
      type: FailureType.storage,
    ),
    CacheMissException() => const Failure(
      message: LocaleKeys.common_errors_noDataFound,
      type: FailureType.cache,
    ),
    PermissionException() => const Failure(
      message: LocaleKeys.common_errors_somethingWentWrong,
      type: FailureType.permission,
    ),
    UnknownException() => const Failure.unknown(),
  };
}
