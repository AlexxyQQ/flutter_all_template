part of '../base_crud_bloc.dart';

mixin UpdateCrudMixin<Entity> on BaseCrudBloc<Entity> {
  // Register Update Handlers
  void registerUpdateHandlers() {
    on<UpdateEntityEvent<Entity>>(_onUpdateEntity);
  }

  // Abstract method to update an entity
  ResultFuture<Entity?> updateEntity(
    dynamic id,
    Map<String, dynamic> updatedData,
  );

  Future<void> _onUpdateEntity(
    UpdateEntityEvent<Entity> event,
    Emitter<BaseCrudState<Entity>> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, successMessage: null));
    final result = await updateEntity(event.id, event.entity);
    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (entity) {
        if (entity != null) {
          final updatedList = state.entities
              .map((e) => getEntityId(e) == getEntityId(entity) ? entity : e)
              .toList();
          emit(
            state.copyWith(
              isLoading: false,
              successMessage: LocaleKeys.common_success_updatedSuccessfully.tr(
                namedArgs: {'name': name},
              ),
              entities: updatedList,
              filteredEntities: updatedList,
            ),
          );
        } else {
          emit(
            state.copyWith(
              isLoading: false,
              successMessage: LocaleKeys.common_success_updatedSuccessfully.tr(
                namedArgs: {'name': name},
              ),
            ),
          );
        }
      },
    );
  }
}

class UpdateEntityEvent<Entity> extends BaseCrudEvent<Entity> {
  const UpdateEntityEvent({required this.entity, required this.id});
  final dynamic id;
  final Map<String, dynamic> entity;
  @override
  List<Object?> get props => [id, entity];
}
