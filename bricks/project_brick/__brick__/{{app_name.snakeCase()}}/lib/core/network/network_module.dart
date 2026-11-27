import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../config/constants/api/api_constants.dart';
import '../../config/env/app_env.dart';
import 'dev_http_adapter.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/refresh_token_interceptor.dart';
import 'network_constants.dart';

/// Provides the configured [Dio] instances.
///
/// * The default (unnamed) [Dio] is used by `DioApiClient` for API calls and
///   carries the auth + refresh interceptors.
/// * [NetworkNames.refreshDio] is a bare Dio used only to refresh tokens and
///   retry after a refresh. Third-party hosts should get their **own** Dio
///   (never the API one) so credentials are not attached to them.
@module
abstract class NetworkModule {
  @Named(NetworkNames.apiBaseUrl)
  String get apiBaseUrl => AppEnv.baseUrl;

  @Named(NetworkNames.refreshDio)
  @lazySingleton
  Dio refreshDio(@Named(NetworkNames.apiBaseUrl) String baseUrl) =>
      buildBaseDio(
        baseUrl: baseUrl,
        interceptors: [if (kDebugMode) LoggingInterceptor()],
      );

  @lazySingleton
  Dio dio(
    @Named(NetworkNames.apiBaseUrl) String baseUrl,
    AuthInterceptor authInterceptor,
    RefreshTokenInterceptor refreshTokenInterceptor,
  ) => buildBaseDio(
    baseUrl: baseUrl,
    // Order matters: auth first, refresh next, logging (debug) last so it
    // reports what actually went over the wire.
    interceptors: [
      authInterceptor,
      refreshTokenInterceptor,
      if (kDebugMode) LoggingInterceptor(),
    ],
  );
}

/// A Dio with base URL, timeouts, default headers, the given [interceptors]
/// (in order) and the debug-only dev adapter. Carries no auth by itself.
Dio buildBaseDio({
  required String baseUrl,
  List<Interceptor> interceptors = const [],
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      sendTimeout: ApiConstants.sendTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      headers: Map.of(ApiConstants.defaultHeaders),
    ),
  );
  final devAdapter = createDevHttpClientAdapter(baseUrl: baseUrl);
  if (devAdapter != null) {
    dio.httpClientAdapter = devAdapter;
  }
  dio.interceptors.addAll(interceptors);
  return dio;
}
