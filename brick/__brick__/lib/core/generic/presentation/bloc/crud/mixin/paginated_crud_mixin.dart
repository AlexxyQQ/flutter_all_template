part of '../base_crud_bloc.dart';

mixin PaginatedCrudMixin<Entity, FilterEntity> on BaseCrudBloc<Entity> {
  void registerPaginationHandlers() {
    on<LoadNextPaginationEvent<Entity>>(_onLoadNextPaginationEvent);
    on<RefreshPaginationEvent<Entity>>(_onRefreshPaginationEvent);
    on<LoadInitialPaginationEvent<Entity>>(_onLoadInitial);
  }

  Future<void> _onRefreshPaginationEvent(
    RefreshPaginationEvent<Entity> event,
    Emitter<BaseCrudState<Entity>> emit,
  ) async {
    emit(
      BaseCrudState<Entity>().copyWith(
        filters: state.filters,
        nextPageSize: state.nextPageSize,
        previousPageSize: state.previousPageSize,
      ),
    );
    add(LoadInitialPaginationEvent(limit: state.nextPageSize));
  }

  Future<void> _onLoadInitial(
    LoadInitialPaginationEvent<Entity> event,
    Emitter<BaseCrudState<Entity>> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        isInitial: true,
        error: null,
        entities: [],
        currentPage: 1,
        nextToken: null,
        previousToken: null,
        nextPage: null,
        totalPages: null,
        hasReachedNextEnd: false,
      ),
    );

    final result = await paginatedRead(
      page: 1,
      limit: event.limit ?? state.nextPageSize,
      filters: state.filters as FilterEntity,
    );

    result.fold(
      (error) => emit(state.copyWith(isLoading: false, error: error)),
      (response) {
        final nextPage = _calculateNextPage(response, 1);
        final totalPages = _calculateTotalPages(
          response,
          event.limit ?? state.nextPageSize,
        );

        emit(
          state.copyWith(
            isLoading: false,
            entities: response.entities,
            nextToken: response.nextToken,
            previousToken: response.previousToken,
            nextPage: nextPage,
            totalPages: totalPages,
            hasReachedNextEnd: response.hasReachedEnd,
            hasLoadedNext: false,
            isInitial: false,
          ),
        );
      },
    );
  }

  Future<void> _onLoadNextPaginationEvent(
    LoadNextPaginationEvent<Entity> event,
    Emitter<BaseCrudState<Entity>> emit,
  ) async {
    if (state.hasReachedNextEnd || state.isLoadingNext) {
      return;
    }

    emit(state.copyWith(isLoadingNext: true, error: null, isInitial: false));

    final result = await paginatedRead(
      page: state.currentPage + 1,
      limit: state.nextPageSize,
      filters: state.filters as FilterEntity,
    );

    result.fold(
      (error) => emit(
        state.copyWith(isLoadingNext: false, error: error, isInitial: false),
      ),
      (response) {
        final newCurrentPage = state.currentPage + 1;
        final nextPage = _calculateNextPage(response, newCurrentPage);
        final totalPages = _calculateTotalPages(response, state.nextPageSize);

        emit(
          state.copyWith(
            isLoadingNext: false,
            entities: [...state.entities, ...response.entities],
            currentPage: newCurrentPage,
            nextToken: response.nextToken,
            previousToken: response.previousToken,
            nextPage: nextPage,
            totalPages: totalPages,
            hasReachedNextEnd: response.hasReachedEnd,
            hasLoadedNext: true,
            isInitial: false,
          ),
        );
      },
    );
  }

  ResultFuture<PaginationResponse<Entity>> paginatedRead({
    required FilterEntity filters,
    int? page,
    int? limit,
    String? nextToken,
  });

  ResultFuture<PaginationResponse<Entity>> applyPaginatedRead({
    required FilterEntity filters,
    int? page,
    int? limit,
    String? nextToken,
  }) {
    return paginatedRead(filters: filters);
  }

  int? _calculateNextPage(
    PaginationResponse<Entity> response,
    int currentPage,
  ) {
    if (response.nextPage != null) {
      return response.nextPage;
    }

    if (response.hasReachedEnd) {
      return null;
    }

    return currentPage + 1;
  }

  int? _calculateTotalPages(PaginationResponse<Entity> response, int pageSize) {
    if (response.totalPages != null) {
      return response.totalPages;
    }

    if (response.totalCount != null && pageSize > 0) {
      return (response.totalCount! / pageSize).ceil();
    }

    return null;
  }
}

class LoadNextPaginationEvent<Entity> extends BaseCrudEvent<Entity> {
  const LoadNextPaginationEvent();
  @override
  List<Object?> get props => [];
}

class RefreshPaginationEvent<Entity> extends BaseCrudEvent<Entity> {
  const RefreshPaginationEvent();
  @override
  List<Object?> get props => [];
}

// Loads the first data
class LoadInitialPaginationEvent<Entity> extends BaseCrudEvent<Entity> {
  const LoadInitialPaginationEvent({this.limit});
  final int? limit;

  @override
  List<Object?> get props => [limit];
}

// Response Model
class PaginationResponse<Entity> {
  const PaginationResponse({
    required this.entities,
    this.nextToken,
    this.previousToken,
    this.nextPage,
    this.totalPages,
    this.hasReachedEnd = false,
    this.hasReachedStart = false,
    this.totalCount,
  });

  final List<Entity> entities;

  final String? nextToken;

  final String? previousToken;

  final int? nextPage;

  final int? totalPages;

  final bool hasReachedEnd;

  final bool hasReachedStart;

  final int? totalCount;
}
