import 'package:flutter/services.dart';
import 'package:flutter_all_template/core/error/app_exception.dart';
import 'package:flutter_all_template/core/error/failure.dart';
import 'package:flutter_all_template/core/services/notification/domain/notification_permission_api.dart';
import 'package:flutter_all_template/core/storage/key_value_stores.dart';
import 'package:flutter_all_template/features/permission/data/data_sources/permission_platform_data_source.dart';
import 'package:flutter_all_template/features/permission/data/repositories/permission_repository_impl.dart';
import 'package:flutter_all_template/features/permission/data/repositories/permission_skip_repository_impl.dart';
import 'package:flutter_all_template/features/permission/domain/entities/app_permission.dart';
import 'package:flutter_all_template/features/permission/domain/entities/app_permission_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockPlatform extends Mock implements IPermissionPlatformDataSource {}

class _MockNotifications extends Mock implements INotificationPermissionApi {}

class _MockPrefs extends Mock implements IPreferencesStore {}

void main() {
  setUpAll(() => registerFallbackValue(AppPermission.camera));

  group('PermissionRepositoryImpl', () {
    late _MockPlatform platform;
    late _MockNotifications notifications;
    late PermissionRepositoryImpl repository;

    setUp(() {
      platform = _MockPlatform();
      notifications = _MockNotifications();
      repository = PermissionRepositoryImpl(
        platform: platform,
        notifications: notifications,
      );
    });

    test('check returns the platform status', () async {
      when(
        () => platform.status(permission: AppPermission.camera),
      ).thenAnswer((_) async => AppPermissionStatus.permanentlyDenied);

      final result = await repository.check(permission: AppPermission.camera);

      expect(
        result,
        const Right<Failure, AppPermissionStatus>(
          AppPermissionStatus.permanentlyDenied,
        ),
      );
    });

    test('request returns the platform result', () async {
      when(
        () => platform.request(permission: AppPermission.storage),
      ).thenAnswer((_) async => AppPermissionStatus.limited);

      final result = await repository.request(
        permission: AppPermission.storage,
      );

      expect(result.getRight().toNullable(), AppPermissionStatus.limited);
    });

    test('notification request delegates to the notification module', () async {
      when(notifications.requestPermission).thenAnswer((_) async => true);

      final result = await repository.request(
        permission: AppPermission.notification,
      );

      expect(result.getRight().toNullable(), AppPermissionStatus.granted);
      verify(notifications.requestPermission).called(1);
      verifyNever(() => platform.request(permission: any(named: 'permission')));
    });

    test('a refused notification request asks the OS why', () async {
      when(notifications.requestPermission).thenAnswer((_) async => false);
      when(
        () => platform.status(permission: AppPermission.notification),
      ).thenAnswer((_) async => AppPermissionStatus.permanentlyDenied);

      final result = await repository.request(
        permission: AppPermission.notification,
      );

      expect(
        result.getRight().toNullable(),
        AppPermissionStatus.permanentlyDenied,
      );
    });

    test('notification check is granted by the notification module', () async {
      when(notifications.isPermissionGranted).thenAnswer((_) async => true);

      final result = await repository.check(
        permission: AppPermission.notification,
      );

      expect(result.getRight().toNullable(), AppPermissionStatus.granted);
      verifyNever(() => platform.status(permission: any(named: 'permission')));
    });

    group('location', () {
      test('check reports the real permission while GPS is off', () async {
        when(
          () => platform.status(permission: AppPermission.location),
        ).thenAnswer((_) async => AppPermissionStatus.granted);
        when(platform.isLocationServiceEnabled).thenAnswer((_) async => false);

        final result = await repository.check(
          permission: AppPermission.location,
        );

        expect(result.getRight().toNullable(), AppPermissionStatus.granted);
        verifyNever(platform.isLocationServiceEnabled);
      });

      test('request never opens the location settings', () async {
        when(
          () => platform.request(permission: AppPermission.location),
        ).thenAnswer((_) async => AppPermissionStatus.denied);

        await repository.request(permission: AppPermission.location);

        verifyNever(platform.openLocationSettings);
      });

      test('service status is a separate question', () async {
        when(platform.isLocationServiceEnabled).thenAnswer((_) async => false);
        when(platform.openLocationSettings).thenAnswer((_) async => true);

        final enabled = await repository.isLocationServiceEnabled();
        final opened = await repository.openLocationSettings();

        expect(enabled.getRight().toNullable(), isFalse);
        expect(opened.getRight().toNullable(), isTrue);
      });
    });

    test('platform errors become a Failure', () async {
      when(
        () => platform.request(permission: AppPermission.microphone),
      ).thenThrow(PlatformException(code: 'boom'));

      final result = await repository.request(
        permission: AppPermission.microphone,
      );

      expect(result.isLeft(), isTrue);
    });
  });

  group('PermissionSkipRepositoryImpl', () {
    late _MockPrefs prefs;
    late PermissionSkipRepositoryImpl repository;

    setUp(() {
      prefs = _MockPrefs();
      repository = PermissionSkipRepositoryImpl(prefs: prefs);
    });

    test('reads the per-permission flag', () {
      when(
        () => prefs.getBool(key: 'permission.skipped.camera'),
      ).thenReturn(true);
      when(
        () => prefs.getBool(key: 'permission.skipped.phone'),
      ).thenReturn(null);

      expect(repository.isSkipped(permission: AppPermission.camera), isTrue);
      expect(repository.isSkipped(permission: AppPermission.phone), isFalse);
    });

    test('markSkipped persists in preferences', () async {
      when(
        () => prefs.setBool(key: 'permission.skipped.camera', value: true),
      ).thenAnswer((_) async {});

      final result = await repository.markSkipped(
        permission: AppPermission.camera,
      );

      expect(result.isRight(), isTrue);
    });

    test('storage errors become a Failure', () async {
      when(
        () => prefs.setBool(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenThrow(const StorageException());

      final result = await repository.markSkipped(
        permission: AppPermission.camera,
      );

      expect(result.getLeft().toNullable()?.type, FailureType.storage);
    });
  });

  group('AppPermission', () {
    test('tryParse rejects unknown values', () {
      expect(AppPermission.tryParse('camera'), AppPermission.camera);
      expect(AppPermission.tryParse('/admin'), isNull);
      expect(AppPermission.tryParse(null), isNull);
    });
  });
}
