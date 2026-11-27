import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart'
    hide openAppSettings;
import 'package:permission_handler/permission_handler.dart'
    as ph
    show openAppSettings;

import '../../domain/entities/app_permission.dart';
import '../../domain/entities/app_permission_status.dart';
import '../helpers/permission_status_resolver.dart';
import '../helpers/platform_permissions.dart';
import 'permission_platform_data_source.dart';

@LazySingleton(as: IPermissionPlatformDataSource)
class PermissionHandlerDataSource implements IPermissionPlatformDataSource {
  const PermissionHandlerDataSource();

  @override
  Future<AppPermissionStatus> status({
    required AppPermission permission,
  }) async {
    final alternatives = _alternatives(permission);
    final statuses = <Permission, PermissionStatus>{
      for (final platform in alternatives.expand((group) => group))
        platform: await platform.status,
    };
    return PermissionStatusResolver.resolve(
      alternatives: alternatives,
      statuses: statuses,
    );
  }

  @override
  Future<AppPermissionStatus> request({
    required AppPermission permission,
  }) async {
    final alternatives = _alternatives(permission);
    // One request for every platform permission involved: the ones that do not
    // exist on this OS version are reported as denied without a prompt.
    final statuses = await alternatives
        .expand((group) => group)
        .toSet()
        .toList()
        .request();
    return PermissionStatusResolver.resolve(
      alternatives: alternatives,
      statuses: statuses,
    );
  }

  @override
  Future<bool> isLocationServiceEnabled() =>
      Geolocator.isLocationServiceEnabled();

  @override
  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();

  @override
  Future<bool> openAppSettings() => ph.openAppSettings();

  List<List<Permission>> _alternatives(AppPermission permission) =>
      PlatformPermissions.alternativesFor(
        permission: permission,
        isAndroid: defaultTargetPlatform == TargetPlatform.android,
      );
}
