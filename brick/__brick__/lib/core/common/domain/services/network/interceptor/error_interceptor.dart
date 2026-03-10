import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../config/constants/gen/locale_keys.g.dart';

@lazySingleton
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorDescription = '';

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorDescription = LocaleKeys.common_errors_network_connectionTimeout
            .tr();
      case DioExceptionType.badResponse:
        errorDescription = _handleStatusCode(
          err.response?.statusCode,
          err.response?.data,
        );
      case DioExceptionType.cancel:
        errorDescription = LocaleKeys.common_errors_network_canceledRequest
            .tr();
      case DioExceptionType.connectionError:
        errorDescription = LocaleKeys.common_errors_network_noInternet.tr();
      case DioExceptionType.unknown:
        errorDescription = LocaleKeys.common_errors_network_unexpectedError
            .tr();
      case DioExceptionType.badCertificate:
        errorDescription = LocaleKeys.common_errors_network_unauthorized.tr();
    }

    // Pass a new exception with the readable message to the UI
    return handler.next(
      DioException(
        requestOptions: err.requestOptions,
        error: errorDescription, // This is your readable string
        type: err.type,
        response: err.response,
        message: errorDescription,
      ),
    );
  }

  String _handleStatusCode(int? statusCode, dynamic errorData) {
    // You can parse specific backend error messages here if your API returns them
    // e.g. return errorData['message'] ?? "Unknown error";

    switch (statusCode) {
      case 400:
        return LocaleKeys.common_errors_network_case400.tr();
      case 401:
        return LocaleKeys.common_errors_network_case401.tr();
      case 403:
        return LocaleKeys.common_errors_network_case403.tr();
      case 404:
        return LocaleKeys.common_errors_network_case404.tr();
      case 500:
        return LocaleKeys.common_errors_network_case500.tr();
      case 503:
        return LocaleKeys.common_errors_network_case503.tr();
      default:
        return LocaleKeys.common_errors_network_invalidStatusCode.tr(
          namedArgs: {'statusCode': '$statusCode'},
        );
    }
  }
}
