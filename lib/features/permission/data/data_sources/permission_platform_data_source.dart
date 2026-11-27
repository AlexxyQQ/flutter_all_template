import '../../domain/entities/app_permission.dart';
import '../../domain/entities/app_permission_status.dart';

/// Seam over the `permission_handler` / `geolocator` statics so the
/// repository can be unit-tested. Speaks the domain's [AppPermission] and
/// hides which platform permissions back it on the current OS.
abstract interface class IPermissionPlatformDataSource {
  Future<AppPermissionStatus> status({required AppPermission permission});

  /// Shows the OS prompt (if the OS still allows one) and returns the result.
  Future<AppPermissionStatus> request({required AppPermission permission});

  Future<bool> isLocationServiceEnabled();

  Future<bool> openLocationSettings();

  Future<bool> openAppSettings();
}
