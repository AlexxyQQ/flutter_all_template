import 'package:flutter_all_template/features/permission/data/helpers/platform_permissions.dart';
import 'package:flutter_all_template/features/permission/domain/entities/app_permission.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  List<List<Permission>> alternatives(
    AppPermission permission, {
    required bool isAndroid,
  }) => PlatformPermissions.alternativesFor(
    permission: permission,
    isAndroid: isAndroid,
  );

  test('every permission maps to at least one platform permission', () {
    for (final permission in AppPermission.values) {
      for (final isAndroid in [true, false]) {
        final mapped = alternatives(permission, isAndroid: isAndroid);
        expect(mapped, isNotEmpty, reason: '$permission android=$isAndroid');
        expect(mapped.every((group) => group.isNotEmpty), isTrue);
      }
    }
  });

  group('storage', () {
    test('Android offers the legacy and the Android 13+ media permissions', () {
      expect(alternatives(AppPermission.storage, isAndroid: true), [
        [Permission.storage],
        [Permission.photos, Permission.videos, Permission.audio],
      ]);
    });

    test('iOS uses the photo library', () {
      expect(alternatives(AppPermission.storage, isAndroid: false), [
        [Permission.photos],
      ]);
    });
  });

  group('bluetooth', () {
    test('Android offers the legacy and the Android 12+ permissions', () {
      expect(alternatives(AppPermission.bluetooth, isAndroid: true), [
        [Permission.bluetooth],
        [Permission.bluetoothScan, Permission.bluetoothConnect],
      ]);
    });

    test('iOS has a single bluetooth permission', () {
      expect(alternatives(AppPermission.bluetooth, isAndroid: false), [
        [Permission.bluetooth],
      ]);
    });
  });

  test('simple permissions map one to one', () {
    expect(alternatives(AppPermission.camera, isAndroid: true), [
      [Permission.camera],
    ]);
    expect(alternatives(AppPermission.location, isAndroid: false), [
      [Permission.locationWhenInUse],
    ]);
  });
}
