import 'package:flutter_all_template/core/common/domain/entities/failure.dart';
import 'package:flutter_all_template/core/common/features/permission/domain/entities/app_permission.dart';
import 'package:flutter_all_template/core/common/features/permission/domain/entities/app_permission_status.dart';
import 'package:flutter_all_template/core/common/features/permission/domain/repository/permission_repository.dart';
import 'package:flutter_all_template/core/common/features/permission/domain/usecases/check_permission_use_case.dart';
import 'package:flutter_all_template/core/common/features/permission/domain/usecases/is_permission_skipped_use_case.dart';
import 'package:flutter_all_template/core/common/features/permission/presentation/routes/permission_gate.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockPermissionRepository extends Mock implements IPermissionRepository {}

class _MockSkipRepository extends Mock implements IPermissionSkipRepository {}

void main() {
  late _MockPermissionRepository permissions;
  late _MockSkipRepository skips;
  late PermissionGate gate;

  const camera = AppPermission.camera;

  setUp(() {
    permissions = _MockPermissionRepository();
    skips = _MockSkipRepository();
    gate = PermissionGate(
      check: CheckPermissionUseCase(repository: permissions),
      isSkipped: IsPermissionSkippedUseCase(repository: skips),
    );
    when(() => skips.isSkipped(permission: camera)).thenReturn(false);
  });

  void stubStatus(AppPermissionStatus status) => when(
    () => permissions.check(permission: camera),
  ).thenAnswer((_) async => Right(status));

  test('granted: proceed', () async {
    stubStatus(AppPermissionStatus.granted);
    expect(await gate.canProceed(camera), isTrue);
  });

  test('limited: proceed', () async {
    stubStatus(AppPermissionStatus.limited);
    expect(await gate.canProceed(camera), isTrue);
  });

  test('denied and not skipped: blocked', () async {
    stubStatus(AppPermissionStatus.denied);
    expect(await gate.canProceed(camera), isFalse);
  });

  test('skipped: proceed without querying the OS', () async {
    when(() => skips.isSkipped(permission: camera)).thenReturn(true);
    expect(await gate.canProceed(camera), isTrue);
    verifyNever(() => permissions.check(permission: camera));
  });

  test('skipped but allowIfSkipped=false: uses the real status', () async {
    when(() => skips.isSkipped(permission: camera)).thenReturn(true);
    stubStatus(AppPermissionStatus.denied);
    expect(await gate.canProceed(camera, allowIfSkipped: false), isFalse);
  });

  test('failure: blocked', () async {
    when(
      () => permissions.check(permission: camera),
    ).thenAnswer((_) async => const Left(Failure.unknown()));
    expect(await gate.canProceed(camera), isFalse);
  });
}
