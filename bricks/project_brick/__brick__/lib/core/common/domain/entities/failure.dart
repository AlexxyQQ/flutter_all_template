import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';
part 'failure.g.dart';

@freezed
abstract class Failure with _$Failure {
  const factory Failure({
    required String message,
    String? code,
    String? data,
    String? path,
    @JsonKey(includeToJson: false, includeFromJson: false)
    PageRouteInfo<Object?>? navigateRoute,
  }) = _Failure;

  factory Failure.fromDioException(DioException e) {
    String errorMessage = 'Something went wrong';
    try {
      if (e.response?.data is String) {
        errorMessage = e.response?.data ?? errorMessage;
      } else if (e.response?.data is Map<String, dynamic>) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      }
    } catch (error) {
      return Failure(
        message: errorMessage,
        code: e.response?.statusCode.toString(),
        data: e.message,
      );
    }
    return Failure(
      message: errorMessage,
      code: e.response?.statusCode.toString(),
      data: e.message,
    );
  }

  factory Failure.fromException(dynamic e) {
    return Failure(message: e.toString());
  }

  factory Failure.fromJson(Map<String, dynamic> json) =>
      _$FailureFromJson(json);
}
