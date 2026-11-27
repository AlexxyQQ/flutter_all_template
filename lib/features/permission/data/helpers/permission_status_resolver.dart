import 'package:permission_handler/permission_handler.dart';

import '../../domain/entities/app_permission_status.dart';

/// Turns `permission_handler` statuses into one domain status.
abstract final class PermissionStatusResolver {
  /// Maps one platform status to the domain enum.
  static AppPermissionStatus fromPlatform(PermissionStatus status) =>
      switch (status) {
        PermissionStatus.granted => AppPermissionStatus.granted,
        PermissionStatus.limited => AppPermissionStatus.limited,
        PermissionStatus.provisional => AppPermissionStatus.provisional,
        PermissionStatus.restricted => AppPermissionStatus.restricted,
        PermissionStatus.permanentlyDenied =>
          AppPermissionStatus.permanentlyDenied,
        PermissionStatus.denied => AppPermissionStatus.denied,
      };

  /// Combines the [statuses] of the platform permissions in [alternatives]
  /// (see `PlatformPermissions`): the best usable alternative wins, otherwise
  /// the most restrictive status explains why the user cannot proceed.
  static AppPermissionStatus resolve({
    required List<List<Permission>> alternatives,
    required Map<Permission, PermissionStatus> statuses,
  }) {
    final perAlternative = [
      for (final group in alternatives)
        _weakest([
          for (final permission in group)
            fromPlatform(statuses[permission] ?? PermissionStatus.denied),
        ]),
    ];
    final usable = perAlternative.where((status) => status.isGranted);
    if (usable.isNotEmpty) {
      return usable.reduce((a, b) => _rank(a) <= _rank(b) ? a : b);
    }
    return _weakest(perAlternative);
  }

  /// A group needs all its permissions, so the most restrictive one decides.
  static AppPermissionStatus _weakest(List<AppPermissionStatus> statuses) =>
      statuses.reduce((a, b) => _rank(a) >= _rank(b) ? a : b);

  /// Higher = more restrictive; granted-like statuses rank below denials.
  static int _rank(AppPermissionStatus status) => switch (status) {
    AppPermissionStatus.granted => 0,
    AppPermissionStatus.provisional => 1,
    AppPermissionStatus.limited => 2,
    AppPermissionStatus.denied => 3,
    AppPermissionStatus.restricted => 4,
    AppPermissionStatus.permanentlyDenied => 5,
  };
}
