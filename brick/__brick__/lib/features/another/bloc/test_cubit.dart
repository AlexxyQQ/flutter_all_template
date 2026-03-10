// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/common/data/models/helpers/model_conversion_helper.dart';
import '../../../core/common/features/permission/domain/repository/permission_repository.dart';
import 'test_state.dart';

@injectable
class TestCubit extends Cubit<TestState> {
  TestCubit(this._permissionRepository) : super(const TestState());

  final IPermissionRepository _permissionRepository;

  Future<void> sendUserLocationToServer() async {
    emit(state.copyWith(isLoading: true, isSuccess: false));

    final hasPermission = await _permissionRepository
        .requestLocationPermission()
        .rightOrNull;
    if (hasPermission != PermissionStatus.granted) {
      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: false,
          hasLocationPermission: false,
        ),
      );
      return;
    } else {
      // Simulate sending location to server
      await Future.delayed(const Duration(seconds: 2));
    }

    emit(
      state.copyWith(
        isLoading: false,
        isSuccess: true,
        hasLocationPermission: true,
      ),
    );
  }
}
