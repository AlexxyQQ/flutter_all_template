import 'package:equatable/equatable.dart';

/// What to fetch next from a paginated source.
///
/// Supports both pagination styles so a repository can use whichever its
/// backend speaks:
/// * **page-number** APIs read [page] (1-based) and [limit];
/// * **cursor** APIs read [cursor] (the [PageResult.nextCursor] of the
///   previous page, `null` for the first page) and [limit].
final class PageRequest extends Equatable {
  const PageRequest({required this.limit, this.page = firstPage, this.cursor})
    : assert(page >= firstPage, 'page is 1-based'),
      assert(limit > 0, 'limit must be positive');

  /// The first page request for a list of [limit] items per page.
  const PageRequest.first({required this.limit})
    : page = firstPage,
      cursor = null;

  /// Page numbers are 1-based everywhere in the app.
  static const int firstPage = 1;

  final int page;
  final int limit;
  final String? cursor;

  bool get isFirst => page == firstPage;

  /// Zero-based index of the first item of this page (for offset APIs).
  int get offset => (page - firstPage) * limit;

  /// The request that follows [result] (which answered this request).
  PageRequest next(PageResult<Object?> result) =>
      PageRequest(page: page + 1, limit: limit, cursor: result.nextCursor);

  @override
  List<Object?> get props => [page, limit, cursor];

  @override
  String toString() =>
      'PageRequest(page: $page, limit: $limit, cursor: $cursor)';
}

/// One page of [items] returned by a paginated source.
final class PageResult<T> extends Equatable {
  const PageResult({
    required this.items,
    required this.hasMore,
    this.nextCursor,
  });

  /// Builds a result for page-number APIs that don't report `hasMore`:
  /// a full page means there may be more.
  factory PageResult.fromItems(List<T> items, {required PageRequest request}) =>
      PageResult(items: items, hasMore: items.length >= request.limit);

  final List<T> items;

  /// Whether another page can be requested.
  final bool hasMore;

  /// Opaque cursor for the next page (cursor-based APIs only).
  final String? nextCursor;

  PageResult<R> map<R>(R Function(T item) convert) => PageResult<R>(
    items: items.map(convert).toList(growable: false),
    hasMore: hasMore,
    nextCursor: nextCursor,
  );

  @override
  List<Object?> get props => [items, hasMore, nextCursor];
}
