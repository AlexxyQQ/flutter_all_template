import '../../../../../../config/constants/type_defs/typedef.dart';
import '../entities/app_permission.dart';
import '../entities/app_permission_status.dart';

/// Pure OS-permission access: check, request, open settings.
abstract interface class IPermissionRepository {
  ResultFuture<AppPermissionStatus> check(AppPermission permission);

  ResultFuture<AppPermissionStatus> request(AppPermission permission);

  /// Opens the app's page in the system settings. Right(true) if it opened.
  ResultFuture<bool> openSettings();
}

/// Persists which permissions the user chose to skip ("maybe later").
///
/// Skipping is **not** granting: callers must still check the real status
/// before using the guarded feature.
abstract interface class IPermissionSkipRepository {
  /// Synchronous read (backed by pre-loaded preferences).
  bool isSkipped(AppPermission permission);

  ResultFuture<void> markSkipped(AppPermission permission);

  ResultFuture<void> clearSkipped(AppPermission permission);
}
