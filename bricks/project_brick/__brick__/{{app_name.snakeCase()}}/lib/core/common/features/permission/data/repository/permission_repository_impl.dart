import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../../config/constants/type_defs/typedef.dart';
import '../../../../../error/guard.dart';
{{#use_notifications}}
import '../../../../domain/services/notification/notification_permission_api.dart';
{{/use_notifications}}
import '../../domain/entities/app_permission.dart';
import '../../domain/entities/app_permission_status.dart';
import '../../domain/repository/permission_repository.dart';
import '../../permission_spec.dart';
import '../data_sources/permission_platform_data_source.dart';

@LazySingleton(as: IPermissionRepository)
class PermissionRepositoryImpl implements IPermissionRepository {
  const PermissionRepositoryImpl(
    this._platform,
{{#use_notifications}}
    this._notifications,
{{/use_notifications}}
  );

  final PermissionPlatformDataSource _platform;

{{#use_notifications}}
  /// Notification permission is owned by the notification module (it also
  /// has to talk to FCM / the local-notification plugin).
  final NotificationPermissionApi _notifications;
{{/use_notifications}}

  @override
  ResultFuture<AppPermissionStatus> check(AppPermission permission) =>
      guard(() async {
        switch (permission) {
{{#use_notifications}}
          case AppPermission.notification:
            if (await _notifications.isPermissionGranted()) {
              return AppPermissionStatus.granted;
            }
            return _platformStatus(permission);
{{/use_notifications}}
          case AppPermission.location:
            if (!await _platform.isLocationServiceEnabled()) {
              // GPS is off: treat as not granted so the UI prompts.
              return AppPermissionStatus.denied;
            }
            return _platformStatus(permission);
          case _:
            return _platformStatus(permission);
        }
      });

  @override
  ResultFuture<AppPermissionStatus> request(AppPermission permission) =>
      guard(() async {
        switch (permission) {
{{#use_notifications}}
          case AppPermission.notification:
            if (await _notifications.requestPermission()) {
              return AppPermissionStatus.granted;
            }
            // Distinguish "denied" from "denied forever".
            return _platformStatus(permission);
{{/use_notifications}}
          case AppPermission.location:
            if (!await _platform.isLocationServiceEnabled()) {
              await _platform.openLocationSettings();
              return AppPermissionStatus.denied;
            }
            return mapPermissionStatus(
              await _platform.request(permission.spec.platformPermission),
            );
          case _:
            return mapPermissionStatus(
              await _platform.request(permission.spec.platformPermission),
            );
        }
      });

  @override
  ResultFuture<bool> openSettings() => guard(_platform.openAppSettings);

  Future<AppPermissionStatus> _platformStatus(AppPermission permission) async =>
      mapPermissionStatus(
        await _platform.status(permission.spec.platformPermission),
      );
}

/// Maps `permission_handler`'s status to the domain enum.
AppPermissionStatus mapPermissionStatus(PermissionStatus status) =>
    switch (status) {
      PermissionStatus.granted => AppPermissionStatus.granted,
      PermissionStatus.limited => AppPermissionStatus.limited,
      PermissionStatus.provisional => AppPermissionStatus.provisional,
      PermissionStatus.restricted => AppPermissionStatus.restricted,
      PermissionStatus.permanentlyDenied =>
        AppPermissionStatus.permanentlyDenied,
      PermissionStatus.denied => AppPermissionStatus.denied,
    };
