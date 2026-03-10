part of '../base_crud_bloc.dart';

mixin FilterableCrudMixin<Entity, FilterEntity> on BaseCrudBloc<Entity> {
  void registerFilterableHandlers() {
    on<SetFilterEvent<Entity, FilterEntity>>(_onSetFilter);
    on<UpdateFilterEvent<Entity, FilterEntity>>(_onUpdateFilter);
  }

  bool shouldClear() {
    return false;
  }

  Future<void> _onSetFilter(
    SetFilterEvent<Entity, FilterEntity> event,
    Emitter<BaseCrudState<Entity>> emit,
  ) async {
    await _applyAndFetch(emit, event.filters);
  }

  Future<void> _onUpdateFilter(
    UpdateFilterEvent<Entity, FilterEntity> event,
    Emitter<BaseCrudState<Entity>> emit,
  ) async {
    final currentFilter = state.filters as FilterEntity;

    final newFilter = event.update(currentFilter);

    await _applyAndFetch(emit, newFilter);
  }

  Future<void> _applyAndFetch(
    Emitter<BaseCrudState<Entity>> emit,
    FilterEntity newFilters,
  ) async {
    if (state.filters == newFilters) {
      return;
    }

    emit(
      state.copyWith(
        filters: newFilters,
        isLoading: true,
        filteredEntities: shouldClear() ? [] : state.filteredEntities,
      ),
    );
    final data = await applyFilter(filters: newFilters);

    return data.fold(
      (l) {
        emit(state.copyWith(error: l, isLoading: false));
      },
      (r) {
        emit(
          state.copyWith(error: null, isLoading: false, filteredEntities: r),
        );
      },
    );
  }

  ResultFuture<List<Entity>> filteredRead({required FilterEntity filters});

  ResultFuture<List<Entity>> applyFilter({required FilterEntity filters}) {
    return filteredRead(filters: filters);
  }
}

class SetFilterEvent<Entity, FilterEntity> extends BaseCrudEvent<Entity> {
  const SetFilterEvent({required this.filters});
  final FilterEntity filters;

  @override
  List<Object?> get props => [filters];
}

class UpdateFilterEvent<Entity, FilterEntity> extends BaseCrudEvent<Entity> {
  const UpdateFilterEvent(this.update);

  final FilterEntity Function(FilterEntity currentFilter) update;

  @override
  List<Object?> get props => [update];
}

class LoadMoreEvent<Entity, FilterEntity> extends BaseCrudEvent<Entity> {
  const LoadMoreEvent();
  @override
  List<Object?> get props => [];
}
