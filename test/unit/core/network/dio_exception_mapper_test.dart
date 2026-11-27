import 'package:dio/dio.dart';
import 'package:flutter_all_template/core/error/app_exception.dart';
import 'package:flutter_all_template/core/network/dio_exception_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final requestOptions = RequestOptions(path: '/items');

  DioException dioError(
    DioExceptionType type, {
    int? status,
    Object? body,
    Object? error,
  }) => DioException(
    requestOptions: requestOptions,
    type: type,
    error: error,
    response: status == null
        ? null
        : Response<Object?>(
            requestOptions: requestOptions,
            statusCode: status,
            data: body,
          ),
  );

  test('every timeout kind, including transformTimeout, is a timeout', () {
    for (final type in [
      DioExceptionType.connectionTimeout,
      DioExceptionType.sendTimeout,
      DioExceptionType.receiveTimeout,
      DioExceptionType.transformTimeout,
    ]) {
      expect(
        mapDioException(exception: dioError(type)),
        isA<RequestTimeoutException>(),
        reason: type.name,
      );
    }
  });

  test('connection errors are NetworkException', () {
    expect(
      mapDioException(exception: dioError(DioExceptionType.connectionError)),
      isA<NetworkException>(),
    );
  });

  test('a bad certificate is not reported as offline', () {
    expect(
      mapDioException(exception: dioError(DioExceptionType.badCertificate)),
      isA<BadCertificateException>(),
    );
  });

  test('cancel and unknown map to their own exceptions', () {
    expect(
      mapDioException(exception: dioError(DioExceptionType.cancel)),
      isA<RequestCancelledException>(),
    );
    expect(
      mapDioException(exception: dioError(DioExceptionType.unknown)),
      isA<UnknownException>(),
    );
  });

  test('an AppException carried as the error is returned as is', () {
    const inner = UnauthorizedException();
    expect(
      mapDioException(
        exception: dioError(DioExceptionType.unknown, error: inner),
      ),
      same(inner),
    );
  });

  test('the debug message has method and path but no body', () {
    final mapped = mapDioException(
      exception: dioError(
        DioExceptionType.badResponse,
        status: 500,
        body: {'secret': 'value'},
      ),
    );
    expect(mapped.debugMessage, 'HTTP 500: GET /items');
  });

  group('mapStatusCode', () {
    test('400 and 422 are validation errors that keep their status', () {
      final bad = mapStatusCode(statusCode: 400, body: null);
      final unprocessable = mapStatusCode(statusCode: 422, body: null);

      expect((bad as ValidationException).statusCode, 400);
      expect((unprocessable as ValidationException).statusCode, 422);
    });

    test('validation reads message and field errors from the body', () {
      final mapped =
          mapStatusCode(
                statusCode: 422,
                body: {
                  'message': 'Invalid',
                  'errors': {
                    'email': ['taken', 'other'],
                    'name': 'required',
                  },
                },
              )
              as ValidationException;

      expect(mapped.serverMessage, 'Invalid');
      expect(mapped.fieldErrors, {'email': 'taken', 'name': 'required'});
    });

    test('401, 403 and 404 have their own exceptions', () {
      expect(
        mapStatusCode(statusCode: 401, body: null),
        isA<UnauthorizedException>(),
      );
      expect(
        mapStatusCode(statusCode: 403, body: null),
        isA<ForbiddenException>(),
      );
      expect(
        mapStatusCode(statusCode: 404, body: null),
        isA<NotFoundException>(),
      );
    });

    test('other 4xx keep the backend message, 5xx never do', () {
      final conflict =
          mapStatusCode(statusCode: 409, body: {'message': 'Already exists'})
              as ServerException;
      final crash =
          mapStatusCode(statusCode: 500, body: {'message': 'NPE at line 4'})
              as ServerException;

      expect(conflict.serverMessage, 'Already exists');
      expect(crash.serverMessage, isNull);
      expect(crash.statusCode, 500);
    });

    test('a blank or non-string message is ignored', () {
      final blank =
          mapStatusCode(statusCode: 409, body: {'message': '  '})
              as ServerException;
      final number =
          mapStatusCode(statusCode: 409, body: {'message': 5})
              as ServerException;

      expect(blank.serverMessage, isNull);
      expect(number.serverMessage, isNull);
    });
  });
}
