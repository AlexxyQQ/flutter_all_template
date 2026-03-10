import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../domain/entities/failure.dart';
import '../../../../domain/services/logger/logger_service.dart';
import '../../../../domain/services/notification/notification_service.dart';
import '../../../../locator/service_locator.dart';
import '../../domain/repository/permission_repository.dart';
import '../../domain/services/permission_cache_service.dart';

part 'permission_event.dart';
part 'permission_state.dart';
part 'permission_bloc.freezed.dart';

@injectable
class PermissionBloc extends Bloc<IPermissionEvent, PermissionState> {
  PermissionBloc({required IPermissionRepository repository})
    : _repository = repository,
      super(PermissionState.initial()) {
    on<PermissionEventCheckNotificationPermission>(
      _onCheckNotificationPermission,
    );
    on<PermissionEventCheckLocationPermission>(_onCheckLocationPermission);
    on<PermissionEventCheckCameraPermission>(_onCheckCameraPermission);
    on<PermissionEventCheckMicrophonePermission>(_onCheckMicrophonePermission);
    on<PermissionEventCheckStoragePermission>(_onCheckStoragePermission);
    on<PermissionEventRequestNotificationPermission>(
      _onRequestNotificationPermission,
    );
    on<PermissionEventRequestLocationPermission>(_onRequestLocationPermission);
    on<PermissionEventRequestCameraPermission>(_onRequestCameraPermission);
    on<PermissionEventRequestMicrophonePermission>(
      _onRequestMicrophonePermission,
    );
    on<PermissionEventRequestStoragePermission>(_onRequestStoragePermission);
    on<PermissionEventSkipNotificationPermission>(
      _onSkipNotificationPermission,
    );
    on<PermissionEventSkipLocationPermission>(_onSkipLocationPermission);
    on<PermissionEventSkipCameraPermission>(_onSkipCameraPermission);
    on<PermissionEventSkipMicrophonePermission>(_onSkipMicrophonePermission);
    on<PermissionEventSkipStoragePermission>(_onSkipStoragePermission);
    on<PermissionEventCheckAllPermissions>(_onCheckAllPermissions);
    on<SetFcmToken>(_onSetFcmToken);
    // Contacts
    on<PermissionEventCheckContactsPermission>(_onCheckContactsPermission);
    on<PermissionEventRequestContactsPermission>(_onRequestContactsPermission);
    on<PermissionEventSkipContactsPermission>(_onSkipContactsPermission);
    // Calendar
    on<PermissionEventCheckCalendarPermission>(_onCheckCalendarPermission);
    on<PermissionEventRequestCalendarPermission>(_onRequestCalendarPermission);
    on<PermissionEventSkipCalendarPermission>(_onSkipCalendarPermission);
    // Bluetooth
    on<PermissionEventCheckBluetoothPermission>(_onCheckBluetoothPermission);
    on<PermissionEventRequestBluetoothPermission>(_onRequestBluetoothPermission);
    on<PermissionEventSkipBluetoothPermission>(_onSkipBluetoothPermission);
    // Phone
    on<PermissionEventCheckPhonePermission>(_onCheckPhonePermission);
    on<PermissionEventRequestPhonePermission>(_onRequestPhonePermission);
    on<PermissionEventSkipPhonePermission>(_onSkipPhonePermission);
    // Activity Recognition
    on<PermissionEventCheckActivityRecognitionPermission>(_onCheckActivityRecognitionPermission);
    on<PermissionEventRequestActivityRecognitionPermission>(_onRequestActivityRecognitionPermission);
    on<PermissionEventSkipActivityRecognitionPermission>(_onSkipActivityRecognitionPermission);
  }
  final IPermissionRepository _repository;

  Future<void> _onSetFcmToken(
    SetFcmToken event,
    Emitter<PermissionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final fcm = NotificationService.instance.fcmToken;
    if (fcm != null) {
      final result = await _repository.setFcm(fcmToken: fcm);
      result.fold(
        (error) => emit(state.copyWith(error: error, isLoading: false)),
        (status) => emit(state.copyWith(fcmTokenSet: status)),
      );
    } else {
      add(PermissionEventRequestNotificationPermission());
    }
  }

