import 'package:equatable/equatable.dart';

import '../../../common/domain/entities/failure.dart';
import '../../domain/entities/page.dart';

/// What a paged list is currently doing. At most one load runs at a time
/// from the UI's point of view.
enum PagedStatus {
  /// Nothing requested yet.
  initial,

  /// Loading the first page (first load, retry with no items, query change).
  loadingFirst,

  /// Reloading the first page while the current items stay visible.
  refreshing,

  /// Loading the next page.
  loadingMore,

  /// No load in progress.
  idle,
}

/// State of a paginated list of [T] filtered by a query of type [Q].
final class PagedState<T, Q> extends Equatable {
  const PagedState({
    required this.query,
    this.items = const [],
    this.status = PagedStatus.initial,
    this.hasMore = true,
    this.nextPage,
    this.failure,
    this.hasLoaded = false,
  });

  final List<T> items;
  final Q query;
  final PagedStatus status;

  /// Whether another page can be loaded.
  final bool hasMore;

  /// The request for the next page (page number **and** cursor), `null` until
  /// the first page has loaded.
  final PageRequest? nextPage;

  /// The most recent error. Never clears [items]: show it as a banner or
  /// snackbar when [items] is non-empty, full screen otherwise.
  /// `failure.message` is a localization key — translate it in the widget.
  final Failure? failure;

  /// Whether at least one first page loaded successfully (distinguishes
  /// "empty result" from "not loaded yet").
  final bool hasLoaded;

  bool get isInitial => status == PagedStatus.initial;
  bool get isLoadingFirst => status == PagedStatus.loadingFirst;
  bool get isRefreshing => status == PagedStatus.refreshing;
  bool get isLoadingMore => status == PagedStatus.loadingMore;
  bool get isBusy =>
      status != PagedStatus.idle && status != PagedStatus.initial;

  /// Loaded successfully and there is nothing to show.
  bool get isEmpty => hasLoaded && items.isEmpty;

  /// Whether a [PagedStatus.loadingMore] request may start now.
  bool get canLoadMore =>
      status == PagedStatus.idle && hasMore && nextPage != null;

  /// Pass a function for nullable fields so they can be set to `null`:
  /// `copyWith(failure: () => null)`.
  PagedState<T, Q> copyWith({
    List<T>? items,
    Q? query,
    PagedStatus? status,
    bool? hasMore,
    PageRequest? Function()? nextPage,
    Failure? Function()? failure,
    bool? hasLoaded,
  }) {
    return PagedState<T, Q>(
      items: items ?? this.items,
      query: query ?? this.query,
      status: status ?? this.status,
      hasMore: hasMore ?? this.hasMore,
      nextPage: nextPage != null ? nextPage() : this.nextPage,
      failure: failure != null ? failure() : this.failure,
      hasLoaded: hasLoaded ?? this.hasLoaded,
    );
  }

  @override
  List<Object?> get props => [
    items,
    query,
    status,
    hasMore,
    nextPage,
    failure,
    hasLoaded,
  ];
}
