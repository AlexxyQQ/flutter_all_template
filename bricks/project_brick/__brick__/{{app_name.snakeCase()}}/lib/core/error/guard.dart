import 'package:fpdart/fpdart.dart';

import '../../config/constants/gen/locale_keys.g.dart';
import 'app_exception.dart';
import 'failure.dart';
import 'guard_error_hook.dart';
import 'typedef.dart';

/// Runs [body] and converts any thrown error into a `Left(Failure)`.
///
/// This is the **only** place exceptions become failures. Repositories wrap
/// every data-source call with it:
///
/// ```dart
/// @override
/// ResultFuture<Todo> getTodo({required String id}) =>
///     guard(() async => (await _remote.getTodo(id: id)).toEntity());
/// ```
ResultFuture<T> guard<T>(Future<T> Function() body) async {
  try {
    return Right(await body());
  } on AppException catch (e) {
    return Left(mapExceptionToFailure(e));
  } catch (e, s) {
    GuardErrorHook.onUnexpectedError(e, s);
    return const Left(Failure.unknown());
  }
}

/// Maps a data-layer [AppException] to a user-safe domain [Failure].
Failure mapExceptionToFailure(AppException e) {
  return switch (e) {
    NetworkException() => const Failure(
      messageKey: LocaleKeys.common_errors_network_noInternet,
      type: FailureType.network,
    ),
    BadCertificateException() => const Failure(
      messageKey: LocaleKeys.common_errors_network_badCertificate,
      type: FailureType.certificate,
    ),
    RequestTimeoutException() => const Failure(
      messageKey: LocaleKeys.common_errors_network_connectionTimeout,
      type: FailureType.timeout,
    ),
    RequestCancelledException() => const Failure(
      messageKey: LocaleKeys.common_errors_network_canceledRequest,
      type: FailureType.cancelled,
    ),
    UnauthorizedException() => const Failure(
      messageKey: LocaleKeys.common_errors_network_case401,
      type: FailureType.unauthorized,
      statusCode: 401,
    ),
    ForbiddenException() => const Failure(
      messageKey: LocaleKeys.common_errors_network_case403,
      type: FailureType.forbidden,
      statusCode: 403,
    ),
    NotFoundException() => const Failure(
      messageKey: LocaleKeys.common_errors_network_case404,
      type: FailureType.notFound,
      statusCode: 404,
    ),
    ValidationException(
      :final statusCode,
      :final serverMessage,
      :final fieldErrors,
    ) =>
      Failure.validation(
        messageKey: LocaleKeys.common_errors_network_case400,
        serverMessage: serverMessage,
        statusCode: statusCode,
        fieldErrors: fieldErrors,
      ),
    ServerException(:final statusCode, :final serverMessage) => Failure(
      messageKey: statusCode == 503
          ? LocaleKeys.common_errors_network_case503
          : LocaleKeys.common_errors_network_case500,
      serverMessage: serverMessage,
      type: FailureType.server,
      statusCode: statusCode,
    ),
    ParseException() => const Failure(
      messageKey: LocaleKeys.common_errors_somethingWentWrong,
      type: FailureType.parse,
    ),
    StorageException() => const Failure(
      messageKey: LocaleKeys.common_errors_somethingWentWrong,
      type: FailureType.storage,
    ),
    CacheMissException() => const Failure(
      messageKey: LocaleKeys.common_errors_noDataFound,
      type: FailureType.cache,
    ),
    PermissionException() => const Failure(
      messageKey: LocaleKeys.common_errors_somethingWentWrong,
      type: FailureType.permission,
    ),
    UnknownException() => const Failure.unknown(),
  };
}
