part of 'permission_bloc.dart';

@freezed
abstract class PermissionState with _$PermissionState {
  const PermissionState._();
  const factory PermissionState({
    @Default(false) bool isLoading,
    Failure? error,
    @Default(PermissionStatus.denied)
    PermissionStatus notificationPermissionStatus,
    @Default(PermissionStatus.denied) PermissionStatus locationPermissionStatus,
    @Default(PermissionStatus.denied) PermissionStatus cameraPermissionStatus,
    @Default(PermissionStatus.denied)
    PermissionStatus microphonePermissionStatus,
    @Default(PermissionStatus.denied) PermissionStatus storagePermissionStatus,
    @Default(PermissionStatus.denied) PermissionStatus contactsPermissionStatus,
    @Default(PermissionStatus.denied) PermissionStatus calendarPermissionStatus,
    @Default(PermissionStatus.denied) PermissionStatus bluetoothPermissionStatus,
    @Default(PermissionStatus.denied) PermissionStatus phonePermissionStatus,
    @Default(PermissionStatus.denied)
    PermissionStatus activityRecognitionPermissionStatus,
    @Default(false) bool skippedNotificationPermissionGranted,
    @Default(false) bool skippedLocationPermissionGranted,
    @Default(false) bool skippedCameraPermissionGranted,
    @Default(false) bool skippedMicrophonePermissionGranted,
    @Default(false) bool skippedStoragePermissionGranted,
    @Default(false) bool skippedContactsPermissionGranted,
    @Default(false) bool skippedCalendarPermissionGranted,
    @Default(false) bool skippedBluetoothPermissionGranted,
    @Default(false) bool skippedPhonePermissionGranted,
    @Default(false) bool skippedActivityRecognitionPermissionGranted,
    @Default(false) bool fcmTokenSet,
    PageRouteInfo<Object?>? navigateRoute,
  }) = _PermissionState;

  factory PermissionState.initial() => const PermissionState();
}
