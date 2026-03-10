import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/constants/api/api_constants.dart';
import '../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../locator/service_locator.dart';
import '../../entities/failure.dart';
import '../logger/logger_service.dart';
import 'interceptor/authentication_interceptor.dart';
import 'interceptor/connectivity_interceptor.dart';
import 'interceptor/error_interceptor.dart';

@lazySingleton
class DioService {
  DioService() {
    _dio
      ..options.baseUrl = ApiConstants.baseAPIURL
      ..options.receiveTimeout = ApiConstants.receiveTimeout
      ..options.connectTimeout = ApiConstants.connectTimeout
      ..options.headers = ApiConstants.defaultHeader
      // Adding a custom error interceptor for enhanced error handling.
      ..interceptors.add(sl<ErrorInterceptor>())
      ..interceptors.add(sl<ConnectivityInterceptor>())
      ..interceptors.add(sl<AuthenticationInterceptor>())
      // ..interceptors.add(sl<TokenInterceptor>())
      ..httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final HttpClient client = HttpClient();
          const String? proxy = bool.hasEnvironment('PROXY')
              ? String.fromEnvironment('PROXY')
              : null;
          const bool allowBadCertificate = bool.hasEnvironment('ALLOW_HTTP')
              ? bool.fromEnvironment('ALLOW_HTTP')
              : false;
          client.badCertificateCallback = (_, _, _) => allowBadCertificate;
          if (proxy != null) {
            client.findProxy = (Uri url) {
              return 'PROXY $proxy';
            };
          }
          return client;
        },
      );

    // if (kDebugMode) {
    //   _dio.interceptors.add(MockerInterceptor());
    // }
  }
  final Dio _dio = Dio();

  // change the base URL
  void setBaseURL(String newBaseUrl) {
    _dio.options.baseUrl = newBaseUrl;
  }

  Dio get dio => _dio;
}

/// A static utility class for handling API requests using Dio.
///
/// This class provides a simplified and consistent interface for making GET, POST,
/// PUT, and DELETE requests. It abstracts the underlying Dio calls and integrates
/// a robust error handling mechanism, returning results wrapped in an `Either` type
/// from the `fpdart` package.
///
/// ## Features
/// - **Type-Safe Responses**: Uses generics (`<T>`) to return strongly typed success objects.
/// - **Unified Error Handling**: Catches `DioException` and other exceptions, converting them
///   into a standardized `Failure`.
/// - **Clear Success/Failure Path**: Returns `Either<Failure, T>`, forcing the
///   caller to handle both success (Right) and failure (Left) states explicitly.
/// - **Simplified API Calls**: Provides static methods (`get`, `post`, `put`, `delete`) that
///   reduce boilerplate code in repositories or data sources.
///
/// ## Example Usage
///
/// First, define a model for the data you expect from the API.
///
/// ```dart
/// // 1. Define your data model
/// class User {
///   final int id;
///   final String name;
///   final String email;
///
///   User({required this.id, required this.name, required this.email});
///
///   factory User.fromJson(Map<String, dynamic> json) {
///     return User(
///       id: json['id'] as int,
///       name: json['name'] as String,
///       email: json['email'] as String,
///     );
///   }
/// }
/// ```
///
/// Next, use the `ApiHandler` in your repository or service to fetch or post data.
///
/// ```dart
/// class UserRepository {
///   // Example of a GET request to fetch a user
///   Future<Either<Failure, User>> getUser(int userId) async {
///     final result = await ApiHandler.get<User>(
///       url: '/users/$userId',
///       // onSuccess is now an async function
///       onSuccess: (json) async { // <-- Can now be async
///         // You can now use await inside this callback
///         // await someAsyncParsingOrDatabaseLogic();
///         return User.fromJson(json);
///       },
///     );
///     return result;
///   }
///
///   // Example of a POST request to create a user
///   Future<Either<Failure, User>> createUser(String name, String email) async {
///     final result = await ApiHandler.post<User>(
///       url: '/users',
///       data: {'name': name, 'email': email},
///       onSuccess: (json) async { // <-- Can now be async
///         // onSuccess for POST usually handles the response body of the created resource.
///         return User.fromJson(json);
///       },
///       // Optional: Customize success code for POST (e.g., 201 Created)
///       successCode: 201,
///     );
///     return result;
///   }
/// }
/// ```
///
/// Finally, in your application logic (e.g., a BLoC, Cubit, or ViewModel),
/// you can call the repository method and handle the `Either` result.
///
/// ```dart
/// void main() async {
///   // Make sure to initialize DioService in your injector (getIt) first!
///   // getIt.registerLazySingleton(() => DioService());
///
///   final userRepository = UserRepository();
///
///   // Fetch a user and handle the result
///   final userResult = await userRepository.getUser(1);
///
///   userResult.fold(
///     (appError) {
///       // This is the failure (Left) case.
///       print('Failed to fetch user: ${appError.message}');
///     },
///     (user) {
///       // This is the success (Right) case.
///       print('Successfully fetched user: ${user.name}');
///     },
///   );
/// }
/// ```
class ApiHandler {
  static const String _logName = 'ApiHandler';

