import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/entities/failure.dart';
import '../../domain/entities/app_permission.dart';
import '../../domain/entities/app_permission_status.dart';
import '../../domain/usecases/check_permission_use_case.dart';
import '../../domain/usecases/is_permission_skipped_use_case.dart';
import '../../domain/usecases/mark_permission_skipped_use_case.dart';
import '../../domain/usecases/open_permission_settings_use_case.dart';
import '../../domain/usecases/request_permission_use_case.dart';

part 'permission_event.dart';
part 'permission_state.dart';

@injectable
class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  PermissionBloc({
    required CheckPermissionUseCase check,
    required RequestPermissionUseCase request,
    required OpenPermissionSettingsUseCase openSettings,
    required IsPermissionSkippedUseCase isSkipped,
    required MarkPermissionSkippedUseCase markSkipped,
  }) : _check = check,
       _request = request,
       _openSettings = openSettings,
       _isSkipped = isSkipped,
       _markSkipped = markSkipped,
       super(const PermissionState()) {
    on<PermissionChecked>(_onChecked, transformer: concurrent());
    // One OS prompt at a time; extra taps while a prompt is open are dropped.
    on<PermissionRequested>(_onRequested, transformer: droppable());
    on<PermissionSkipped>(_onSkipped, transformer: sequential());
    on<AllPermissionsChecked>(_onAllChecked, transformer: droppable());
    on<PermissionSettingsOpened>(_onSettingsOpened, transformer: droppable());
  }

  final CheckPermissionUseCase _check;
  final RequestPermissionUseCase _request;
  final OpenPermissionSettingsUseCase _openSettings;
  final IsPermissionSkippedUseCase _isSkipped;
  final MarkPermissionSkippedUseCase _markSkipped;

  Future<void> _onChecked(
    PermissionChecked event,
    Emitter<PermissionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: () => null));
    final result = await _check(permission: event.permission);
    emit(_withResult(event.permission, result));
  }

  Future<void> _onRequested(
    PermissionRequested event,
    Emitter<PermissionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: () => null));
    final result = await _request(permission: event.permission);
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
    final result = await _markSkipped(permission: event.permission);
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
      final result = await _check(permission: permission);
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
    final result = await _openSettings();
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
    if (_isSkipped(permission: permission)) {
      skipped.add(permission);
    } else {
      skipped.remove(permission);
    }
  }
}
