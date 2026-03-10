import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../config/constants/gen/locale_keys.g.dart';

@lazySingleton
class ConnectivityInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final connectivityResult = await Connectivity().checkConnectivity();

    // Check if the device is purely offline
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return handler.reject(
        DioException(
          requestOptions: options,
          error: LocaleKeys.common_errors_network_noInternet.tr(),
          type: DioExceptionType.connectionError,
        ),
      );
    }

    return handler.next(options);
  }
}
