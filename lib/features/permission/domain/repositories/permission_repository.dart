import '../../../../core/error/typedef.dart';
import '../entities/app_permission.dart';
import '../entities/app_permission_status.dart';

/// Pure OS-permission access: check, request, open settings.
abstract interface class IPermissionRepository {
  ResultFuture<AppPermissionStatus> check({required AppPermission permission});

  ResultFuture<AppPermissionStatus> request({
    required AppPermission permission,
  });

  /// Opens the app's page in the system settings. Right(true) if it opened.
  ResultFuture<bool> openSettings();

  /// Whether the device's location switch (GPS) is on. Independent from the
  /// location *permission*: a granted permission is useless while it is off.
  ResultFuture<bool> isLocationServiceEnabled();

  /// Opens the system location settings. Never called implicitly.
  ResultFuture<bool> openLocationSettings();
}
