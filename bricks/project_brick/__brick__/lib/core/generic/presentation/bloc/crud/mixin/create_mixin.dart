part of '../base_crud_bloc.dart';

mixin CreateCrudMixin<Entity> on BaseCrudBloc<Entity> {
  // Register Create Handlers
  void registerCreateHandlers() {
    on<CreateEntityEvent<Entity>>(_onCreateEntity);
    on<CreateMultipleEntityEvent<Entity>>(_onCreateMultipleEntity);
  }

  // Abstract method to create an entity
  ResultFuture<Entity?> createEntity(Map<String, dynamic> entity);
  ResultFuture<List<Entity>?> createMultipleEntity(
    List<Map<String, dynamic>> entities,
  );

  Future<void> _onCreateEntity(
    CreateEntityEvent<Entity> event,
    Emitter<BaseCrudState<Entity>> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, successMessage: null));
    final result = await createEntity(event.entity);
    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (entity) {
        if (entity != null) {
          final updatedList = [...state.entities, entity];
          emit(
            state.copyWith(
              isLoading: false,
              entities: updatedList,
              filteredEntities: updatedList,
              successMessage: LocaleKeys.common_success_createdSuccessfully.tr(
                namedArgs: {'name': name},
              ),
            ),
          );
        } else {
          emit(
            state.copyWith(
              isLoading: false,
              successMessage: LocaleKeys.common_success_createdSuccessfully.tr(
                namedArgs: {'name': name},
              ),
            ),
          );
        }
      },
    );
  }

  Future<void> _onCreateMultipleEntity(
    CreateMultipleEntityEvent<Entity> event,
    Emitter<BaseCrudState<Entity>> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, successMessage: null));
    final result = await createMultipleEntity(event.entities);
    result.fold(
      (error) => emit(state.copyWith(error: error, isLoading: false)),
      (entities) {
        if (entities != null) {
          final updatedList = [...state.entities, ...entities];
          emit(
            state.copyWith(
              isLoading: false,
              successMessage: LocaleKeys.common_success_createdSuccessfully.tr(
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
              successMessage: LocaleKeys.common_success_createdSuccessfully.tr(
                namedArgs: {'name': name},
              ),
            ),
          );
        }
      },
    );
  }
}

class CreateEntityEvent<Entity> extends BaseCrudEvent<Entity> {
  const CreateEntityEvent({required this.entity});
  final Map<String, dynamic> entity;
  @override
  List<Object?> get props => [entity];
}

class CreateMultipleEntityEvent<Entity> extends BaseCrudEvent<Entity> {
  const CreateMultipleEntityEvent({required this.entities});
  final List<Map<String, dynamic>> entities;
  @override
  List<Object?> get props => [entities];
}
