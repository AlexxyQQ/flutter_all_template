import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/constants/colors/material/material_primitive_colors.dart';
import '../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../common/presentation/extensions/size/size_extension.dart';
import '../../../../common/presentation/extensions/theme/theme_extension.dart';
import '../../../../common/presentation/views/components/app_color.dart';
import '../../../../common/presentation/views/widgets/system/app_button.dart';
import '../../../../common/presentation/views/widgets/system/icon/app_icon_widget.dart';
import '../../../../common/presentation/views/widgets/system/text/app_text_widget.dart';
import '../../bloc/crud/base_crud_bloc.dart';

/// A generic pagination ListView widget that works with any PaginationBloc
class PaginationListView<Entity> extends StatefulWidget {
  const PaginationListView({
    required this.bloc,
    required this.itemBuilder,
    super.key,
    this.emptyWidget,
    this.loadingWidget,
    this.errorBuilder,
    this.scrollController,
    this.showLoadMoreButton = false,
    this.separator,
    this.padding,
    this.enablePullToRefresh = true,
    this.refreshIndicatorColor,
  });

  /// The pagination bloc to use
  final BaseCrudBloc<Entity> bloc;

  /// Builder function for each item
  final Widget Function(BuildContext context, Entity item, int index)
  itemBuilder;

  /// Widget to show when the list is empty
  final Widget? emptyWidget;

  /// Widget to show while loading
  final Widget? loadingWidget;

  /// Widget to show when there's an error
  final Widget Function(BuildContext context, String error)? errorBuilder;

  /// Scroll controller for the list
  final ScrollController? scrollController;

  /// Whether to show a load more button instead of automatic loading
  final bool showLoadMoreButton;

  /// Custom separator between entities
  final Widget? separator;

  /// Padding for the list
  final EdgeInsets? padding;

  /// Whether to enable pull to refresh
  final bool enablePullToRefresh;

  /// Custom refresh indicator color
  final KAppColor? refreshIndicatorColor;

  @override
  State<PaginationListView<Entity>> createState() =>
      _PaginationListViewState<Entity>();
}

class _PaginationListViewState<Entity>
    extends State<PaginationListView<Entity>> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();

    // Add scroll listener only when load more button is hidden
    if (!widget.showLoadMoreButton) {
      _scrollController.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    if (!widget.showLoadMoreButton) {
      _scrollController.removeListener(_onScroll);
    }
    // Only dispose if we created the controller
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      final state = widget.bloc.state;
      if (!state.hasReachedNextEnd && !state.isLoadingNext) {
        widget.bloc.add(const LoadNextPaginationEvent());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BaseCrudBloc<Entity>, BaseCrudState<Entity>>(
      bloc: widget.bloc,
      builder: (context, state) {
        // Build the main content based on state
        Widget content;

        if (state.isLoading && state.entities.isEmpty) {
          content = _buildScrollablePlaceholder(
            widget.loadingWidget ?? const _DefaultLoadingWidget(),
          );
        } else if (state.error != null && state.entities.isEmpty) {
          content = _buildScrollablePlaceholder(
            widget.errorBuilder?.call(context, state.error!.message) ??
                _DefaultErrorWidget(
                  error: state.error!.message,
                  onRetry: () =>
                      widget.bloc.add(const RefreshPaginationEvent()),
                ),
          );
        } else if (state.entities.isEmpty) {
          if (state.isInitial) {
            content = const SizedBox.shrink();
          } else {
            content = _buildScrollablePlaceholder(
              widget.emptyWidget ?? const _DefaultEmptyWidget(),
            );
          }
        } else {
          // Build the list
          int itemCount = state.entities.length;
          if (widget.showLoadMoreButton && !state.hasReachedNextEnd) {
            itemCount++;
          }

          content = Stack(
            children: [
              ListView.separated(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: widget.padding ?? 16.allPadding,
                itemCount: itemCount,
                separatorBuilder: (context, index) =>
                    widget.separator ?? 8.verticalGap,
                itemBuilder: (context, index) {
                  if (widget.showLoadMoreButton &&
                      index == state.entities.length) {
                    return _LoadMoreButton(bloc: widget.bloc, state: state);
                  }
                  return widget.itemBuilder(
                    context,
                    state.entities[index],
                    index,
                  );
                },
              ),
              if (state.isLoadingNext && !widget.showLoadMoreButton)
                const Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: _LoadingIndicator(),
                ),
            ],
          );
        }

        // Wrap with RefreshIndicator only if pull to refresh is enabled
        // AND we have content that can actually be scrolled
        if (!widget.enablePullToRefresh || state.isInitial) {
          return content;
        }

        // Use LayoutBuilder to ensure RefreshIndicator has proper constraints
        return LayoutBuilder(
          builder: (context, constraints) {
            // Only wrap with RefreshIndicator if we have valid dimensions
            if (constraints.maxWidth <= 0 || constraints.maxHeight <= 0) {
              return content;
            }

            return RefreshIndicator(
              color: widget.refreshIndicatorColor ?? context.colors.primary,
              onRefresh: () async {
                widget.bloc.add(const RefreshPaginationEvent());

                try {
                  await widget.bloc.stream
                      .firstWhere((state) => !state.isLoading)
                      .timeout(const Duration(seconds: 10));
                } catch (_) {
                  // Handle timeout or stream errors silently
                }
              },
              child: content,
            );
          },
        );
      },
    );
  }

  /// Helper to make non-list widgets (Empty, Error, Loader) scrollable
  /// so RefreshIndicator works.
  Widget _buildScrollablePlaceholder(Widget child) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use constraints or fallback to MediaQuery
        final height = constraints.maxHeight > 0
            ? constraints.maxHeight * 0.8
            : MediaQuery.of(context).size.height * 0.8;

        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            // ignore: avoid_sized_box_height
            SizedBox(
              height: height,
              child: Center(child: child),
            ),
          ],
        );
      },
    );
  }
}

