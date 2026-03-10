import 'package:fpdart/fpdart.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../domain/entities/failure.dart';

abstract class IPermissionRepository {
  Future<Either<Failure, PermissionStatus>> checkNotificationPermission();
  Future<Either<Failure, PermissionStatus>> checkLocationPermission();
  Future<Either<Failure, PermissionStatus>> checkCameraPermission();
  Future<Either<Failure, PermissionStatus>> checkMicrophonePermission();
  Future<Either<Failure, PermissionStatus>> checkStoragePermission();

  Future<Either<Failure, PermissionStatus>> requestNotificationPermission();
  Future<Either<Failure, PermissionStatus>> requestLocationPermission();
  Future<Either<Failure, PermissionStatus>> requestCameraPermission();
  Future<Either<Failure, PermissionStatus>> requestMicrophonePermission();
  Future<Either<Failure, PermissionStatus>> requestStoragePermission();

  Future<Either<Failure, bool>> skipNotificationPermission();
  Future<Either<Failure, bool>> skipLocationPermission();
  Future<Either<Failure, bool>> skipCameraPermission();
  Future<Either<Failure, bool>> skipMicrophonePermission();
  Future<Either<Failure, bool>> skipStoragePermission();

  // ── Contacts ──
  Future<Either<Failure, PermissionStatus>> checkContactsPermission();
  Future<Either<Failure, PermissionStatus>> requestContactsPermission();
  Future<Either<Failure, bool>> skipContactsPermission();

  // ── Calendar ──
  Future<Either<Failure, PermissionStatus>> checkCalendarPermission();
  Future<Either<Failure, PermissionStatus>> requestCalendarPermission();
  Future<Either<Failure, bool>> skipCalendarPermission();

  // ── Bluetooth ──
  Future<Either<Failure, PermissionStatus>> checkBluetoothPermission();
  Future<Either<Failure, PermissionStatus>> requestBluetoothPermission();
  Future<Either<Failure, bool>> skipBluetoothPermission();

  // ── Phone ──
  Future<Either<Failure, PermissionStatus>> checkPhonePermission();
  Future<Either<Failure, PermissionStatus>> requestPhonePermission();
  Future<Either<Failure, bool>> skipPhonePermission();

  // ── Activity Recognition ──
  Future<Either<Failure, PermissionStatus>> checkActivityRecognitionPermission();
  Future<Either<Failure, PermissionStatus>> requestActivityRecognitionPermission();
  Future<Either<Failure, bool>> skipActivityRecognitionPermission();

  Future<Either<Failure, bool>> setFcm({required String fcmToken});
}
