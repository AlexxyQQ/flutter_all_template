// ignore_for_file: avoid_sized_box_height, avoid_hardcoded_strings_in_widgets
import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_all_template/config/constants/gen/locale_keys.g.dart';
import 'package:flutter_all_template/core/common/domain/entities/failure.dart';
import 'package:flutter_all_template/core/generic/presentation/bloc/paged_list_bloc.dart';
import 'package:flutter_all_template/core/generic/presentation/views/widgets/pagination_list_view_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPagedBloc extends MockBloc<PagedListEvent, PagedState<String, String>>
    implements PagedListBloc<String, String> {}

const _failure = Failure(message: 'error.key');

PagedState<String, String> _loaded(
  int count, {
  bool hasMore = true,
  PagedStatus status = PagedStatus.idle,
  Failure? failure,
}) => PagedState<String, String>(
  query: '',
  items: [for (var i = 0; i < count; i++) 'Item $i'],
  status: status,
  hasMore: hasMore,
  nextPage: const PageRequest(page: 2, limit: 10),
  hasLoaded: true,
  failure: failure,
);

void main() {
  late MockPagedBloc bloc;

  setUpAll(() => registerFallbackValue(const PagedListStarted()));

  setUp(() => bloc = MockPagedBloc());

  Widget app({bool showLoadMoreButton = false, double itemHeight = 100}) {
    return MaterialApp(
      home: Scaffold(
        body: PaginationListView<String>(
          bloc: bloc,
          showLoadMoreButton: showLoadMoreButton,
          itemBuilder: (_, item, _) =>
              SizedBox(height: itemHeight, child: Text(item)),
        ),
      ),
    );
  }

  testWidgets('dispatches Started when the bloc is untouched', (tester) async {
    when(() => bloc.state).thenReturn(const PagedState(query: ''));

    await tester.pumpWidget(app());

    verify(() => bloc.add(const PagedListStarted())).called(1);
  });

  testWidgets('shows a spinner while the first page loads', (tester) async {
    when(
      () => bloc.state,
    ).thenReturn(const PagedState(query: '', status: PagedStatus.loadingFirst));

    await tester.pumpWidget(app());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    verifyNever(() => bloc.add(any()));
  });

  testWidgets('shows the empty placeholder', (tester) async {
    when(() => bloc.state).thenReturn(
      const PagedState(query: '', status: PagedStatus.idle, hasLoaded: true),
    );

    await tester.pumpWidget(app());

    expect(find.text(LocaleKeys.common_errors_noDataFound), findsOneWidget);
  });

  testWidgets('shows the error and retries with a refresh', (tester) async {
    when(() => bloc.state).thenReturn(
      const PagedState(query: '', status: PagedStatus.idle, failure: _failure),
    );

    await tester.pumpWidget(app());
    expect(find.text('error.key'), findsOneWidget);

    await tester.tap(find.byType(FilledButton));

    verify(() => bloc.add(const PagedListRefreshed())).called(1);
  });

  testWidgets('renders items', (tester) async {
    when(() => bloc.state).thenReturn(_loaded(2));

    await tester.pumpWidget(app());

    expect(find.text('Item 0'), findsOneWidget);
    expect(find.text('Item 1'), findsOneWidget);
  });

  testWidgets('requests the next page when scrolled near the end', (
    tester,
  ) async {
    when(() => bloc.state).thenReturn(_loaded(20));

    await tester.pumpWidget(app());
    verifyNever(() => bloc.add(const PagedListNextPageRequested()));

    await tester.drag(find.byType(ListView), const Offset(0, -5000));
    await tester.pump();

    verify(
      () => bloc.add(const PagedListNextPageRequested()),
    ).called(greaterThan(0));
  });

  testWidgets('load-more button requests the next page', (tester) async {
    when(() => bloc.state).thenReturn(_loaded(3));

    await tester.pumpWidget(app(showLoadMoreButton: true, itemHeight: 50));
    await tester.tap(find.byType(OutlinedButton));

    verify(() => bloc.add(const PagedListNextPageRequested())).called(1);
  });

  testWidgets('shows "no more data" at the end in button mode', (tester) async {
    when(() => bloc.state).thenReturn(_loaded(3, hasMore: false));

    await tester.pumpWidget(app(showLoadMoreButton: true, itemHeight: 50));

    expect(find.byType(OutlinedButton), findsNothing);
    expect(find.text(LocaleKeys.common_sentences_noMoreData), findsOneWidget);
  });

  testWidgets('load-more errors keep items and retry the next page', (
    tester,
  ) async {
    when(() => bloc.state).thenReturn(_loaded(2, failure: _failure));

    await tester.pumpWidget(app(itemHeight: 50));
    expect(find.text('Item 0'), findsOneWidget);
    expect(find.text('error.key'), findsOneWidget);

    await tester.tap(find.byType(FilledButton));

    verify(() => bloc.add(const PagedListNextPageRequested())).called(1);
  });

  testWidgets('shows a footer spinner while loading more', (tester) async {
    when(
      () => bloc.state,
    ).thenReturn(_loaded(2, status: PagedStatus.loadingMore));

    await tester.pumpWidget(app(itemHeight: 50));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('pull-to-refresh dispatches a refresh and waits for it', (
    tester,
  ) async {
    final idle = _loaded(6);
    final states = StreamController<PagedState<String, String>>.broadcast();
    addTearDown(states.close);
    whenListen(bloc, states.stream, initialState: idle);

    await tester.pumpWidget(app());
    await tester.fling(find.byType(ListView), const Offset(0, 400), 1000);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Still waiting for the bloc: the indicator is showing.
    expect(find.byType(RefreshProgressIndicator), findsOneWidget);
    states
      ..add(_loaded(6, status: PagedStatus.refreshing))
      ..add(idle);
    await tester.pumpAndSettle();

    expect(find.byType(RefreshProgressIndicator), findsNothing);
    verify(() => bloc.add(const PagedListRefreshed())).called(1);
  });
}
