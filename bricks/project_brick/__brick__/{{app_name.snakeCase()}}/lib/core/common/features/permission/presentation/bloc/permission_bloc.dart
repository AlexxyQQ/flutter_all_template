import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/entities/failure.dart';
import '../../domain/entities/app_permission.dart';
import '../../domain/entities/app_permission_status.dart';
import '../../domain/repository/permission_repository.dart';

part 'permission_event.dart';
part 'permission_state.dart';

@injectable
class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  PermissionBloc(this._permissions, this._skips)
    : super(const PermissionState()) {
    on<PermissionChecked>(_onChecked, transformer: concurrent());
    // One OS prompt at a time; extra taps while a prompt is open are dropped.
    on<PermissionRequested>(_onRequested, transformer: droppable());
    on<PermissionSkipped>(_onSkipped, transformer: sequential());
    on<AllPermissionsChecked>(_onAllChecked, transformer: droppable());
    on<PermissionSettingsOpened>(_onSettingsOpened, transformer: droppable());
  }

  final IPermissionRepository _permissions;
  final IPermissionSkipRepository _skips;

  Future<void> _onChecked(
    PermissionChecked event,
    Emitter<PermissionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: () => null));
    final result = await _permissions.check(event.permission);
    emit(_withResult(event.permission, result));
  }

  Future<void> _onRequested(
    PermissionRequested event,
    Emitter<PermissionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: () => null));
    final result = await _permissions.request(event.permission);
    emit(
      _withResult(event.permission, result).copyWith(
        lastRequested: event.permission,
        requestCount: state.requestCount + 1,
      ),
    );
  }

  Future<void> _onSkipped(
    PermissionSkipped event,
    Emitter<PermissionState> emit,
  ) async {
    final result = await _skips.markSkipped(event.permission);
    result.fold(
      (failure) => emit(state.copyWith(error: () => failure)),
      // Only the skipped set changes: the OS status is left untouched (B15).
      (_) => emit(
        state.copyWith(
          skipped: {...state.skipped, event.permission},
          error: () => null,
        ),
      ),
    );
  }

  Future<void> _onAllChecked(
    AllPermissionsChecked event,
    Emitter<PermissionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: () => null));
    final statuses = {...state.statuses};
    final skipped = {...state.skipped};
    Failure? error;
    for (final permission in AppPermission.values) {
      final result = await _permissions.check(permission);
      result.fold((f) => error ??= f, (s) => statuses[permission] = s);
      _syncSkipped(skipped, permission);
    }
    emit(
      state.copyWith(
        statuses: statuses,
        skipped: skipped,
        isLoading: false,
        error: () => error,
      ),
    );
  }

  Future<void> _onSettingsOpened(
    PermissionSettingsOpened event,
    Emitter<PermissionState> emit,
  ) async {
    final result = await _permissions.openSettings();
    result.fold((f) => emit(state.copyWith(error: () => f)), (_) {});
  }

  PermissionState _withResult(
    AppPermission permission,
    Either<Failure, AppPermissionStatus> result,
  ) {
    final skipped = {...state.skipped};
    _syncSkipped(skipped, permission);
    return result.fold(
      (failure) => state.copyWith(
        skipped: skipped,
        isLoading: false,
        error: () => failure,
      ),
      (status) => state.copyWith(
        statuses: {...state.statuses, permission: status},
        skipped: skipped,
        isLoading: false,
      ),
    );
  }

  void _syncSkipped(Set<AppPermission> skipped, AppPermission permission) {
    if (_skips.isSkipped(permission)) {
      skipped.add(permission);
    } else {
      skipped.remove(permission);
    }
  }
}
