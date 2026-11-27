import 'package:injectable/injectable.dart';

import '../../../../core/error/guard.dart';
import '../../../../core/error/typedef.dart';
// brick:if use_notifications
import '../../../../core/services/notification/domain/notification_permission_api.dart';
// brick:end
import '../../domain/entities/app_permission.dart';
import '../../domain/entities/app_permission_status.dart';
import '../../domain/repositories/permission_repository.dart';
import '../data_sources/permission_platform_data_source.dart';

@LazySingleton(as: IPermissionRepository)
class PermissionRepositoryImpl implements IPermissionRepository {
  // The always-present collaborator comes last in both lists, so removing the
  // optional notifications region leaves valid code behind.
  PermissionRepositoryImpl({
    // brick:if use_notifications
    required INotificationPermissionApi notifications,
    // brick:end
    required IPermissionPlatformDataSource platform,
  }) : // brick:if use_notifications
       _notifications = notifications,
       // brick:end
       _platform = platform;

  final IPermissionPlatformDataSource _platform;

  // brick:if use_notifications
  /// Notification permission is owned by the notification module (it also
  /// has to talk to FCM / the local-notification plugin).
  final INotificationPermissionApi _notifications;
  // brick:end

  @override
  ResultFuture<AppPermissionStatus> check({
    required AppPermission permission,
  }) => guard(() async {
    // brick:if use_notifications
    if (permission == AppPermission.notification &&
        await _notifications.isPermissionGranted()) {
      return AppPermissionStatus.granted;
    }
    // brick:end
    return _platform.status(permission: permission);
  });

  @override
  ResultFuture<AppPermissionStatus> request({
    required AppPermission permission,
  }) => guard(() async {
    // brick:if use_notifications
    if (permission == AppPermission.notification) {
      if (await _notifications.requestPermission()) {
        return AppPermissionStatus.granted;
      }
      // The module only answers "allowed or not": ask the OS to tell
      // "denied" from "denied forever".
      return _platform.status(permission: permission);
    }
    // brick:end
    return _platform.request(permission: permission);
  });

  @override
  ResultFuture<bool> openSettings() => guard(_platform.openAppSettings);

  @override
  ResultFuture<bool> isLocationServiceEnabled() =>
      guard(_platform.isLocationServiceEnabled);

  @override
  ResultFuture<bool> openLocationSettings() =>
      guard(_platform.openLocationSettings);
}
