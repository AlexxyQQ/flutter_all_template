import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_all_template/config/constants/type_defs/typedef.dart';
import 'package:flutter_all_template/core/common/domain/entities/failure.dart';
import 'package:flutter_all_template/core/generic/presentation/bloc/paged_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

/// Records every request; answers from [responses] (FIFO) or, when empty,
/// with a pending completer the test completes manually.
class FakeFetcher {
  final requests = <(PageRequest, String)>[];
  final responses = <Either<Failure, PageResult<int>>>[];
  final pending = <Completer<Either<Failure, PageResult<int>>>>[];

  ResultFuture<PageResult<int>> call(PageRequest request, String query) {
    requests.add((request, query));
    if (responses.isNotEmpty) {
      return Future.value(responses.removeAt(0));
    }
    final completer = Completer<Either<Failure, PageResult<int>>>();
    pending.add(completer);
    return completer.future;
  }
}

const failure = Failure(message: 'error.key', type: FailureType.network);

Either<Failure, PageResult<int>> page(
  List<int> items, {
  bool hasMore = true,
  String? cursor,
}) => Right(PageResult(items: items, hasMore: hasMore, nextCursor: cursor));

void main() {
  late FakeFetcher fetcher;

  PagedListBloc<int, String> build({Duration debounce = Duration.zero}) =>
      PagedListBloc<int, String>(
        fetchPage: fetcher.call,
        initialQuery: '',
        pageSize: 2,
        queryDebounce: debounce,
      );

  setUp(() => fetcher = FakeFetcher());

  group('first load', () {
    blocTest<PagedListBloc<int, String>, PagedState<int, String>>(
      'loads page 1 with the page size',
      setUp: () => fetcher.responses.add(page([1, 2], cursor: 'c2')),
      build: build,
      act: (bloc) => bloc.add(const PagedListStarted()),
      expect: () => [
        const PagedState<int, String>(
          query: '',
          status: PagedStatus.loadingFirst,
        ),
        const PagedState<int, String>(
          query: '',
          items: [1, 2],
          status: PagedStatus.idle,
          nextPage: PageRequest(page: 2, limit: 2, cursor: 'c2'),
          hasLoaded: true,
        ),
      ],
      verify: (_) => expect(fetcher.requests.single, (
        const PageRequest.first(limit: 2),
        '',
      )),
    );

    blocTest<PagedListBloc<int, String>, PagedState<int, String>>(
      'Started is ignored once loaded',
      setUp: () => fetcher.responses.add(page([1])),
      build: build,
      act: (bloc) async {
        bloc.add(const PagedListStarted());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const PagedListStarted());
      },
      verify: (_) => expect(fetcher.requests, hasLength(1)),
    );

    blocTest<PagedListBloc<int, String>, PagedState<int, String>>(
      'failure is reported and items stay empty',
      setUp: () => fetcher.responses.add(const Left(failure)),
      build: build,
      act: (bloc) => bloc.add(const PagedListStarted()),
      skip: 1,
      expect: () => [
        const PagedState<int, String>(
          query: '',
          status: PagedStatus.idle,
          failure: failure,
        ),
      ],
    );
  });

  group('next page', () {
    blocTest<PagedListBloc<int, String>, PagedState<int, String>>(
      'passes page number and cursor of the previous result, appends items',
      setUp: () => fetcher.responses.addAll([
        page([1, 2], cursor: 'c2'),
        page([3], hasMore: false),
      ]),
      build: build,
      act: (bloc) async {
        bloc.add(const PagedListStarted());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const PagedListNextPageRequested());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const PagedListNextPageRequested()); // no more pages
      },
      verify: (bloc) {
        expect(fetcher.requests.map((r) => r.$1), const [
          PageRequest.first(limit: 2),
          PageRequest(page: 2, limit: 2, cursor: 'c2'),
        ]);
        expect(bloc.state.items, [1, 2, 3]);
        expect(bloc.state.hasMore, isFalse);
        expect(bloc.state.canLoadMore, isFalse);
      },
    );

    test('concurrent requests are dropped while one is loading', () async {
      fetcher.responses.add(page([1, 2]));
      final bloc = build()..add(const PagedListStarted());
      await Future<void>.delayed(Duration.zero);

      bloc
        ..add(const PagedListNextPageRequested())
        ..add(const PagedListNextPageRequested())
        ..add(const PagedListNextPageRequested());
      await Future<void>.delayed(Duration.zero);

      expect(fetcher.requests, hasLength(2));
      expect(bloc.state.isLoadingMore, isTrue);
      fetcher.pending.single.complete(page([3, 4]));
      await Future<void>.delayed(Duration.zero);
      expect(bloc.state.items, [1, 2, 3, 4]);
      await bloc.close();
    });

    blocTest<PagedListBloc<int, String>, PagedState<int, String>>(
      'failure keeps loaded items and can be retried',
      setUp: () => fetcher.responses.addAll([
        page([1, 2]),
        const Left(failure),
        page([3]),
      ]),
      build: build,
      act: (bloc) async {
        bloc.add(const PagedListStarted());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const PagedListNextPageRequested());
        await Future<void>.delayed(Duration.zero);
        expect(bloc.state.items, [1, 2]);
        expect(bloc.state.failure, failure);
        bloc.add(const PagedListNextPageRequested());
      },
      verify: (bloc) {
        expect(bloc.state.items, [1, 2, 3]);
        expect(bloc.state.failure, isNull);
        expect(fetcher.requests[2].$1.page, 2);
      },
    );
  });

  group('refresh', () {
    blocTest<PagedListBloc<int, String>, PagedState<int, String>>(
      'keeps items visible while refreshing and replaces them on success',
      setUp: () => fetcher.responses.addAll([
        page([1, 2], cursor: 'old'),
        page([3], cursor: 'new'),
        page([9, 8], cursor: 'fresh'),
      ]),
      build: build,
      act: (bloc) async {
        bloc.add(const PagedListStarted());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const PagedListNextPageRequested());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const PagedListRefreshed());
      },
      skip: 4,
      expect: () => [
        const PagedState<int, String>(
          query: '',
          items: [1, 2, 3],
          status: PagedStatus.refreshing,
          nextPage: PageRequest(page: 3, limit: 2, cursor: 'new'),
          hasLoaded: true,
        ),
        const PagedState<int, String>(
          query: '',
          items: [9, 8],
          status: PagedStatus.idle,
          nextPage: PageRequest(page: 2, limit: 2, cursor: 'fresh'),
          hasLoaded: true,
        ),
      ],
    );

    blocTest<PagedListBloc<int, String>, PagedState<int, String>>(
      'a failed refresh never wipes loaded items',
      setUp: () => fetcher.responses.addAll([
        page([1, 2]),
        const Left(failure),
      ]),
      build: build,
      act: (bloc) async {
        bloc.add(const PagedListStarted());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const PagedListRefreshed());
      },
      verify: (bloc) {
        expect(bloc.state.items, [1, 2]);
        expect(bloc.state.failure, failure);
        expect(bloc.state.status, PagedStatus.idle);
      },
    );

    test('discards a load-more that was in flight', () async {
      fetcher.responses.add(page([1, 2]));
      final bloc = build()..add(const PagedListStarted());
      await Future<void>.delayed(Duration.zero);

      bloc.add(const PagedListNextPageRequested()); // pending[0]
      await Future<void>.delayed(Duration.zero);
      bloc.add(const PagedListRefreshed()); // pending[1]
      await Future<void>.delayed(Duration.zero);

      fetcher.pending[1].complete(page([7, 8]));
      await Future<void>.delayed(Duration.zero);
      fetcher.pending[0].complete(page([3, 4]));
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state.items, [7, 8]);
      expect(bloc.state.nextPage?.page, 2);
      await bloc.close();
    });
  });

  group('query', () {
    test('is debounced: only the last query of a burst is fetched', () async {
      fetcher.responses.add(page([1]));
      final bloc = build(debounce: const Duration(milliseconds: 30))
        ..add(const PagedListQueryChanged('a'))
        ..add(const PagedListQueryChanged('ab'))
        ..add(const PagedListQueryChanged('abc'));

      await Future<void>.delayed(const Duration(milliseconds: 80));

      expect(fetcher.requests, [(const PageRequest.first(limit: 2), 'abc')]);
      expect(bloc.state.query, 'abc');
      expect(bloc.state.items, [1]);
      await bloc.close();
    });

    test(
      'is restartable: a slower older query never overwrites a newer one',
      () async {
        final bloc = build()..add(const PagedListQueryChanged('old'));
        await Future<void>.delayed(Duration.zero);
        bloc.add(const PagedListQueryChanged('new'));
        await Future<void>.delayed(Duration.zero);

        fetcher.pending[1].complete(page([2]));
        await Future<void>.delayed(Duration.zero);
        fetcher.pending[0].complete(page([1]));
        await Future<void>.delayed(Duration.zero);

        expect(bloc.state.query, 'new');
        expect(bloc.state.items, [2]);
        await bloc.close();
      },
    );

    blocTest<PagedListBloc<int, String>, PagedState<int, String>>(
      'an unchanged query does not refetch once loaded',
      setUp: () => fetcher.responses.add(page([1])),
      build: build,
      act: (bloc) async {
        bloc.add(const PagedListQueryChanged('x'));
        await Future<void>.delayed(const Duration(milliseconds: 10));
        bloc.add(const PagedListQueryChanged('x'));
        await Future<void>.delayed(const Duration(milliseconds: 10));
      },
      verify: (_) => expect(fetcher.requests, hasLength(1)),
    );
  });

  group('failed query change', () {
    test(
      'drops the old query items and paging so load-more cannot mix them',
      () async {
        fetcher.responses
          ..add(page([1, 2], cursor: 'c1'))
          ..add(const Left(failure));
        final bloc = build()..add(const PagedListStarted());
        await Future<void>.delayed(Duration.zero);
        expect(bloc.state.items, [1, 2]);
        expect(bloc.state.canLoadMore, isTrue);

        bloc.add(const PagedListQueryChanged('new'));
        await Future<void>.delayed(const Duration(milliseconds: 10));

        expect(bloc.state.query, 'new');
        expect(bloc.state.failure, failure);
        expect(bloc.state.items, isEmpty);
        expect(bloc.state.hasLoaded, isFalse);
        expect(bloc.state.nextPage, isNull);
        expect(bloc.state.canLoadMore, isFalse);

        bloc.add(const PagedListNextPageRequested());
        await Future<void>.delayed(Duration.zero);
        expect(fetcher.requests, hasLength(2)); // No page-2 for 'new'.

        // Retrying the same query (refresh) recovers.
        fetcher.responses.add(page([7], hasMore: false));
        bloc.add(const PagedListRefreshed());
        await Future<void>.delayed(const Duration(milliseconds: 10));
        expect(bloc.state.items, [7]);
        expect(bloc.state.failure, isNull);
        expect(fetcher.requests.last, (
          const PageRequest.first(limit: 2),
          'new',
        ));
        await bloc.close();
      },
    );

    test('a failed refresh of the same query keeps items and paging', () async {
      fetcher.responses
        ..add(page([1, 2], cursor: 'c1'))
        ..add(const Left(failure));
      final bloc = build()..add(const PagedListStarted());
      await Future<void>.delayed(Duration.zero);

      bloc.add(const PagedListRefreshed());
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state.items, [1, 2]);
      expect(bloc.state.failure, failure);
      expect(bloc.state.canLoadMore, isTrue);
      await bloc.close();
    });
  });

  group('PageRequest / PageResult', () {
    test('offset and fromItems', () {
      const request = PageRequest(page: 3, limit: 10);
      expect(request.offset, 20);
      expect(request.isFirst, isFalse);
      expect(
        PageResult.fromItems(List.filled(10, 0), request: request).hasMore,
        isTrue,
      );
      expect(
        PageResult.fromItems(const [1], request: request).hasMore,
        isFalse,
      );
    });

    test('map keeps paging info', () {
      const result = PageResult(items: [1, 2], hasMore: true, nextCursor: 'c');
      expect(
        result.map((i) => '$i'),
        const PageResult(items: ['1', '2'], hasMore: true, nextCursor: 'c'),
      );
    });
  });
}
