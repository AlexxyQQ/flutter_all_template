import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart'
    hide openAppSettings;
import 'package:permission_handler/permission_handler.dart'
    as ph
    show openAppSettings;

/// Thin wrapper around the `permission_handler` / `geolocator` statics so the
/// repository can be unit-tested.
abstract interface class PermissionPlatformDataSource {
  Future<PermissionStatus> status(Permission permission);

  Future<PermissionStatus> request(Permission permission);

  Future<bool> isLocationServiceEnabled();

  Future<bool> openLocationSettings();

  Future<bool> openAppSettings();
}

@LazySingleton(as: PermissionPlatformDataSource)
class PermissionHandlerDataSource implements PermissionPlatformDataSource {
  const PermissionHandlerDataSource();

  @override
  Future<PermissionStatus> status(Permission permission) => permission.status;

  @override
  Future<PermissionStatus> request(Permission permission) =>
      permission.request();

  @override
  Future<bool> isLocationServiceEnabled() =>
      Geolocator.isLocationServiceEnabled();

  @override
  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();

  @override
  Future<bool> openAppSettings() => ph.openAppSettings();
}
