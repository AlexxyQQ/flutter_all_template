import 'package:flutter_all_template/core/common/features/permission/domain/entities/app_permission.dart';
import 'package:flutter_all_template/core/common/features/permission/domain/entities/app_permission_status.dart';
import 'package:flutter_all_template/core/common/features/permission/domain/repository/permission_repository.dart';
import 'package:flutter_all_template/core/common/features/permission/domain/usecases/check_permission_use_case.dart';
import 'package:flutter_all_template/core/common/features/permission/domain/usecases/is_permission_skipped_use_case.dart';
import 'package:flutter_all_template/core/common/features/permission/domain/usecases/mark_permission_skipped_use_case.dart';
import 'package:flutter_all_template/core/common/features/permission/domain/usecases/open_permission_settings_use_case.dart';
import 'package:flutter_all_template/core/common/features/permission/domain/usecases/request_permission_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockPermissions extends Mock implements IPermissionRepository {}

class _MockSkips extends Mock implements IPermissionSkipRepository {}

void main() {
  late _MockPermissions permissions;
  late _MockSkips skips;
  const camera = AppPermission.camera;

  setUp(() {
    permissions = _MockPermissions();
    skips = _MockSkips();
  });

  test('check and request forward the permission', () async {
    when(
      () => permissions.check(permission: camera),
    ).thenAnswer((_) async => const Right(AppPermissionStatus.granted));
    when(
      () => permissions.request(permission: camera),
    ).thenAnswer((_) async => const Right(AppPermissionStatus.denied));

    final checked = await CheckPermissionUseCase(repository: permissions)(
      permission: camera,
    );
    final requested = await RequestPermissionUseCase(repository: permissions)(
      permission: camera,
    );

    expect(checked.toNullable(), AppPermissionStatus.granted);
    expect(requested.toNullable(), AppPermissionStatus.denied);
  });

  test('openSettings forwards', () async {
    when(
      () => permissions.openSettings(),
    ).thenAnswer((_) async => const Right(true));

    final opened = await OpenPermissionSettingsUseCase(
      repository: permissions,
    )();

    expect(opened.toNullable(), isTrue);
  });

  test('skip use cases forward the permission', () async {
    when(() => skips.isSkipped(permission: camera)).thenReturn(true);
    when(
      () => skips.markSkipped(permission: camera),
    ).thenAnswer((_) async => const Right(null));

    expect(
      IsPermissionSkippedUseCase(repository: skips)(permission: camera),
      isTrue,
    );
    await MarkPermissionSkippedUseCase(repository: skips)(permission: camera);
    verify(() => skips.markSkipped(permission: camera)).called(1);
  });
}
