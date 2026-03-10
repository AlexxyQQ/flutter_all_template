import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../domain/entities/failure.dart';
import '../../../../domain/services/notification/notification_service.dart';
import '../../../../locator/service_locator.dart';
import '../../../../presentation/routes/app_router.gr.dart';
import '../../domain/entities/permission_cache_entity.dart';
import '../../domain/repository/permission_repository.dart';
import '../../domain/services/permission_cache_service.dart';

@LazySingleton(as: IPermissionRepository)
class PermissionRepositoryImpl extends IPermissionRepository {
  @override
  Future<Either<Failure, PermissionStatus>> checkCameraPermission() async {
    try {
      final permissionStatus = await Permission.camera.status;
      return Right(permissionStatus);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, PermissionStatus>> requestLocationPermission() async {
    try {
      // 1. Check if Location Services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Open the native Location Settings screen so user can enable GPS
        await Geolocator.openLocationSettings();
        return const Right(PermissionStatus.denied);
      }

      // 2. Request Permission
      final permission = await Geolocator.requestPermission();

      return Right(_mapGeolocatorStatus(permission));
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  // Helper to convert Geolocator status to PermissionHandler status
  PermissionStatus _mapGeolocatorStatus(LocationPermission permission) {
    switch (permission) {
      case LocationPermission.denied:
        return PermissionStatus.denied;
      case LocationPermission.deniedForever:
        return PermissionStatus.permanentlyDenied;
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        return PermissionStatus.granted;
      case LocationPermission.unableToDetermine:
        return PermissionStatus.denied;
    }
  }

  @override
  Future<Either<Failure, PermissionStatus>> checkMicrophonePermission() async {
    try {
      final permissionStatus = await Permission.microphone.status;
      return Right(permissionStatus);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, PermissionStatus>>
  checkNotificationPermission() async {
    try {
      final permissionStatus = await Permission.notification.status;
      return Right(permissionStatus);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, PermissionStatus>> checkStoragePermission() async {
    try {
      final permissionStatus = await Permission.storage.status;
      return Right(permissionStatus);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, PermissionStatus>> requestCameraPermission() async {
    try {
      final permissionStatus = await Permission.camera.request();
      return Right(permissionStatus);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, PermissionStatus>> checkLocationPermission() async {
    try {
      // 1. Check if Location Services are enabled (GPS toggle)
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // You might want to return a specific failure or status here
        // For now, we treat it as denied so the UI prompts the user
        return const Right(PermissionStatus.denied);
      }

      // 2. Check the actual permission status using Geolocator
      // Geolocator's LocationPermission is similar but distinct from permission_handler's PermissionStatus
      final permission = await Geolocator.checkPermission();

      return Right(_mapGeolocatorStatus(permission));
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, PermissionStatus>>
  requestMicrophonePermission() async {
    try {
      final permissionStatus = await Permission.microphone.request();
      return Right(permissionStatus);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, PermissionStatus>>
  requestNotificationPermission() async {
    try {
      // Check current permission status first
      final permissionStatus = await Permission.notification.status;

      if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
        // Request again using the notification service
        final result = await NotificationService.instance.requestPermission();
        if (result) {
          final fcm = NotificationService.instance.fcmToken;
          if (fcm != null) {
            await setFcm(fcmToken: fcm);
          }
          return const Right(PermissionStatus.granted);
        } else {
          return const Right(PermissionStatus.permanentlyDenied);
        }
      } else {
        // Normal flow
        final result = await NotificationService.instance.requestPermission();
        if (result) {
          final fcm = NotificationService.instance.fcmToken;
          if (fcm != null) {
            await setFcm(fcmToken: fcm);
          }
        }
        return Right(
          result
              ? PermissionStatus.granted
              : PermissionStatus.permanentlyDenied,
        );
      }
    } catch (e) {
      return Left(
        Failure.fromException(
          e,
        ).copyWith(navigateRoute: NotificationPermissionScreenRoute()),
      );
    }
  }

  @override
  Future<Either<Failure, PermissionStatus>> requestStoragePermission() async {
    try {
      final permissionStatus = await Permission.storage.request();
      return Right(permissionStatus);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> skipCameraPermission() async {
    try {
      // final permissionStatus = await Permission.camera.status;
      // return Right(permissionStatus.isGranted);
      sl<PermissionCacheService>().getSet(
        data: (data) => (data ?? const PermissionCacheEntity()).copyWith(
          skippedCameraPermission: true,
        ),
      );
      return const Right(true);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> skipLocationPermission() async {
    try {
      sl<PermissionCacheService>().getSet(
        data: (data) => (data ?? const PermissionCacheEntity()).copyWith(
          skippedLocationPermission: true,
        ),
      );
      return const Right(true);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> skipMicrophonePermission() async {
    try {
      sl<PermissionCacheService>().getSet(
        data: (data) => (data ?? const PermissionCacheEntity()).copyWith(
          skippedMicrophonePermission: true,
        ),
      );
      return const Right(true);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> skipNotificationPermission() async {
    try {
      sl<PermissionCacheService>().getSet(
        data: (data) => (data ?? const PermissionCacheEntity()).copyWith(
          skippedNotificationPermission: true,
        ),
      );
      return const Right(true);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> skipStoragePermission() async {
    try {
      sl<PermissionCacheService>().getSet(
        data: (data) => (data ?? const PermissionCacheEntity()).copyWith(
          skippedStoragePermission: true,
        ),
      );
      return const Right(true);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  // ── Contacts ──

  @override
  Future<Either<Failure, PermissionStatus>> checkContactsPermission() async {
    try {
      final permissionStatus = await Permission.contacts.status;
      return Right(permissionStatus);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, PermissionStatus>> requestContactsPermission() async {
    try {
      final permissionStatus = await Permission.contacts.request();
      return Right(permissionStatus);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> skipContactsPermission() async {
    try {
      sl<PermissionCacheService>().getSet(
        data: (data) => (data ?? const PermissionCacheEntity()).copyWith(
          skippedContactsPermission: true,
        ),
      );
      return const Right(true);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  // ── Calendar ──

  @override
  Future<Either<Failure, PermissionStatus>> checkCalendarPermission() async {
    try {
      final permissionStatus = await Permission.calendarFullAccess.status;
      return Right(permissionStatus);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, PermissionStatus>> requestCalendarPermission() async {
    try {
      final permissionStatus = await Permission.calendarFullAccess.request();
      return Right(permissionStatus);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> skipCalendarPermission() async {
    try {
      sl<PermissionCacheService>().getSet(
        data: (data) => (data ?? const PermissionCacheEntity()).copyWith(
          skippedCalendarPermission: true,
        ),
      );
      return const Right(true);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  // ── Bluetooth ──

  @override
  Future<Either<Failure, PermissionStatus>> checkBluetoothPermission() async {
    try {
      final permissionStatus = await Permission.bluetooth.status;
      return Right(permissionStatus);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, PermissionStatus>> requestBluetoothPermission() async {
    try {
      final permissionStatus = await Permission.bluetooth.request();
      return Right(permissionStatus);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> skipBluetoothPermission() async {
    try {
      sl<PermissionCacheService>().getSet(
        data: (data) => (data ?? const PermissionCacheEntity()).copyWith(
          skippedBluetoothPermission: true,
        ),
      );
      return const Right(true);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  // ── Phone ──

  @override
  Future<Either<Failure, PermissionStatus>> checkPhonePermission() async {
    try {
      final permissionStatus = await Permission.phone.status;
      return Right(permissionStatus);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, PermissionStatus>> requestPhonePermission() async {
    try {
      final permissionStatus = await Permission.phone.request();
      return Right(permissionStatus);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> skipPhonePermission() async {
    try {
      sl<PermissionCacheService>().getSet(
        data: (data) => (data ?? const PermissionCacheEntity()).copyWith(
          skippedPhonePermission: true,
        ),
      );
      return const Right(true);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  // ── Activity Recognition ──

  @override
  Future<Either<Failure, PermissionStatus>>
  checkActivityRecognitionPermission() async {
    try {
      final permissionStatus = await Permission.activityRecognition.status;
      return Right(permissionStatus);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, PermissionStatus>>
  requestActivityRecognitionPermission() async {
    try {
      final permissionStatus = await Permission.activityRecognition.request();
      return Right(permissionStatus);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> skipActivityRecognitionPermission() async {
    try {
      sl<PermissionCacheService>().getSet(
        data: (data) => (data ?? const PermissionCacheEntity()).copyWith(
          skippedActivityRecognitionPermission: true,
        ),
      );
      return const Right(true);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> setFcm({required String fcmToken}) async {
    try {
      throw UnimplementedError();
      // final supabase = Supabase.instance.client;
      // final user = supabase.auth.currentUser;
      // if (user != null) {
      //   final userID = user.id;
      //   await supabase
      //       .from('profile')
      //       .update({'fcm_token': fcmToken})
      //       .eq('id', userID);

      //   return const Right(true);
      // }
      // return const Right(false);
    } catch (e) {
      print('assshole: $e');
      return Left(Failure.fromException(e));
    }
  }
}
