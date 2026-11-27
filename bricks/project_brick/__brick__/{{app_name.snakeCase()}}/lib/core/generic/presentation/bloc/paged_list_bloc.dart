import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart' show protected;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../error/failure.dart';
import '../../../error/typedef.dart';
import '../../domain/entities/page.dart';
import 'event_transformers.dart';
import 'paged_list_event.dart';
import 'paged_state.dart';

export '../../domain/entities/page.dart';
export 'paged_list_event.dart';
export 'paged_state.dart';

/// Fetches one page of [T] for [query]. Usually a use case.
typedef PageFetcher<T, Q> =
    ResultFuture<PageResult<T>> Function(PageRequest request, Q query);

/// Generic infinite list: first load, pull-to-refresh, load-more and
/// debounced query changes, for page-number **or** cursor APIs.
///
/// Concurrency is declared with `bloc_concurrency` transformers, never with
/// counters:
/// * start and load-more are `droppable` (a second request while one runs is
///   ignored);
/// * refresh is `restartable`; a query change is debounced and `restartable`
///   (only the latest of a burst is fetched).
///
/// A result is applied only if it still answers the list on screen: a
/// first-page result is dropped when the query changed meanwhile, and a
/// load-more result is dropped when a refresh or query change replaced the
/// list it was requested for.
///
/// A failed **refresh or load-more** sets [PagedState.failure] and keeps the
/// loaded items; a failed **query change** clears the previous query's items
/// (they belong to another query) and its paging position, so the list shows
/// the failure with nothing to load more from until a refresh or another
/// query change succeeds.
///
/// Extend it to register an injectable feature bloc, add feature events and
/// observe loads through [onLoadStarted] / [onLoadFailed]:
///
/// ```dart
/// @injectable
/// class TodoListBloc extends PagedListBloc<Todo, TodoQuery> {
///   TodoListBloc({required GetTodosUseCase getTodos})
///     : super(
///         initialQuery: const TodoQuery(),
///         fetchPage: (page, query) => getTodos(page: page, query: query),
///       );
/// }
/// ```
class PagedListBloc<T, Q> extends Bloc<PagedListEvent, PagedState<T, Q>> {
  PagedListBloc({
    required PageFetcher<T, Q> fetchPage,
    required Q initialQuery,
    this.pageSize = 20,
    Duration queryDebounce = const Duration(milliseconds: 350),
  }) : _fetchPage = fetchPage,
       super(PagedState<T, Q>(query: initialQuery)) {
    on<PagedListStarted>(_onStarted, transformer: droppable());
    on<PagedListRefreshed>(_onRefreshed, transformer: restartable());
    on<PagedListQueryChanged<Q>>(
      _onQueryChanged,
      transformer: debounceRestartable(queryDebounce),
    );
    on<PagedListNextPageRequested>(
      _onNextPageRequested,
      transformer: droppable(),
    );
  }

  /// Items requested per page.
  final int pageSize;

  final PageFetcher<T, Q> _fetchPage;

  /// Called when [event] starts a load (analytics, logging). No-op by default.
  @protected
  void onLoadStarted({required PagedListEvent event}) {}

  /// Called when a load ended with [failure] (analytics, logging). No-op by
  /// default.
  @protected
  void onLoadFailed({required Failure failure}) {}

  Future<void> _onStarted(
    PagedListStarted event,
    Emitter<PagedState<T, Q>> emit,
  ) async {
    if (!state.isInitial) {
      return;
    }
    onLoadStarted(event: event);
    await _loadFirstPage(emit, query: state.query);
  }

  Future<void> _onRefreshed(
    PagedListRefreshed event,
    Emitter<PagedState<T, Q>> emit,
  ) async {
    onLoadStarted(event: event);
    try {
      await _loadFirstPage(emit, query: state.query);
    } finally {
      final completion = event.completion;
      if (completion != null && !completion.isCompleted) {
        completion.complete();
      }
    }
  }

  Future<void> _onQueryChanged(
    PagedListQueryChanged<Q> event,
    Emitter<PagedState<T, Q>> emit,
  ) async {
    if (event.query == state.query && state.hasLoaded) {
      return;
    }
    onLoadStarted(event: event);
    await _loadFirstPage(emit, query: event.query);
  }

  Future<void> _onNextPageRequested(
    PagedListNextPageRequested event,
    Emitter<PagedState<T, Q>> emit,
  ) async {
    final request = state.nextPage;
    if (!state.canLoadMore || request == null) {
      return;
    }
    final query = state.query;
    onLoadStarted(event: event);
    emit(state.copyWith(status: PagedStatus.loadingMore, failure: () => null));

    final result = await _fetchPage(request, query);

    // A refresh or query change replaced the list this page was requested for.
    if (emit.isDone ||
        state.status != PagedStatus.loadingMore ||
        state.query != query) {
      return;
    }
    emit(
      result.fold(
        (failure) {
          onLoadFailed(failure: failure);
          return state.copyWith(
            status: PagedStatus.idle,
            failure: () => failure,
          );
        },
        (page) => state.copyWith(
          items: [...state.items, ...page.items],
          hasMore: page.hasMore,
          nextPage: () => request.next(page),
          status: PagedStatus.idle,
        ),
      ),
    );
  }

  Future<void> _loadFirstPage(
    Emitter<PagedState<T, Q>> emit, {
    required Q query,
  }) async {
    // Items and paging position of another query must never survive into
    // this one: on a failure nothing would replace them, and load-more would
    // then request page 2 of the old query with the new query's filter.
    final queryChanged = query != state.query;
    emit(
      queryChanged
          ? state.copyWith(
              query: query,
              items: const [],
              hasMore: false,
              nextPage: () => null,
              hasLoaded: false,
              status: PagedStatus.loadingFirst,
              failure: () => null,
            )
          : state.copyWith(
              status: state.items.isEmpty
                  ? PagedStatus.loadingFirst
                  : PagedStatus.refreshing,
              failure: () => null,
            ),
    );

    final request = PageRequest.first(limit: pageSize);
    final result = await _fetchPage(request, query);

    // Restarted by a newer event, or another query replaced this one.
    if (emit.isDone || state.query != query) {
      return;
    }
    emit(
      result.fold(
        (failure) {
          onLoadFailed(failure: failure);
          return state.copyWith(
            status: PagedStatus.idle,
            failure: () => failure,
          );
        },
        (page) => state.copyWith(
          items: page.items,
          hasMore: page.hasMore,
          nextPage: () => request.next(page),
          status: PagedStatus.idle,
          hasLoaded: true,
        ),
      ),
    );
  }
}
