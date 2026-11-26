import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_all_template/core/common/domain/entities/failure.dart';
import 'package:flutter_all_template/core/common/features/permission/domain/entities/app_permission.dart';
import 'package:flutter_all_template/core/common/features/permission/domain/entities/app_permission_status.dart';
import 'package:flutter_all_template/core/common/features/permission/domain/repository/permission_repository.dart';
import 'package:flutter_all_template/core/common/features/permission/domain/usecases/check_permission_use_case.dart';
import 'package:flutter_all_template/core/common/features/permission/domain/usecases/is_permission_skipped_use_case.dart';
import 'package:flutter_all_template/core/common/features/permission/domain/usecases/mark_permission_skipped_use_case.dart';
import 'package:flutter_all_template/core/common/features/permission/domain/usecases/open_permission_settings_use_case.dart';
import 'package:flutter_all_template/core/common/features/permission/domain/usecases/request_permission_use_case.dart';
import 'package:flutter_all_template/core/common/features/permission/presentation/bloc/permission_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockPermissionRepository extends Mock implements IPermissionRepository {}

class _MockSkipRepository extends Mock implements IPermissionSkipRepository {}

void main() {
  late _MockPermissionRepository permissions;
  late _MockSkipRepository skips;

  const failure = Failure(message: 'x', type: FailureType.permission);

  setUpAll(() => registerFallbackValue(AppPermission.camera));

  setUp(() {
    permissions = _MockPermissionRepository();
    skips = _MockSkipRepository();
    when(
      () => skips.isSkipped(permission: any(named: 'permission')),
    ).thenReturn(false);
  });

  PermissionBloc build() => PermissionBloc(
    check: CheckPermissionUseCase(repository: permissions),
    request: RequestPermissionUseCase(repository: permissions),
    openSettings: OpenPermissionSettingsUseCase(repository: permissions),
    isSkipped: IsPermissionSkippedUseCase(repository: skips),
    markSkipped: MarkPermissionSkippedUseCase(repository: skips),
  );

  group('PermissionChecked', () {
    blocTest<PermissionBloc, PermissionState>(
      'stores the OS status',
      setUp: () => when(
        () => permissions.check(permission: AppPermission.camera),
      ).thenAnswer((_) async => const Right(AppPermissionStatus.granted)),
      build: build,
      act: (bloc) => bloc.add(const PermissionChecked(AppPermission.camera)),
      expect: () => const [
        PermissionState(isLoading: true),
        PermissionState(
          statuses: {AppPermission.camera: AppPermissionStatus.granted},
        ),
      ],
      verify: (bloc) =>
          expect(bloc.state.isGranted(AppPermission.camera), isTrue),
    );

    blocTest<PermissionBloc, PermissionState>(
      'loads the persisted skipped flag without granting',
      setUp: () {
        when(
          () => skips.isSkipped(permission: AppPermission.location),
        ).thenReturn(true);
        when(
          () => permissions.check(permission: AppPermission.location),
        ).thenAnswer((_) async => const Right(AppPermissionStatus.denied));
      },
      build: build,
      act: (bloc) => bloc.add(const PermissionChecked(AppPermission.location)),
      skip: 1,
      expect: () => const [
        PermissionState(
          statuses: {AppPermission.location: AppPermissionStatus.denied},
          skipped: {AppPermission.location},
        ),
      ],
      verify: (bloc) {
        expect(bloc.state.isGranted(AppPermission.location), isFalse);
        expect(bloc.state.canProceed(AppPermission.location), isTrue);
      },
    );

    blocTest<PermissionBloc, PermissionState>(
      'emits the failure',
      setUp: () => when(
        () => permissions.check(permission: AppPermission.camera),
      ).thenAnswer((_) async => const Left(failure)),
      build: build,
      act: (bloc) => bloc.add(const PermissionChecked(AppPermission.camera)),
      skip: 1,
      expect: () => const [PermissionState(error: failure)],
    );
  });

  group('PermissionRequested', () {
    blocTest<PermissionBloc, PermissionState>(
      'records the result and bumps requestCount',
      setUp: () =>
          when(
            () => permissions.request(permission: AppPermission.microphone),
          ).thenAnswer(
            (_) async => const Right(AppPermissionStatus.permanentlyDenied),
          ),
      build: build,
      act: (bloc) =>
          bloc.add(const PermissionRequested(AppPermission.microphone)),
      expect: () => const [
        PermissionState(isLoading: true),
        PermissionState(
          statuses: {
            AppPermission.microphone: AppPermissionStatus.permanentlyDenied,
          },
          lastRequested: AppPermission.microphone,
          requestCount: 1,
        ),
      ],
      verify: (bloc) => expect(
        bloc.state.statusOf(AppPermission.microphone)!.requiresSettings,
        isTrue,
      ),
    );

    blocTest<PermissionBloc, PermissionState>(
      'drops a second request while one is in flight',
      setUp: () =>
          when(
            () => permissions.request(permission: AppPermission.camera),
          ).thenAnswer((_) async {
            await Future<void>.delayed(const Duration(milliseconds: 10));
            return const Right(AppPermissionStatus.granted);
          }),
      build: build,
      act: (bloc) => bloc
        ..add(const PermissionRequested(AppPermission.camera))
        ..add(const PermissionRequested(AppPermission.camera)),
      wait: const Duration(milliseconds: 50),
      verify: (_) => verify(
        () => permissions.request(permission: AppPermission.camera),
      ).called(1),
    );
  });

  group('PermissionSkipped', () {
    blocTest<PermissionBloc, PermissionState>(
      'marks skipped but does NOT report granted (B15)',
      setUp: () => when(
        () => skips.markSkipped(permission: AppPermission.location),
      ).thenAnswer((_) async => const Right(null)),
      build: build,
      seed: () => const PermissionState(
        statuses: {AppPermission.location: AppPermissionStatus.denied},
      ),
      act: (bloc) => bloc.add(const PermissionSkipped(AppPermission.location)),
      expect: () => const [
        PermissionState(
          statuses: {AppPermission.location: AppPermissionStatus.denied},
          skipped: {AppPermission.location},
        ),
      ],
      verify: (bloc) {
        expect(bloc.state.isGranted(AppPermission.location), isFalse);
        expect(
          bloc.state.statusOf(AppPermission.location),
          AppPermissionStatus.denied,
        );
        expect(bloc.state.isSkipped(AppPermission.location), isTrue);
        verifyNever(
          () => permissions.request(permission: any(named: 'permission')),
        );
      },
    );

    blocTest<PermissionBloc, PermissionState>(
      'keeps it un-skipped when persisting fails',
      setUp: () => when(
        () => skips.markSkipped(permission: AppPermission.camera),
      ).thenAnswer((_) async => const Left(failure)),
      build: build,
      act: (bloc) => bloc.add(const PermissionSkipped(AppPermission.camera)),
      expect: () => const [PermissionState(error: failure)],
    );
  });

  blocTest<PermissionBloc, PermissionState>(
    'AllPermissionsChecked checks every permission',
    setUp: () => when(
      () => permissions.check(permission: any(named: 'permission')),
    ).thenAnswer((_) async => const Right(AppPermissionStatus.denied)),
    build: build,
    act: (bloc) => bloc.add(const AllPermissionsChecked()),
    skip: 1,
    expect: () => [
      PermissionState(
        statuses: {
          for (final p in AppPermission.values) p: AppPermissionStatus.denied,
        },
      ),
    ],
    verify: (_) => verify(
      () => permissions.check(permission: any(named: 'permission')),
    ).called(AppPermission.values.length),
  );
}
