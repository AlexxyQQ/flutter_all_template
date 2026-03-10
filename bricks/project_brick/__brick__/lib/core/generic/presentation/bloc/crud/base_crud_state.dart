part of 'base_crud_bloc.dart';

@freezed
abstract class BaseCrudState<Response> with _$BaseCrudState<Response> {
  const BaseCrudState._();

  const factory BaseCrudState({
    @Default(false) bool isLoading,
    @Default([]) List<Response> entities,
    Response? selectedEntity,
    @Default([]) List<Response> selectedEntities,
    @Default([]) List<Response> filteredEntities,
    Failure? error,
    @Default('') String searchQuery,
    String? successMessage,
    Object? filters,
    // Pagination States
    @Default(true) bool isInitial,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasLoadedNext,
    @Default(false) bool isLoadingNext,
    @Default(false) bool hasReachedNextEnd,
    @Default(1) int currentPage,
    @Default(10) int nextPageSize,
    @Default(10) int previousPageSize,
    String? nextToken,
    String? previousToken,
    int? nextPage,
    int? totalPages,
    // Groups
    Map<String, dynamic>? groupSelected,
    Map<String, List<Response>>? groupedEntities,
    Map<String, List<Response>>? groupedFilteredEntities,
  }) = _BaseCrudState;

  factory BaseCrudState.initial() => BaseCrudState<Response>();

  bool get isSearching => searchQuery.isNotEmpty;
}
