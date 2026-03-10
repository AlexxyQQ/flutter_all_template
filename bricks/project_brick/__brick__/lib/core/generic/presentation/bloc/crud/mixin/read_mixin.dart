part of '../base_crud_bloc.dart';

mixin ReadCrudMixin<Entity> on BaseCrudBloc<Entity> {
  // Register Read Handlers
  void registerReadHandlers() {
    on<ReadEntityEvent<Entity>>(_onReadEntity);
    on<ReadMultipleEntityEvent<Entity>>(_onReadMultipleEntity);
  }

  // Abstract method to read an entity
  ResultFuture<Entity> readEntity({dynamic id});
  ResultFuture<List<Entity>> readMultipleEntity();

  Future<void> _onReadEntity(
    ReadEntityEvent<Entity> event,
    Emitter<BaseCrudState<Entity>> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, successMessage: null));
    final result = await readEntity(id: event.id);
    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (entity) => emit(
        state.copyWith(
          isLoading: false,
          entities: [entity],
          filteredEntities: [entity],
          selectedEntity: entity,
        ),
      ),
    );
  }

  Future<void> _onReadMultipleEntity(
    ReadMultipleEntityEvent<Entity> event,
    Emitter<BaseCrudState<Entity>> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, successMessage: null));
    final result = await readMultipleEntity();
    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (entities) {
        emit(
          state.copyWith(
            isLoading: false,
            error: null,
            entities: entities,
            filteredEntities: entities,
          ),
        );
      },
    );
  }
}

class ReadEntityEvent<Entity> extends BaseCrudEvent<Entity> {
  const ReadEntityEvent({this.id});
  final dynamic id;
  @override
  List<Object?> get props => [id];
}

class ReadMultipleEntityEvent<Entity> extends BaseCrudEvent<Entity> {
  const ReadMultipleEntityEvent();
  @override
  List<Object?> get props => [];
}
