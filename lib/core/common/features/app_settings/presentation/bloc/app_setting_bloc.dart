import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../../../config/constants/type_defs/typedef.dart';
import '../../../../../generic/presentation/bloc/crud/crud_exports.dart';
import '../../../../data/models/helpers/model_conversion_helper.dart';
import '../../data/models/app_setting.dart';
import '../../domain/repositories/app_setting_repository.dart';

@injectable
class AppSettingBloc extends BaseCrudBloc<AppSetting>
    with ReadCrudMixin<AppSetting>, UpdateCrudMixin<AppSetting> {
  AppSettingBloc({required IAppSettingRepository repository})
    : _repository = repository,
      super(name: 'AppSetting') {
    registerReadHandlers();
    registerUpdateHandlers();
    on<OnLogOutEvent>(_onLogOut);
    on<UpdateSettingEvent>(_updateSetting);
  }

  final IAppSettingRepository _repository;

  @override
  String get name => 'AppSetting';

  @override
  int getEntityId(AppSetting entity) {
    return entity.hashCode;
  }

  @override
  ResultFuture<AppSetting> readEntity({id}) {
    return _repository.getSetting();
  }

  @override
  ResultFuture<AppSetting?> updateEntity(id, Map<String, dynamic> updatedData) {
    return _repository.updateSetting(
      data: (data) => AppSetting.fromJson(updatedData),
    );
  }

  @override
  ResultFuture<List<AppSetting>> readMultipleEntity() {
    // TODO: implement readMultipleEntity
    throw UnimplementedError();
  }

  // Custom Events

  void _updateSetting(
    UpdateSettingEvent event,
    Emitter<BaseCrudState<AppSetting>> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, successMessage: null));
    final AppSetting currentSetting =
        await _repository.getSetting().rightOrNull ?? const AppSetting();

    final AppSetting newModel = event.data(currentSetting);

    final update = await _repository.updateSetting(data: (data) => newModel);

    return update.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }

  void _onLogOut(
    OnLogOutEvent event,
    Emitter<BaseCrudState<AppSetting>> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, successMessage: null));
    final result = await _repository.logout();
    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (entity) => emit(
        state.copyWith(
          isLoading: false,
          successMessage: LocaleKeys.common_success_loggedOut,
        ),
      ),
    );
  }
}

class OnLogOutEvent extends BaseCrudEvent<AppSetting> {}

class UpdateSettingEvent extends BaseCrudEvent<AppSetting> {
  const UpdateSettingEvent({required this.data});
  final Function(AppSetting currentData) data;
}
