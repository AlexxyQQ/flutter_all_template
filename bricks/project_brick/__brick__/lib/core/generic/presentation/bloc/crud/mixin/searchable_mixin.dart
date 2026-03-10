part of '../base_crud_bloc.dart';

mixin SearchableCrudMixin<Entity> on BaseCrudBloc<Entity> {
  void registerSearchHandlers() {
    on<LocalSearchEvent<Entity>>(_onLocalSearchEvent);
    on<SearchEvent<Entity>>(_onSearchEvent);
  }

  bool isLocalSearchMatch(Entity entity, String query);

  ResultFuture<List<Entity>> search({String? query});

  List<Entity> applyLocalSearch(List<Entity> entities) {
    if (state.searchQuery.isEmpty) {
      return entities;
    }
    return entities
        .where((entity) => isLocalSearchMatch(entity, state.searchQuery))
        .toList();
  }

  Future<void> _onLocalSearchEvent(
    LocalSearchEvent<Entity> event,
    Emitter<BaseCrudState<Entity>> emit,
  ) async {
    final query = event.query.trim();

    // Calculate the filter BEFORE emitting
    // Note: We cannot use 'applyLocalSearch' directly if it relies on 'state.searchQuery'
    // being already updated. We reproduce the logic slightly here or pass the query.
    final filteredList = state.entities
        .where((entity) => isLocalSearchMatch(entity, query))
        .toList();

    // Single emission with both values
    emit(state.copyWith(searchQuery: query, filteredEntities: filteredList));
  }

  Future<void> _onSearchEvent(
    SearchEvent<Entity> event,
    Emitter<BaseCrudState<Entity>> emit,
  ) async {
    // final query = event.query.trim();

    // emit(state.copyWith(searchQuery: query));

    // final filteredList = applyLocalSearch(state.entities);

    // emit(state.copyWith(filteredEntities: filteredList));

    emit(state.copyWith(isLoading: true, error: null));

    final result = await search(query: event.query);

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, error: failure, entities: [])),
      (data) {
        emit(state.copyWith(isLoading: false, entities: data));
      },
    );
  }
}

class LocalSearchEvent<Entity> extends BaseCrudEvent<Entity> {
  const LocalSearchEvent({required this.query});
  final String query;
  @override
  List<Object?> get props => [query];
}

class SearchEvent<Entity> extends BaseCrudEvent<Entity> {
  const SearchEvent({this.query});
  final String? query;
  @override
  List<Object?> get props => [query];
}