  Future<void> _onCheckNotificationPermission(
    PermissionEventCheckNotificationPermission event,
    Emitter<PermissionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.checkNotificationPermission();
    final checkSkippedNotification = sl<PermissionCacheService>().getSync();
    AppLogger.debug('aaa sss: ${result}');
    final isSkipped =
        checkSkippedNotification?.skippedNotificationPermission == true;

    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (status) => emit(
        state.copyWith(
          // notificationPermissionStatus:
          //     checkSkippedNotification?.skippedNotificationPermission == true
          //     ? PermissionStatus.granted
          //     : status,
          // isLoading: false,
          // skippedNotificationPermissionGranted:
          //     checkSkippedNotification?.skippedNotificationPermission == true,
          // navigateRoute:
          //     checkSkippedNotification?.skippedNotificationPermission == true
          //     ? null
          //     : status == PermissionStatus.granted
          //     ? null
          //     : NotificationPermissionPageRoute(),
          notificationPermissionStatus: status,
          skippedNotificationPermissionGranted: isSkipped,
          isLoading: false,
        ),
      ),
    );
  }

  Future<void> _onCheckLocationPermission(
    PermissionEventCheckLocationPermission event,
    Emitter<PermissionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.checkLocationPermission();
    final checkSkippedLocation = sl<PermissionCacheService>().getSync();

    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (status) => emit(
        state.copyWith(
          locationPermissionStatus:
              checkSkippedLocation?.skippedLocationPermission == true
              ? PermissionStatus.granted
              : status,
          isLoading: false,
          skippedLocationPermissionGranted:
              checkSkippedLocation?.skippedLocationPermission == true,
          navigateRoute: checkSkippedLocation?.skippedLocationPermission == true
              ? null
              : status == PermissionStatus.granted
              ? null
              : null,
        ),
      ),
    );
  }

  Future<void> _onCheckCameraPermission(
    PermissionEventCheckCameraPermission event,
    Emitter<PermissionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.checkCameraPermission();
    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (status) => emit(
        state.copyWith(cameraPermissionStatus: status, isLoading: false),
      ),
    );
  }

  Future<void> _onCheckMicrophonePermission(
    PermissionEventCheckMicrophonePermission event,
    Emitter<PermissionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.checkMicrophonePermission();
    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (status) => emit(
        state.copyWith(microphonePermissionStatus: status, isLoading: false),
      ),
    );
  }

  Future<void> _onCheckStoragePermission(
    PermissionEventCheckStoragePermission event,
    Emitter<PermissionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.checkStoragePermission();
    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (status) => emit(
        state.copyWith(storagePermissionStatus: status, isLoading: false),
      ),
    );
  }

  Future<void> _onRequestNotificationPermission(
    PermissionEventRequestNotificationPermission event,
    Emitter<PermissionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    final result = await _repository.requestNotificationPermission();

    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (status) {
        emit(
          state.copyWith(
            notificationPermissionStatus: status,
            isLoading: false,
          ),
        );
      },
    );
  }

  Future<void> _onRequestLocationPermission(
    PermissionEventRequestLocationPermission event,
    Emitter<PermissionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.requestLocationPermission();
    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (status) {
        emit(
          state.copyWith(locationPermissionStatus: status, isLoading: false),
        );
      },
    );
  }

  Future<void> _onRequestCameraPermission(
    PermissionEventRequestCameraPermission event,
    Emitter<PermissionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.requestCameraPermission();
    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (status) => emit(
        state.copyWith(cameraPermissionStatus: status, isLoading: false),
      ),
    );
  }

  Future<void> _onRequestMicrophonePermission(
    PermissionEventRequestMicrophonePermission event,
    Emitter<PermissionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.requestMicrophonePermission();
    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (status) => emit(
        state.copyWith(microphonePermissionStatus: status, isLoading: false),
      ),
    );
  }

  Future<void> _onRequestStoragePermission(
    PermissionEventRequestStoragePermission event,
    Emitter<PermissionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.requestStoragePermission();
    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (status) => emit(
        state.copyWith(storagePermissionStatus: status, isLoading: false),
      ),
    );
  }

  Future<void> _onSkipNotificationPermission(
    PermissionEventSkipNotificationPermission event,
    Emitter<PermissionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    final result = await _repository.skipNotificationPermission();
    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (isGranted) => emit(
        state.copyWith(
          skippedNotificationPermissionGranted: true,
          isLoading: false,
        ),
      ),
    );
  }

  Future<void> _onSkipLocationPermission(
    PermissionEventSkipLocationPermission event,
    Emitter<PermissionState> emit,
  ) async {
    emit(PermissionState.initial());
    final result = await _repository.skipLocationPermission();
    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (isGranted) => emit(
        state.copyWith(
          skippedLocationPermissionGranted: isGranted,
          isLoading: false,
        ),
      ),
    );
  }

  Future<void> _onSkipCameraPermission(
    PermissionEventSkipCameraPermission event,
    Emitter<PermissionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.skipCameraPermission();
    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (isGranted) => emit(
        state.copyWith(
          skippedCameraPermissionGranted: isGranted,
          isLoading: false,
        ),
      ),
    );
  }

  Future<void> _onSkipMicrophonePermission(
    PermissionEventSkipMicrophonePermission event,
    Emitter<PermissionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.skipMicrophonePermission();
    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (isGranted) => emit(
        state.copyWith(
          skippedMicrophonePermissionGranted: isGranted,
          isLoading: false,
        ),
      ),
    );
  }

  Future<void> _onSkipStoragePermission(
    PermissionEventSkipStoragePermission event,
    Emitter<PermissionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.skipStoragePermission();
    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (isGranted) => emit(
        state.copyWith(
          skippedStoragePermissionGranted: isGranted,
          isLoading: false,
        ),
      ),
    );
  }

  // ── Contacts ──
  Future<void> _onCheckContactsPermission(
    PermissionEventCheckContactsPermission event,
    Emitter<PermissionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.checkContactsPermission();
    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (status) => emit(
        state.copyWith(contactsPermissionStatus: status, isLoading: false),
      ),
    );
  }

  Future<void> _onRequestContactsPermission(
    PermissionEventRequestContactsPermission event,
    Emitter<PermissionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.requestContactsPermission();
    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (status) => emit(
        state.copyWith(contactsPermissionStatus: status, isLoading: false),
      ),
    );
  }

  Future<void> _onSkipContactsPermission(
    PermissionEventSkipContactsPermission event,
    Emitter<PermissionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.skipContactsPermission();
    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (isGranted) => emit(
        state.copyWith(skippedContactsPermissionGranted: isGranted, isLoading: false),
      ),
    );
  }

  // ── Calendar ──
  Future<void> _onCheckCalendarPermission(
    PermissionEventCheckCalendarPermission event,
    Emitter<PermissionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.checkCalendarPermission();
    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (status) => emit(
        state.copyWith(calendarPermissionStatus: status, isLoading: false),
      ),
    );
  }

  Future<void> _onRequestCalendarPermission(
    PermissionEventRequestCalendarPermission event,
    Emitter<PermissionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.requestCalendarPermission();
    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (status) => emit(
        state.copyWith(calendarPermissionStatus: status, isLoading: false),
      ),
    );
  }

  Future<void> _onSkipCalendarPermission(
    PermissionEventSkipCalendarPermission event,
    Emitter<PermissionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.skipCalendarPermission();
    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (isGranted) => emit(
        state.copyWith(skippedCalendarPermissionGranted: isGranted, isLoading: false),
      ),
    );
  }

  // ── Bluetooth ──
  Future<void> _onCheckBluetoothPermission(
    PermissionEventCheckBluetoothPermission event,
    Emitter<PermissionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.checkBluetoothPermission();
    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (status) => emit(
        state.copyWith(bluetoothPermissionStatus: status, isLoading: false),
      ),
    );
  }

  Future<void> _onRequestBluetoothPermission(
    PermissionEventRequestBluetoothPermission event,
    Emitter<PermissionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.requestBluetoothPermission();
    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (status) => emit(
        state.copyWith(bluetoothPermissionStatus: status, isLoading: false),
      ),
    );
  }

  Future<void> _onSkipBluetoothPermission(
    PermissionEventSkipBluetoothPermission event,
    Emitter<PermissionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.skipBluetoothPermission();
    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (isGranted) => emit(
        state.copyWith(skippedBluetoothPermissionGranted: isGranted, isLoading: false),
      ),
    );
  }

  // ── Phone ──
  Future<void> _onCheckPhonePermission(
    PermissionEventCheckPhonePermission event,
    Emitter<PermissionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.checkPhonePermission();
    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (status) => emit(
        state.copyWith(phonePermissionStatus: status, isLoading: false),
      ),
    );
  }

  Future<void> _onRequestPhonePermission(
    PermissionEventRequestPhonePermission event,
    Emitter<PermissionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.requestPhonePermission();
    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (status) => emit(
        state.copyWith(phonePermissionStatus: status, isLoading: false),
      ),
    );
  }

  Future<void> _onSkipPhonePermission(
    PermissionEventSkipPhonePermission event,
    Emitter<PermissionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.skipPhonePermission();
    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (isGranted) => emit(
        state.copyWith(skippedPhonePermissionGranted: isGranted, isLoading: false),
      ),
    );
  }

  // ── Activity Recognition ──
  Future<void> _onCheckActivityRecognitionPermission(
    PermissionEventCheckActivityRecognitionPermission event,
    Emitter<PermissionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.checkActivityRecognitionPermission();
    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (status) => emit(
        state.copyWith(activityRecognitionPermissionStatus: status, isLoading: false),
      ),
    );
  }

  Future<void> _onRequestActivityRecognitionPermission(
    PermissionEventRequestActivityRecognitionPermission event,
    Emitter<PermissionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.requestActivityRecognitionPermission();
    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (status) => emit(
        state.copyWith(activityRecognitionPermissionStatus: status, isLoading: false),
      ),
    );
  }

  Future<void> _onSkipActivityRecognitionPermission(
    PermissionEventSkipActivityRecognitionPermission event,
    Emitter<PermissionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.skipActivityRecognitionPermission();
    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (isGranted) => emit(
        state.copyWith(
          skippedActivityRecognitionPermissionGranted: isGranted,
          isLoading: false,
        ),
      ),
    );
  }

  Future<void> _onCheckAllPermissions(
    PermissionEventCheckAllPermissions event,
    Emitter<PermissionState> emit,
  ) async {
    final notificationResult = await _repository.checkNotificationPermission();
    final locationResult = await _repository.checkLocationPermission();
    final cameraResult = await _repository.checkCameraPermission();
    final microphoneResult = await _repository.checkMicrophonePermission();
    final storageResult = await _repository.checkStoragePermission();

    final checkCache = sl<PermissionCacheService>().getSync();

    // Handle errors if any
    if (notificationResult.isLeft() ||
        locationResult.isLeft() ||
        cameraResult.isLeft() ||
        microphoneResult.isLeft() ||
        storageResult.isLeft()) {
      emit(
        state.copyWith(
          error: notificationResult.fold(
            (error) => error,
            (_) => locationResult.fold(
              (error) => error,
              (_) => cameraResult.fold(
                (error) => error,
                (_) => microphoneResult.fold(
                  (error) => error,
                  (_) => storageResult.fold((error) => error, (_) => null),
                ),
              ),
            ),
          ),
          isLoading: false,
        ),
      );
      return;
    }

    // Update state with all permission results
    emit(
      state.copyWith(
        notificationPermissionStatus: notificationResult.getOrElse(
          (_) => PermissionStatus.denied,
        ),
        locationPermissionStatus: locationResult.getOrElse(
          (_) => PermissionStatus.denied,
        ),
        cameraPermissionStatus: cameraResult.getOrElse(
          (_) => PermissionStatus.denied,
        ),
        microphonePermissionStatus: microphoneResult.getOrElse(
          (_) => PermissionStatus.denied,
        ),
        storagePermissionStatus: storageResult.getOrElse(
          (_) => PermissionStatus.denied,
        ),
        isLoading: false,
        skippedNotificationPermissionGranted:
            checkCache?.skippedNotificationPermission == true,
        skippedLocationPermissionGranted:
            checkCache?.skippedLocationPermission == true,
      ),
    );

    print(
      'skippedNotificationPermissionGranted: ${state.skippedNotificationPermissionGranted} skippedLocationPermissionGranted: ${state.skippedLocationPermissionGranted} skippedCameraPermissionGranted: ${state.skippedCameraPermissionGranted}',
    );
  }
}
