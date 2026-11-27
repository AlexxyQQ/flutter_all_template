import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../config/constants/api/api_constants.dart';
import '../error/app_exception.dart';
import '../session/session.dart';
import 'dio_exception_mapper.dart';
import 'network_constants.dart';

/// Exchanges a refresh token for a new [AuthTokens] pair.
///
/// Replace the default implementation if your backend's refresh contract
/// differs (e.g. cookie-based refresh, different field names).
abstract interface class ITokenRefresher {
  /// Throws an `AppException` when the refresh is rejected or fails.
  Future<AuthTokens> refresh({required String refreshToken});
}

@LazySingleton(as: ITokenRefresher)
class DioTokenRefresher implements ITokenRefresher {
  DioTokenRefresher({@Named(NetworkNames.refreshDio) required Dio dio})
    : _dio = dio;

  final Dio _dio;

  @override
  Future<AuthTokens> refresh({required String refreshToken}) async {
    final Response<Object?> response;
    try {
      response = await _dio.post<Object?>(
        ApiConstants.refreshTokenPath,
        data: {ApiConstants.refreshRequestField: refreshToken},
        options: Options(
          extra: {
            RequestExtras.skipAuth: true,
            RequestExtras.isRefreshRequest: true,
          },
        ),
      );
    } on DioException catch (e) {
      throw mapDioException(exception: e);
    }

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const ParseException(debugMessage: 'Refresh: body is not a map');
    }
    final access = data[ApiConstants.accessTokenField];
    if (access is! String || access.isEmpty) {
      throw const ParseException(debugMessage: 'Refresh: no access token');
    }
    final newRefresh = data[ApiConstants.refreshTokenField];
    return AuthTokens(
      accessToken: access,
      // Keep the old refresh token if the backend doesn't rotate it.
      refreshToken: newRefresh is String && newRefresh.isNotEmpty
          ? newRefresh
          : refreshToken,
    );
  }
}
