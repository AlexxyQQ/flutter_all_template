import 'package:flutter_all_template/features/permission/data/helpers/permission_status_resolver.dart';
import 'package:flutter_all_template/features/permission/domain/entities/app_permission_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  const legacyStorage = [Permission.storage];
  const media = [Permission.photos, Permission.videos, Permission.audio];
  const storage = [legacyStorage, media];

  AppPermissionStatus resolve(
    List<List<Permission>> alternatives,
    Map<Permission, PermissionStatus> statuses,
  ) => PermissionStatusResolver.resolve(
    alternatives: alternatives,
    statuses: statuses,
  );

  test('maps every platform status to the domain enum', () {
    expect(
      PermissionStatus.values
          .map(PermissionStatusResolver.fromPlatform)
          .toSet(),
      AppPermissionStatus.values.toSet(),
    );
  });

  test('a single permission passes its status through', () {
    expect(
      resolve(
        const [
          [Permission.camera],
        ],
        {Permission.camera: PermissionStatus.permanentlyDenied},
      ),
      AppPermissionStatus.permanentlyDenied,
    );
  });

  group('Android storage', () {
    test('Android 13+: media granted, legacy storage reports denied', () {
      expect(
        resolve(storage, {
          Permission.storage: PermissionStatus.denied,
          Permission.photos: PermissionStatus.granted,
          Permission.videos: PermissionStatus.granted,
          Permission.audio: PermissionStatus.granted,
        }),
        AppPermissionStatus.granted,
      );
    });

    test('Android 12: legacy storage granted, media report denied', () {
      expect(
        resolve(storage, {
          Permission.storage: PermissionStatus.granted,
          Permission.photos: PermissionStatus.denied,
          Permission.videos: PermissionStatus.denied,
          Permission.audio: PermissionStatus.denied,
        }),
        AppPermissionStatus.granted,
      );
    });

    test('partially granted media permissions are not enough', () {
      expect(
        resolve(storage, {
          Permission.storage: PermissionStatus.denied,
          Permission.photos: PermissionStatus.granted,
          Permission.videos: PermissionStatus.granted,
          Permission.audio: PermissionStatus.denied,
        }),
        AppPermissionStatus.denied,
      );
    });

    test('limited photo access counts as usable', () {
      expect(
        resolve(storage, {
          Permission.storage: PermissionStatus.denied,
          Permission.photos: PermissionStatus.limited,
          Permission.videos: PermissionStatus.granted,
          Permission.audio: PermissionStatus.granted,
        }),
        AppPermissionStatus.limited,
      );
    });

    test('a permanent denial wins over the inapplicable alternative', () {
      expect(
        resolve(storage, {
          Permission.storage: PermissionStatus.denied,
          Permission.photos: PermissionStatus.permanentlyDenied,
          Permission.videos: PermissionStatus.denied,
          Permission.audio: PermissionStatus.denied,
        }),
        AppPermissionStatus.permanentlyDenied,
      );
    });
  });

  test('a missing status counts as denied', () {
    expect(
      resolve(const [
        [Permission.camera],
      ], const {}),
      AppPermissionStatus.denied,
    );
  });
}
