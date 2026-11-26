import '../../../../../../config/constants/type_defs/typedef.dart';
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
}

/// Persists which permissions the user chose to skip ("maybe later").
///
/// Skipping is **not** granting: callers must still check the real status
/// before using the guarded feature.
abstract interface class IPermissionSkipRepository {
  /// Synchronous read (backed by pre-loaded preferences).
  bool isSkipped({required AppPermission permission});

  ResultFuture<void> markSkipped({required AppPermission permission});

  ResultFuture<void> clearSkipped({required AppPermission permission});
}
