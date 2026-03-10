// import 'package:dio/dio.dart';
// import 'package:injectable/injectable.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';

// @lazySingleton
// class TokenInterceptor extends QueuedInterceptor {
//   final Dio dio;
//   final SecureStorageService storage;

//   TokenInterceptor(this.dio, this.storage);

//   @override
//   Future<void> onRequest(
//     RequestOptions options,
//     RequestInterceptorHandler handler,
//   ) async {
//     // 1. Get the current token
//     String? accessToken = await storage.getAccessToken();

//     // 2. If no token, just pass (let AuthInterceptor handle missing auth later)
//     if (accessToken == null) {
//       return handler.next(options);
//     }

//     // 3. Check Expiry
//     if (JwtDecoder.isExpired(accessToken)) {
//       try {
//         // Token is expired. Refresh it.
//         final refreshToken = await storage.getRefreshToken();

//         // Use a separate Dio instance to avoid loop
//         final refreshDio = Dio();
//         final response = await refreshDio.post(
//           'https://api.yoursite.com/auth/refresh',
//           data: {'refreshToken': refreshToken},
//         );

//         // Save new token
//         final newAccessToken = response.data['accessToken'];
//         await storage.saveAccessToken(newAccessToken);

//         // Proceed with request
//         return handler.next(options);
//       } catch (e) {
//         // Refresh failed (Session expired)
//         return handler.reject(
//           DioException(requestOptions: options, error: "Session expired"),
//         );
//       }
//     }

//     // Token is valid, proceed
//     return handler.next(options);
//   }
// }
