import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/models/helpers/model_conversion_helper.dart';
import '../../../../features/app_settings/domain/repositories/app_setting_repository.dart';

@lazySingleton
class AuthenticationInterceptor extends Interceptor {
  AuthenticationInterceptor({required IAppSettingRepository appSettingRepo})
    : _appSettingRepo = appSettingRepo;

  final IAppSettingRepository _appSettingRepo;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = (await _appSettingRepo.getSetting().rightOrNull)?.token;

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }
}
