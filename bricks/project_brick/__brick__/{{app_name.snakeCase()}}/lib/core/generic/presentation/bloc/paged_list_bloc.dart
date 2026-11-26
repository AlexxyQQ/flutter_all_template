import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/constants/type_defs/typedef.dart';
import '../../domain/entities/page.dart';
import 'event_transformers.dart';
import 'paged_list_event.dart';
import 'paged_state.dart';

export '../../domain/entities/page.dart';
export 'paged_list_event.dart';
export 'paged_state.dart';

/// Fetches one page of [T] for [query]. Usually a repository method.
typedef PageFetcher<T, Q> =
    ResultFuture<PageResult<T>> Function(PageRequest request, Q query);

/// Generic infinite list: first load, pull-to-refresh, load-more and
/// debounced query changes, for page-number **or** cursor APIs.
///
/// Guarantees:
/// * only one next-page request at a time (`droppable`);
/// * query changes are debounced and only the latest one is applied
///   (`restartable`); a refresh or query change also discards a load-more
///   that was still in flight, so stale pages are never appended;
/// * the cursor/page of the previous result is passed to the next request;
/// * errors set [PagedState.failure] and never clear loaded items.
///
/// Use directly, or extend it to register as an injectable feature bloc and
/// add feature events:
///
/// ```dart
/// @injectable
/// class TodoListBloc extends PagedListBloc<Todo, TodoQuery> {
///   TodoListBloc({required ITodoRepository repository})
///     : super(
///         initialQuery: const TodoQuery(),
///         fetchPage: (page, query) =>
///             repository.getTodos(page: page, query: query),
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

  final PageFetcher<T, Q> _fetchPage;

  /// Items requested per page.
  final int pageSize;

  // Incremented by every first-page load; results of loads started under an
  // older generation are discarded.
  int _generation = 0;

  Future<void> _onStarted(
    PagedListStarted event,
    Emitter<PagedState<T, Q>> emit,
  ) async {
    if (!state.isInitial) {
      return;
    }
    await _loadFirstPage(emit, query: state.query);
  }

  Future<void> _onRefreshed(
    PagedListRefreshed event,
    Emitter<PagedState<T, Q>> emit,
  ) => _loadFirstPage(emit, query: state.query);

  Future<void> _onQueryChanged(
    PagedListQueryChanged<Q> event,
    Emitter<PagedState<T, Q>> emit,
  ) async {
    if (event.query == state.query && state.hasLoaded) {
      return;
    }
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
    final generation = _generation;
    emit(state.copyWith(status: PagedStatus.loadingMore, failure: () => null));

    final result = await _fetchPage(request, state.query);
    if (generation != _generation) {
      return; // Superseded by a refresh/query change.
    }
    emit(
      result.fold(
        (failure) =>
            state.copyWith(status: PagedStatus.idle, failure: () => failure),
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
    final generation = ++_generation;
    emit(
      state.copyWith(
        query: query,
        status: state.items.isEmpty
            ? PagedStatus.loadingFirst
            : PagedStatus.refreshing,
        failure: () => null,
      ),
    );

    final request = PageRequest.first(limit: pageSize);
    final result = await _fetchPage(request, query);
    if (generation != _generation) {
      return;
    }
    emit(
      result.fold(
        (failure) =>
            state.copyWith(status: PagedStatus.idle, failure: () => failure),
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