class _LoadMoreButton<Entity> extends StatelessWidget {
  const _LoadMoreButton({required this.bloc, required this.state});
  final BaseCrudBloc<Entity> bloc;
  final BaseCrudState<Entity> state;

  @override
  Widget build(BuildContext context) {
    if (state.hasReachedNextEnd) {
      return Container(
        padding: 16.allPadding,
        alignment: Alignment.center,
        child: AppText(
          LocaleKeys.common_sentences_noMoreData,
          style: context.textStyles.bodySmall,
        ),
      );
    }

    return Container(
      padding: 16.allPadding,
      child: AppButton.stroke(
        onPressed: () => bloc.add(const LoadNextPaginationEvent()),
        label: LocaleKeys.common_sentences_loadMore,
        width: double.infinity,
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: 8.allPadding,
        decoration: BoxDecoration(
          color: AppMaterialPrimitives.white,
          borderRadius: 8.rounded,
          boxShadow: [
            BoxShadow(
              color: AppMaterialPrimitives.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SizedBox(
          width: 20.r,
          height: 20.r,
          child: CircularProgressIndicator.adaptive(
            strokeWidth: 2.w,
            valueColor: AlwaysStoppedAnimation(context.colors.primary),
          ),
        ),
      ),
    );
  }
}

class _DefaultLoadingWidget extends StatelessWidget {
  const _DefaultLoadingWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(context.colors.primary),
      ),
    );
  }
}

class _DefaultErrorWidget extends StatelessWidget {
  const _DefaultErrorWidget({required this.error, required this.onRetry});
  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: 16.allPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48.w, color: context.colors.error),
            16.verticalGap,
            AppText(
              error,
              style: context.textStyles.bodyLarge.copyWith(
                color: context.colors.error,
              ),
              textAlign: TextAlign.center,
            ),
            16.verticalGap,
            AppButton.primary(
              onPressed: onRetry,
              label: LocaleKeys.common_words_retry,
            ),
          ],
        ),
      ),
    );
  }
}

class _DefaultEmptyWidget extends StatelessWidget {
  const _DefaultEmptyWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: 16.allPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon(
              Icons.inbox_outlined,
              size: 48.w,
              color: context.colors.onSurface,
            ),
            16.verticalGap,
            AppText(
              LocaleKeys.common_errors_noDataFound,
              style: context.textStyles.bodyLarge.copyWith(
                color: context.colors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
