import 'package:permission_handler/permission_handler.dart';

import '../../domain/entities/app_permission.dart';

/// Maps an [AppPermission] to the `permission_handler` permissions that back
/// it on the running OS.
///
/// The result is a list of *alternatives*: the app permission is granted when
/// every platform permission of at least one alternative is granted. Android
/// replaced some permissions over time, and an alternative that does not exist
/// on the running SDK reports "denied" (never "permanently denied"), so the
/// alternative that applies decides:
///
/// * storage: `READ_EXTERNAL_STORAGE` up to Android 12, photos + videos +
///   audio (`READ_MEDIA_*`) on Android 13+. `Permission.storage` is always
///   denied on Android 13+.
/// * bluetooth: legacy `BLUETOOTH` up to Android 11, `BLUETOOTH_SCAN` +
///   `BLUETOOTH_CONNECT` on Android 12+.
abstract final class PlatformPermissions {
  static List<List<Permission>> alternativesFor({
    required AppPermission permission,
    required bool isAndroid,
  }) => switch (permission) {
    AppPermission.notification => const [
      [Permission.notification],
    ],
    AppPermission.location => const [
      [Permission.locationWhenInUse],
    ],
    AppPermission.storage =>
      isAndroid
          ? const [
              [Permission.storage],
              [Permission.photos, Permission.videos, Permission.audio],
            ]
          : const [
              [Permission.photos],
            ],
    AppPermission.camera => const [
      [Permission.camera],
    ],
    AppPermission.microphone => const [
      [Permission.microphone],
    ],
    AppPermission.contacts => const [
      [Permission.contacts],
    ],
    AppPermission.calendar => const [
      [Permission.calendarFullAccess],
    ],
    AppPermission.bluetooth =>
      isAndroid
          ? const [
              [Permission.bluetooth],
              [Permission.bluetoothScan, Permission.bluetoothConnect],
            ]
          : const [
              [Permission.bluetooth],
            ],
    AppPermission.phone => const [
      [Permission.phone],
    ],
    AppPermission.activityRecognition => const [
      [Permission.activityRecognition],
    ],
  };
}
