import 'package:freezed_annotation/freezed_annotation.dart';

part 'permission_cache_entity.freezed.dart';

@freezed
abstract class PermissionCacheEntity with _$PermissionCacheEntity {
  const factory PermissionCacheEntity({
    @Default(false) bool skippedLocationPermission,
    @Default(false) bool skippedNotificationPermission,
    @Default(false) bool skippedStoragePermission,
    @Default(false) bool skippedMicrophonePermission,
    @Default(false) bool skippedCameraPermission,
    @Default(false) bool skippedContactsPermission,
    @Default(false) bool skippedCalendarPermission,
    @Default(false) bool skippedBluetoothPermission,
    @Default(false) bool skippedPhonePermission,
    @Default(false) bool skippedActivityRecognitionPermission,
  }) = _PermissionCacheEntity;
}