  /// Internal method to execute the API call and handle errors/success states.
  static Future<Either<Failure, T>> _call<T>(
    Future<Response<dynamic>> Function() apiCall, {
    required FutureOr<T> Function(Map<String, dynamic>) onSuccess,
    FutureOr<Failure> Function(Map<String, dynamic>)? onError,
    Failure defaultErrorMessage = const Failure(
      message: LocaleKeys.common_errors_somethingWentWrong,
    ),
    int? successCode = 200,
    String? successMessage = 'OK',
  }) async {
    try {
      // LOG: Request Started
      AppLogger.debug('➡️ Starting API Request...', name: _logName);

      final response = await apiCall();

      // LOG: Check status
      AppLogger.debug(
        '⬅️ Response received. Status: ${response.statusCode}, Path: ${response.requestOptions.path}',
        name: _logName,
      );

      if (response.statusCode == successCode ||
          response.statusMessage == 'OK') {
        if (response.data == null) {
          // LOG: Null data error
          AppLogger.error('❌ Response data was null', name: _logName);

          return const Left(
            Failure(message: LocaleKeys.common_errors_somethingWentWrong),
          );
        }

        Map<String, dynamic> processedData;
        if (response.data is Map<String, dynamic>) {
          processedData = response.data as Map<String, dynamic>;
        } else {
          processedData = {'data': response.data};
        }

        // LOG: Success
        AppLogger.info('✅ Request Successful', name: _logName);
        return Right(await onSuccess.call(processedData));
      } else {
        // LOG: Logic Error (non-200 status)
        AppLogger.error(
          '⚠️ API Logic Error: ${response.statusCode}',
          name: _logName,
        );

        final errorModel = onError != null
            ? await onError.call(response.data ?? {})
            : defaultErrorMessage;
        return Left(errorModel);
      }
    } on DioException catch (e) {
      // LOG: Dio Error (Network, Timeout, etc.)
      AppLogger.error(
        '❌ Dio Exception: ${e.message} | Path: ${e.requestOptions.path}',
        error: e,
        stackTrace: e.stackTrace,
        name: _logName,
      );

      await onError?.call(e.response?.data ?? {});
      return Left(Failure.fromDioException(e));
    } catch (e, s) {
      // LOG: Unexpected Error
      AppLogger.error(
        '❌ Unexpected Exception',
        error: e,
        stackTrace: s,
        name: _logName,
      );

      await onError?.call({'message': e.toString()});
      return Left(Failure(message: e.toString()));
    }
  }

  /// GET Request
  static Future<Either<Failure, T>> get<T>({
    required String url,
    required FutureOr<T> Function(Map<String, dynamic>) onSuccess,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    Dio? client, // <--- Added client parameter
    FutureOr<Failure> Function(Map<String, dynamic>)? onError,
    Failure defaultErrorMessage = const Failure(
      message: LocaleKeys.common_errors_somethingWentWrong,
    ),
    int? successCode = 200,
    String? successMessage = 'OK',
  }) async {
    return _call<T>(
      // Use the provided client, otherwise fallback to the default injected service
      () => (client ?? sl<DioService>().dio).get(
        url,
        queryParameters: queryParams,
        options: Options(headers: headers),
      ),
      onSuccess: onSuccess,
      defaultErrorMessage: defaultErrorMessage,
      onError: onError,
      successCode: successCode,
      successMessage: successMessage,
    );
  }

  /// POST Request
  static Future<Either<Failure, T>> post<T>({
    required String url,
    required FutureOr<T> Function(Map<String, dynamic>) onSuccess,
    Map<String, dynamic>? queryParams,
    Object? data,
    Map<String, dynamic>? headers,
    Dio? client, // <--- Added client parameter
    FutureOr<Failure> Function(Map<String, dynamic>)? onError,
    Failure defaultErrorMessage = const Failure(
      message: LocaleKeys.common_errors_somethingWentWrong,
    ),
    int? successCode = 201,
    String? successMessage = 'OK',
  }) async {
    return _call<T>(
      () => (client ?? sl<DioService>().dio).post(
        url,
        queryParameters: queryParams,
        data: data,
        options: Options(headers: headers),
      ),
      onSuccess: onSuccess,
      defaultErrorMessage: defaultErrorMessage,
      onError: onError,
      successCode: successCode,
      successMessage: successMessage,
    );
  }

  /// PUT Request
  static Future<Either<Failure, T>> put<T>({
    required String url,
    required FutureOr<T> Function(Map<String, dynamic>) onSuccess,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    Dio? client, // <--- Added client parameter
    FutureOr<Failure> Function(Map<String, dynamic>)? onError,
    Failure defaultErrorMessage = const Failure(
      message: LocaleKeys.common_errors_somethingWentWrong,
    ),
    int? successCode = 200,
    String? successMessage = 'OK',
  }) async {
    return _call<T>(
      () => (client ?? sl<DioService>().dio).put(
        url,
        queryParameters: queryParams,
        data: data,
        options: Options(headers: headers),
      ),
      onSuccess: onSuccess,
      defaultErrorMessage: defaultErrorMessage,
      onError: onError,
      successCode: successCode,
      successMessage: successMessage,
    );
  }

  /// DELETE Request
  static Future<Either<Failure, T>> delete<T>({
    required String url,
    required FutureOr<T> Function(Map<String, dynamic>) onSuccess,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    Dio? client, // <--- Added client parameter
    FutureOr<Failure> Function(Map<String, dynamic>)? onError,
    Failure defaultErrorMessage = const Failure(
      message: LocaleKeys.common_errors_somethingWentWrong,
    ),
    int? successCode = 200,
    String? successMessage = 'OK',
  }) async {
    return _call<T>(
      () => (client ?? sl<DioService>().dio).delete(
        url,
        queryParameters: queryParams,
        data: data,
        options: Options(headers: headers),
      ),
      onSuccess: onSuccess,
      defaultErrorMessage: defaultErrorMessage,
      onError: onError,
      successCode: successCode,
      successMessage: successMessage,
    );
  }
}
