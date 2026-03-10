part of '../base_crud_bloc.dart';

mixin SelectableCrudMixin<Entity> on BaseCrudBloc<Entity> {
  void registerSelectHandlers() {
    on<SelectEntityEvent<Entity>>(_onSelectEntityEvent);
    on<SelectMultipleEntityEvent<Entity>>(_onSelectMultipleEntityEvent);
    on<MultiSelectEntityEvent<Entity>>(_onMultiSelectEntityEvent);
    on<SelectInGroupEntityEvent<Entity>>(_onSelectInGroupEntityEvent);
    on<SelectInGroupMultipleEntityEvent<Entity>>(
      _onSelectInGroupMultipleEntityEvent,
    );
  }

  /// Handles setting a single entity to a specific group key (Key: Value)
  Future<void> _onSelectInGroupEntityEvent(
    SelectInGroupEntityEvent<Entity> event,
    Emitter<BaseCrudState<Entity>> emit,
  ) async {
    // 1. Copy the existing map
    final currentGroups = Map<String, dynamic>.from(state.groupSelected ?? {});

    // 2. Directly assign the entity to the key (Overwrites previous selection for this key)
    currentGroups[event.key] = event.entities;

    // 3. Emit the updated state
    emit(
      state.copyWith(
        groupSelected: currentGroups,
        error: null,
        isLoading: false,
      ),
    );
  }

  /// Handles replacing an entire group's selection with a new list
  Future<void> _onSelectInGroupMultipleEntityEvent(
    SelectInGroupMultipleEntityEvent<Entity> event,
    Emitter<BaseCrudState<Entity>> emit,
  ) async {
    final currentGroups = Map<String, dynamic>.from(state.groupSelected ?? {});

    currentGroups[event.key] = event.entities;

    emit(
      state.copyWith(
        groupSelected: currentGroups,
        error: null,
        isLoading: false,
      ),
    );
  }

  Future<void> _onSelectEntityEvent(
    SelectEntityEvent<Entity> event,
    Emitter<BaseCrudState<Entity>> emit,
  ) async {
    emit(
      state.copyWith(
        selectedEntity: event.entity,
        error: null,
        isLoading: false,
      ),
    );
  }

  Future<void> _onSelectMultipleEntityEvent(
    SelectMultipleEntityEvent<Entity> event,
    Emitter<BaseCrudState<Entity>> emit,
  ) async {
    emit(
      state.copyWith(
        selectedEntities: event.entities,
        error: null,
        isLoading: false,
      ),
    );
  }

  Future<void> _onMultiSelectEntityEvent(
    MultiSelectEntityEvent<Entity> event,
    Emitter<BaseCrudState<Entity>> emit,
  ) async {
    final bool isAlreadySelected = state.selectedEntities.contains(
      event.entity,
    );

    final newList = isAlreadySelected
        ? state.selectedEntities.where((e) => e != event.entity).toList()
        : [...state.selectedEntities, event.entity];

    emit(
      state.copyWith(selectedEntities: newList, error: null, isLoading: false),
    );
  }
}

class SelectEntityEvent<Entity> extends BaseCrudEvent<Entity> {
  const SelectEntityEvent({required this.entity});
  final Entity entity;
  @override
  List<Object?> get props => [entity];
}

class MultiSelectEntityEvent<Entity> extends BaseCrudEvent<Entity> {
  const MultiSelectEntityEvent({required this.entity});
  final Entity entity;
  @override
  List<Object?> get props => [entity];
}

class SelectMultipleEntityEvent<Entity> extends BaseCrudEvent<Entity> {
  const SelectMultipleEntityEvent({required this.entities});
  final List<Entity> entities;
  @override
  List<Object?> get props => [entities];
}

class SelectInGroupMultipleEntityEvent<Entity> extends BaseCrudEvent<Entity> {
  const SelectInGroupMultipleEntityEvent({
    required this.entities,
    required this.key,
  });
  final List<Entity> entities;
  final String key;
  @override
  List<Object?> get props => [entities];
}

class SelectInGroupEntityEvent<Entity> extends BaseCrudEvent<Entity> {
  const SelectInGroupEntityEvent({required this.entities, required this.key});
  final Entity entities;
  final String key;
  @override
  List<Object?> get props => [entities];
}
