import 'package:equatable/equatable.dart';

/// Events understood by `PagedListBloc`.
///
/// Not sealed on purpose: feature blocs extending `PagedListBloc` add their
/// own events (create/delete/toggle…) by extending [PagedListEvent].
abstract class PagedListEvent extends Equatable {
  const PagedListEvent();

  @override
  List<Object?> get props => const [];
}

/// Loads the first page if nothing was loaded yet. Ignored afterwards — use
/// [PagedListRefreshed] to reload.
final class PagedListStarted extends PagedListEvent {
  const PagedListStarted();
}

/// Reloads from the first page with the current query (pull-to-refresh,
/// retry). Items stay visible until the new first page arrives.
final class PagedListRefreshed extends PagedListEvent {
  const PagedListRefreshed();
}

/// Loads the next page if there is one. Dropped while another page load is
/// in progress.
final class PagedListNextPageRequested extends PagedListEvent {
  const PagedListNextPageRequested();
}

/// Replaces the query/filter and reloads from the first page. Debounced and
/// restartable: only the latest query of a burst is fetched.
final class PagedListQueryChanged<Q> extends PagedListEvent {
  const PagedListQueryChanged(this.query);

  final Q query;

  @override
  List<Object?> get props => [query];
}
