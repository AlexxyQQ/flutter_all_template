import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart' show protected;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../config/constants/type_defs/typedef.dart';
import '../../../common/domain/entities/failure.dart';
import '../../data/async_lock.dart';
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
/// * a failed **refresh or load-more** sets [PagedState.failure] and keeps the
///   loaded items; a failed **query change** clears the previous query's
///   items (they belong to another query) and its paging position, so the
///   list shows the failure with nothing to load more from until a refresh
///   or another query change succeeds;
/// * loads and subclass mutations (see [serialized]) never interleave their
///   state updates: a mutation runs to completion before a load result is
///   applied, and a load that was fetched while a mutation ran is fetched
///   again, so a stale snapshot never overwrites a mutation.
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

  final AsyncLock _serial = AsyncLock();

  // Incremented when a [serialized] mutation starts and when it ends.
  int _mutationEpoch = 0;

  /// Runs a mutation [body] after every earlier mutation finished and after
  /// any load result that is being applied, and before any later one.
  /// Subclasses wrap their mutation handlers (create / toggle / delete etc.)
  /// in it. Loads fetch concurrently (a slow stale query never blocks a newer
  /// one) but apply their result under the same lock and re-fetch if a
  /// mutation ran meanwhile. Not re-entrant.
  @protected
  Future<R> serialized<R>(FutureOr<R> Function() body) =>
      _serial.synchronized(() async {
        _mutationEpoch++;
        try {
          return await body();
        } finally {
          _mutationEpoch++;
        }
      });

  /// Fetches [request] for [query] and calls [apply] with the result under
  /// the mutation lock. Returns without applying if [generation] was
  /// superseded; re-fetches if a mutation ran since the fetch started.
  Future<void> _fetchAndApply(
    PageRequest request,
    Q query,
    int generation,
    void Function(Either<Failure, PageResult<T>> result) apply,
  ) async {
    while (generation == _generation) {
      final epoch = _mutationEpoch;
      final result = await _fetchPage(request, query);
      if (generation != _generation) {
        return;
      }
      final applied = await _serial.synchronized(() {
        if (generation != _generation) {
          return true; // Superseded while queued: drop it.
        }
        if (epoch != _mutationEpoch) {
          return false; // The result may predate a mutation.
        }
        apply(result);
        return true;
      });
      if (applied) {
        return;
      }
    }
  }

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

    await _fetchAndApply(
      request,
      state.query,
      generation,
      (result) => emit(
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
      ),
    );
  }

  Future<void> _loadFirstPage(
    Emitter<PagedState<T, Q>> emit, {
    required Q query,
  }) async {
    final generation = ++_generation;
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
    await _fetchAndApply(
      request,
      query,
      generation,
      (result) => emit(
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
      ),
    );
  }
}
