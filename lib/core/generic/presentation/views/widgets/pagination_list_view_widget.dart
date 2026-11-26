import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../common/domain/entities/failure.dart';
import '../../../../common/presentation/extensions/size/size_extension.dart';
import '../../bloc/paged_list_bloc.dart';

/// Infinite list bound to a [PagedListBloc].
///
/// Handles first load, empty and error placeholders, pull-to-refresh,
/// automatic (scroll) or manual (button) load-more and load-more errors.
///
/// Built only on Material widgets and the ambient [Theme] so it works with
/// any design system; pass builders to customise each placeholder.
class PaginationListView<T> extends StatefulWidget {
  const PaginationListView({
    required this.bloc,
    required this.itemBuilder,
    super.key,
    this.emptyBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.scrollController,
    this.showLoadMoreButton = false,
    this.separatorBuilder,
    // Default must be const; extension getters aren't const-evaluable.
    // ignore: avoid_edge_insets_all
    this.padding = const EdgeInsets.all(16),
    this.enablePullToRefresh = true,
    this.autoStart = true,
    this.loadMoreThreshold = 200,
  });

  /// Any `PagedListBloc<T, Q>` (the query type doesn't matter here).
  final PagedListBloc<T, Object?> bloc;

  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  /// Shown when the first page loaded and is empty.
  final WidgetBuilder? emptyBuilder;

  /// Shown while the first page loads.
  final WidgetBuilder? loadingBuilder;

  /// Shown when the first page failed and there is nothing to show.
  /// [retry] reloads the first page.
  final Widget Function(
    BuildContext context,
    Failure failure,
    VoidCallback retry,
  )?
  errorBuilder;

  final ScrollController? scrollController;

  /// Shows a "load more" button instead of loading on scroll.
  final bool showLoadMoreButton;

  final IndexedWidgetBuilder? separatorBuilder;
  final EdgeInsetsGeometry padding;
  final bool enablePullToRefresh;

  /// Dispatches [PagedListStarted] on first build if the bloc is untouched.
  final bool autoStart;

  /// Distance (logical pixels) from the end at which the next page is loaded.
  final double loadMoreThreshold;

  @override
  State<PaginationListView<T>> createState() => _PaginationListViewState<T>();
}

class _PaginationListViewState<T> extends State<PaginationListView<T>> {
  late final ScrollController _controller =
      widget.scrollController ?? ScrollController();

  @override
  void initState() {
    super.initState();
    if (!widget.showLoadMoreButton) {
      _controller.addListener(_onScroll);
    }
    if (widget.autoStart && widget.bloc.state.isInitial) {
      widget.bloc.add(const PagedListStarted());
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    if (widget.scrollController == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    final position = _controller.position;
    if (position.pixels >=
            position.maxScrollExtent - widget.loadMoreThreshold &&
        widget.bloc.state.canLoadMore) {
      _loadMore();
    }
  }

  void _loadMore() => widget.bloc.add(const PagedListNextPageRequested());

  void _refresh() => widget.bloc.add(const PagedListRefreshed());

  Future<void> _onPullToRefresh() async {
    final done = widget.bloc.stream.firstWhere((s) => !s.isBusy);
    _refresh();
    try {
      await done.timeout(const Duration(seconds: 30));
    } on TimeoutException {
      // Stop the spinner; the state will still update when the load ends.
    } on StateError {
      // Bloc closed before the refresh finished.
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PagedListBloc<T, Object?>, PagedState<T, Object?>>(
      bloc: widget.bloc,
      builder: (context, state) {
        final content = _buildContent(context, state);
        if (!widget.enablePullToRefresh || state.isInitial) {
          return content;
        }
        return RefreshIndicator(onRefresh: _onPullToRefresh, child: content);
      },
    );
  }

  Widget _buildContent(BuildContext context, PagedState<T, Object?> state) {
    final failure = state.failure;
    if (state.items.isEmpty) {
      if (state.isInitial) {
        return const SizedBox.shrink();
      }
      if (state.isBusy) {
        return _Placeholder(
          child:
              widget.loadingBuilder?.call(context) ??
              const CircularProgressIndicator.adaptive(),
        );
      }
      if (failure != null) {
        return _Placeholder(
          child:
              widget.errorBuilder?.call(context, failure, _refresh) ??
              _ErrorMessage(failure: failure, onRetry: _refresh),
        );
      }
      return _Placeholder(
        child: widget.emptyBuilder?.call(context) ?? const _EmptyMessage(),
      );
    }

    final footer = _buildFooter(context, state);
    final itemCount = state.items.length + (footer == null ? 0 : 1);
    return ListView.separated(
      controller: _controller,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: widget.padding,
      itemCount: itemCount,
      separatorBuilder: (context, index) =>
          widget.separatorBuilder?.call(context, index) ?? 8.verticalGap,
      itemBuilder: (context, index) => index < state.items.length
          ? widget.itemBuilder(context, state.items[index], index)
          : footer!,
    );
  }

  Widget? _buildFooter(BuildContext context, PagedState<T, Object?> state) {
    final failure = state.failure;
    if (state.isLoadingMore) {
      return Padding(
        padding: 16.allPadding,
        child: const Center(child: CircularProgressIndicator.adaptive()),
      );
    }
    if (failure != null && state.hasMore) {
      return _ErrorMessage(failure: failure, onRetry: _loadMore);
    }
    if (!widget.showLoadMoreButton) {
      return null;
    }
    if (!state.hasMore) {
      return Padding(
        padding: 16.allPadding,
        child: Text(
          LocaleKeys.common_sentences_noMoreData.tr(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
    }
    return Padding(
      padding: 16.allPadding,
      child: OutlinedButton(
        onPressed: state.canLoadMore ? _loadMore : null,
        child: Text(LocaleKeys.common_sentences_loadMore.tr()),
      ),
    );
  }
}

/// Centers [child] in a scrollable so pull-to-refresh also works on
/// placeholders.
class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.hasBoundedHeight ? constraints.maxHeight : 0,
            minWidth: constraints.maxWidth,
          ),
          child: Center(
            child: Padding(padding: 16.allPadding, child: child),
          ),
        ),
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.failure, required this.onRetry});

  final Failure failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: 16.allPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
          16.verticalGap,
          Text(
            failure.message.tr(),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          16.verticalGap,
          FilledButton(
            onPressed: onRetry,
            child: Text(LocaleKeys.common_words_retry.tr()),
          ),
        ],
      ),
    );
  }
}

class _EmptyMessage extends StatelessWidget {
  const _EmptyMessage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.inbox_outlined,
          size: 48,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        16.verticalGap,
        Text(
          LocaleKeys.common_errors_noDataFound.tr(),
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge,
        ),
      ],
    );
  }
}
