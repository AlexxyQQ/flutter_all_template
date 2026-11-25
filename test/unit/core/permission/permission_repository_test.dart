import 'package:flutter/services.dart';
import 'package:flutter_all_template/core/common/domain/entities/failure.dart';
import 'package:flutter_all_template/core/common/domain/services/notification/notification_permission_api.dart';
import 'package:flutter_all_template/core/common/features/permission/data/data_sources/permission_platform_data_source.dart';
import 'package:flutter_all_template/core/common/features/permission/data/repository/permission_repository_impl.dart';
import 'package:flutter_all_template/core/common/features/permission/data/repository/permission_skip_repository_impl.dart';
import 'package:flutter_all_template/core/common/features/permission/domain/entities/app_permission.dart';
import 'package:flutter_all_template/core/common/features/permission/domain/entities/app_permission_status.dart';
import 'package:flutter_all_template/core/common/features/permission/permission_spec.dart';
import 'package:flutter_all_template/core/error/app_exception.dart';
import 'package:flutter_all_template/core/storage/key_value_stores.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler/permission_handler.dart';

class _MockPlatform extends Mock implements PermissionPlatformDataSource {}

class _MockNotifications extends Mock implements NotificationPermissionApi {}

class _MockPrefs extends Mock implements PreferencesStore {}

void main() {
  setUpAll(() => registerFallbackValue(Permission.camera));

  group('PermissionRepositoryImpl', () {
    late _MockPlatform platform;
    late _MockNotifications notifications;
    late PermissionRepositoryImpl repository;

    setUp(() {
      platform = _MockPlatform();
      notifications = _MockNotifications();
      repository = PermissionRepositoryImpl(platform, notifications);
    });

    test('maps every platform status to the domain enum', () {
      expect(
        PermissionStatus.values.map(mapPermissionStatus).toSet(),
        AppPermissionStatus.values.toSet(),
      );
    });

    test('check uses the spec platform permission', () async {
      when(
        () => platform.status(Permission.camera),
      ).thenAnswer((_) async => PermissionStatus.permanentlyDenied);

      final result = await repository.check(AppPermission.camera);

      expect(
        result,
        const Right<Failure, AppPermissionStatus>(
          AppPermissionStatus.permanentlyDenied,
        ),
      );
    });

    test('notification request delegates to the notification module', () async {
      when(notifications.requestPermission).thenAnswer((_) async => true);

      final result = await repository.request(AppPermission.notification);

      expect(result.getRight().toNullable(), AppPermissionStatus.granted);
      verify(notifications.requestPermission).called(1);
      verifyNever(() => platform.request(any()));
    });

    test('location check is denied while location services are off', () async {
      when(platform.isLocationServiceEnabled).thenAnswer((_) async => false);

      final result = await repository.check(AppPermission.location);

      expect(result.getRight().toNullable(), AppPermissionStatus.denied);
      verifyNever(() => platform.status(any()));
    });

    test('platform errors become a Failure', () async {
      when(
        () => platform.request(Permission.microphone),
      ).thenThrow(PlatformException(code: 'boom'));

      final result = await repository.request(AppPermission.microphone);

      expect(result.isLeft(), isTrue);
    });
  });

  group('PermissionSkipRepositoryImpl', () {
    late _MockPrefs prefs;
    late PermissionSkipRepositoryImpl repository;

    setUp(() {
      prefs = _MockPrefs();
      repository = PermissionSkipRepositoryImpl(prefs);
    });

    test('reads the per-permission flag', () {
      when(() => prefs.getBool('permission.skipped.camera')).thenReturn(true);
      when(() => prefs.getBool('permission.skipped.phone')).thenReturn(null);

      expect(repository.isSkipped(AppPermission.camera), isTrue);
      expect(repository.isSkipped(AppPermission.phone), isFalse);
    });

    test('markSkipped persists in preferences', () async {
      when(
        () => prefs.setBool('permission.skipped.camera', value: true),
      ).thenAnswer((_) async {});

      final result = await repository.markSkipped(AppPermission.camera);

      expect(result.isRight(), isTrue);
    });

    test('storage errors become a Failure', () async {
      when(
        () => prefs.setBool(any(), value: any(named: 'value')),
      ).thenThrow(const StorageException());

      final result = await repository.markSkipped(AppPermission.camera);

      expect(result.getLeft().toNullable()?.type, FailureType.storage);
    });
  });

  group('AppPermission', () {
    test('tryParse rejects unknown values', () {
      expect(AppPermission.tryParse('camera'), AppPermission.camera);
      expect(AppPermission.tryParse('/admin'), isNull);
      expect(AppPermission.tryParse(null), isNull);
    });

    test('every permission has a spec for itself', () {
      for (final permission in AppPermission.values) {
        expect(permission.spec.permission, permission);
      }
    });
  });
}
