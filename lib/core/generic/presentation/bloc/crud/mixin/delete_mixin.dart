part of '../base_crud_bloc.dart';

mixin DeleteCrudMixin<Entity> on BaseCrudBloc<Entity> {
  // Register Delete Handlers
  void registerDeleteHandlers() {
    on<DeleteEntityEvent<Entity>>(_onDeleteEntity);
  }

  // Abstract method to delete an entity
  ResultFuture<bool> deleteEntity({dynamic id});

  Future<void> _onDeleteEntity(
    DeleteEntityEvent<Entity> event,
    Emitter<BaseCrudState<Entity>> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, successMessage: null));
    final result = await deleteEntity(id: event.id);
    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (_) {
        final updatedList = state.entities
            .where((e) => getEntityId(e) != event.id)
            .toList();
        emit(
          state.copyWith(
            isLoading: false,
            successMessage: LocaleKeys.common_success_deletedSuccessfully.tr(
              namedArgs: {'name': name},
            ),
            entities: updatedList,
            filteredEntities: updatedList,
          ),
        );
      },
    );
  }
}

class DeleteEntityEvent<Entity> extends BaseCrudEvent<Entity> {
  const DeleteEntityEvent({this.id});
  final dynamic id;
  @override
  List<Object?> get props => [id];
}
