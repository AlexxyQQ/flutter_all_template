// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'test_state.freezed.dart';

@freezed
abstract class TestState with _$TestState {
  const factory TestState({
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    @Default(false) bool isValid,
    @Default(false) bool hasLocationPermission,
  }) = _TestState;

  factory TestState.initial() => const TestState();
}
