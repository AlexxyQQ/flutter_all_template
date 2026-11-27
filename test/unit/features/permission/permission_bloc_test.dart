import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_all_template/core/error/failure.dart';
import 'package:flutter_all_template/features/permission/domain/entities/app_permission.dart';
import 'package:flutter_all_template/features/permission/domain/entities/app_permission_status.dart';
import 'package:flutter_all_template/features/permission/domain/repositories/permission_repository.dart';
import 'package:flutter_all_template/features/permission/domain/repositories/permission_skip_repository.dart';
import 'package:flutter_all_template/features/permission/domain/usecases/check_permission_use_case.dart';
import 'package:flutter_all_template/features/permission/domain/usecases/is_permission_skipped_use_case.dart';
import 'package:flutter_all_template/features/permission/domain/usecases/mark_permission_skipped_use_case.dart';
import 'package:flutter_all_template/features/permission/domain/usecases/open_permission_settings_use_case.dart';
import 'package:flutter_all_template/features/permission/domain/usecases/request_permission_use_case.dart';
import 'package:flutter_all_template/features/permission/presentation/bloc/permission_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockPermissionRepository extends Mock implements IPermissionRepository {}

class _MockSkipRepository extends Mock implements IPermissionSkipRepository {}

void main() {
  late _MockPermissionRepository permissions;
  late _MockSkipRepository skips;
  late Completer<Either<Failure, AppPermissionStatus>> slowCheck;
  late Completer<Either<Failure, AppPermissionStatus>> prompt;

  const failure = Failure.unknown();

  setUpAll(() => registerFallbackValue(AppPermission.camera));

  setUp(() {
    permissions = _MockPermissionRepository();
    skips = _MockSkipRepository();
    slowCheck = Completer();
    prompt = Completer();
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
      expect: () => const [PermissionState(error: failure)],
    );

    blocTest<PermissionBloc, PermissionState>(
      'overlapping checks of different permissions do not overwrite each other',
      setUp: () {
        when(
          () => permissions.check(permission: AppPermission.camera),
        ).thenAnswer((_) => slowCheck.future);
        when(
          () => permissions.check(permission: AppPermission.microphone),
        ).thenAnswer((_) async => const Right(AppPermissionStatus.denied));
      },
      build: build,
      act: (bloc) async {
        bloc
          ..add(const PermissionChecked(AppPermission.camera))
          ..add(const PermissionChecked(AppPermission.microphone));
        await pumpEventQueue();
        slowCheck.complete(const Right(AppPermissionStatus.granted));
      },
      expect: () => const [
        PermissionState(
          statuses: {AppPermission.microphone: AppPermissionStatus.denied},
        ),
        PermissionState(
          statuses: {
            AppPermission.microphone: AppPermissionStatus.denied,
            AppPermission.camera: AppPermissionStatus.granted,
          },
        ),
      ],
    );
  });

  group('PermissionRequested', () {
    blocTest<PermissionBloc, PermissionState>(
      'marks the permission as requesting, then stores the result',
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
        PermissionState(requesting: AppPermission.microphone),
        PermissionState(
          statuses: {
            AppPermission.microphone: AppPermissionStatus.permanentlyDenied,
          },
        ),
      ],
      verify: (bloc) => expect(
        bloc.state.statusOf(AppPermission.microphone)!.requiresSettings,
        isTrue,
      ),
    );

    blocTest<PermissionBloc, PermissionState>(
      'still reports a finished request when the status did not change',
      setUp: () =>
          when(
            () => permissions.request(permission: AppPermission.microphone),
          ).thenAnswer(
            (_) async => const Right(AppPermissionStatus.permanentlyDenied),
          ),
      build: build,
      seed: () => const PermissionState(
        statuses: {
          AppPermission.microphone: AppPermissionStatus.permanentlyDenied,
        },
      ),
      act: (bloc) =>
          bloc.add(const PermissionRequested(AppPermission.microphone)),
      // The requesting state in between is what makes the UI notice the end.
      expect: () => const [
        PermissionState(
          statuses: {
            AppPermission.microphone: AppPermissionStatus.permanentlyDenied,
          },
          requesting: AppPermission.microphone,
        ),
        PermissionState(
          statuses: {
            AppPermission.microphone: AppPermissionStatus.permanentlyDenied,
          },
        ),
      ],
    );

    blocTest<PermissionBloc, PermissionState>(
      'clears requesting and keeps the failure when the request fails',
      setUp: () => when(
        () => permissions.request(permission: AppPermission.camera),
      ).thenAnswer((_) async => const Left(failure)),
      build: build,
      act: (bloc) => bloc.add(const PermissionRequested(AppPermission.camera)),
      expect: () => const [
        PermissionState(requesting: AppPermission.camera),
        PermissionState(error: failure),
      ],
    );

    blocTest<PermissionBloc, PermissionState>(
      'drops a second request while one is in flight',
      setUp: () => when(
        () => permissions.request(permission: AppPermission.camera),
      ).thenAnswer((_) => prompt.future),
      build: build,
      act: (bloc) async {
        bloc
          ..add(const PermissionRequested(AppPermission.camera))
          ..add(const PermissionRequested(AppPermission.camera));
        await pumpEventQueue();
        prompt.complete(const Right(AppPermissionStatus.granted));
      },
      expect: () => const [
        PermissionState(requesting: AppPermission.camera),
        PermissionState(
          statuses: {AppPermission.camera: AppPermissionStatus.granted},
        ),
      ],
      verify: (_) => verify(
        () => permissions.request(permission: AppPermission.camera),
      ).called(1),
    );
  });

  group('PermissionSkipped', () {
    blocTest<PermissionBloc, PermissionState>(
      'marks skipped but does NOT report granted',
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

  group('PermissionSettingsOpened', () {
    blocTest<PermissionBloc, PermissionState>(
      'surfaces a failure to open the settings',
      setUp: () => when(
        () => permissions.openSettings(),
      ).thenAnswer((_) async => const Left(failure)),
      build: build,
      act: (bloc) => bloc.add(const PermissionSettingsOpened()),
      expect: () => const [PermissionState(error: failure)],
    );
  });
}
