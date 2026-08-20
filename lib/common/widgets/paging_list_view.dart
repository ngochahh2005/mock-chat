import 'package:base_bloc_3/import.dart';
import 'package:flutter/cupertino.dart';

/// Constants for paging widgets
class _PagingConstants {
  static const double firstPageLoadingHeight = 200.0;
  static const double newPageLoadingHeight = 60.0;
  static const double newPageErrorIconSize = 16.0;
  static const double newPageErrorSpacing = 4.0;
}

/// Helper mixin for building common paging indicators
mixin _PagingIndicatorBuilder<T> {
  /// Build default first page loading indicator
  Widget buildFirstPageLoadingIndicator({
    Widget? customIndicator,
    Color? backgroundColor,
  }) {
    if (customIndicator != null) return customIndicator;
    
    return Container(
      color: backgroundColor ?? Colors.transparent,
      height: _PagingConstants.firstPageLoadingHeight,
      child: Center(
        child: Platform.isIOS
            ? const CupertinoActivityIndicator()
            : const CircularProgressIndicator(),
      ),
    );
  }

  /// Build default first page error indicator
  Widget buildFirstPageErrorIndicator({
    required PagingController<int, T> controller,
    Widget? customIndicator,
    VoidCallback? onRefresh,
  }) {
    if (customIndicator != null) return customIndicator;
    
    // In version 5.x, error is Object? instead of dynamic
    final errorMessage = controller.value.error?.toString() ?? S.current.error_system;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(errorMessage),
        SizedBox(height: 16.h),
        ElevatedButton(
          onPressed: onRefresh ?? () => controller.refresh(),
          child: Text(S.current.click_to_reload),
        ),
      ],
    );
  }

  /// Build default new page loading indicator
  Widget buildNewPageLoadingIndicator(Widget? customIndicator) {
    if (customIndicator != null) return customIndicator;
    
    return SizedBox(
      height: _PagingConstants.newPageLoadingHeight.h,
      child: const Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }

  /// Build default new page error indicator
  Widget buildNewPageErrorIndicator({
    required PagingController<int, T> controller,
    Widget? customIndicator,
  }) {
    return InkWell(
      onTap: controller.fetchNextPage,
      child: customIndicator ??
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                S.current.click_to_reload,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: _PagingConstants.newPageErrorSpacing),
              const Icon(
                Icons.refresh,
                size: _PagingConstants.newPageErrorIconSize,
              ),
            ],
          ),
    );
  }
}

class CustomSliverListView<T> extends StatelessWidget with _PagingIndicatorBuilder<T> {
  final PagingController<int, T> controller;
  final Widget Function(BuildContext, T, int) builder;
  final Widget? emptyWidget;
  final Widget? firstPageProgressIndicator;
  final Widget? newPageProgressIndicatorBuilder;
  final Widget? newPageErrorIndicatorBuilder;
  final bool shrinkWrapFirstPageIndicators;
  final VoidCallback? onRefresh;
  final double? itemExtent;
  final Color? loadingBackgroundColor;

  const CustomSliverListView({
    super.key,
    required this.controller,
    required this.builder,
    this.emptyWidget,
    this.shrinkWrapFirstPageIndicators = false,
    this.onRefresh,
    this.itemExtent,
    this.loadingBackgroundColor,
    this.firstPageProgressIndicator,
    this.newPageProgressIndicatorBuilder,
    this.newPageErrorIndicatorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    // In version 5.x, use PagingListener for better state management
    return PagingListener<int, T>(
      controller: controller,
      builder: (context, state, fetchNextPage) {
        return PagedSliverList<int, T>(
          state: state,
          fetchNextPage: fetchNextPage,
          itemExtent: itemExtent,
          shrinkWrapFirstPageIndicators: shrinkWrapFirstPageIndicators,
          builderDelegate: PagedChildBuilderDelegate<T>(
            itemBuilder: builder,
            noItemsFoundIndicatorBuilder: (_) => emptyWidget ?? const EmptyWidget(),
            firstPageProgressIndicatorBuilder: (_) =>
                buildFirstPageLoadingIndicator(
                  customIndicator: firstPageProgressIndicator,
                  backgroundColor: loadingBackgroundColor,
                ),
            firstPageErrorIndicatorBuilder: (_) =>
                buildFirstPageErrorIndicator(
                  controller: controller,
                  onRefresh: onRefresh,
                ),
            newPageProgressIndicatorBuilder: (_) =>
                buildNewPageLoadingIndicator(newPageProgressIndicatorBuilder),
            newPageErrorIndicatorBuilder: (_) =>
                buildNewPageErrorIndicator(
                  controller: controller,
                  customIndicator: newPageErrorIndicatorBuilder,
                ),
          ),
        );
      },
    );
  }
}

class CustomListView<T> extends StatelessWidget with _PagingIndicatorBuilder<T> {
  final PagingController<int, T> controller;
  final Widget Function(BuildContext, T, int) builder;
  final Widget emptyWidget;
  final Widget? firstPageProgressIndicator;
  final Widget? newPageProgressIndicatorBuilder;
  final Widget? newPageErrorIndicatorBuilder;
  final bool shrinkWrap;
  final VoidCallback? onRefresh;
  final ScrollPhysics? physics;
  final ScrollController? scrollController;
  final EdgeInsets? padding;

  const CustomListView({
    super.key,
    required this.controller,
    required this.builder,
    this.emptyWidget = const SizedBox.shrink(),
    this.shrinkWrap = false,
    this.onRefresh,
    this.physics,
    this.scrollController,
    this.padding,
    this.firstPageProgressIndicator,
    this.newPageProgressIndicatorBuilder,
    this.newPageErrorIndicatorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    // In version 5.x, use PagingListener for better state management
    return PagingListener<int, T>(
      controller: controller,
      builder: (context, state, fetchNextPage) {
        return PagedListView<int, T>(
          state: state,
          fetchNextPage: fetchNextPage,
          scrollController: scrollController,
          shrinkWrap: shrinkWrap,
          physics: physics,
          padding: padding,
          builderDelegate: PagedChildBuilderDelegate<T>(
            itemBuilder: builder,
            noItemsFoundIndicatorBuilder: (_) => emptyWidget,
            firstPageProgressIndicatorBuilder: (_) =>
                buildFirstPageLoadingIndicator(
                  customIndicator: firstPageProgressIndicator,
                ),
            firstPageErrorIndicatorBuilder: (_) =>
                buildFirstPageErrorIndicator(
                  controller: controller,
                  onRefresh: onRefresh,
                ),
            newPageProgressIndicatorBuilder: (_) =>
                buildNewPageLoadingIndicator(newPageProgressIndicatorBuilder),
            newPageErrorIndicatorBuilder: (_) =>
                buildNewPageErrorIndicator(
                  controller: controller,
                  customIndicator: newPageErrorIndicatorBuilder,
                ),
          ),
        );
      },
    );
  }
}

class CustomSliverListViewSeparated<T> extends StatelessWidget with _PagingIndicatorBuilder<T> {
  final PagingController<int, T> controller;
  final Widget Function(BuildContext, T, int) builder;
  final Widget Function(BuildContext, int) separatorBuilder;
  final Widget? emptyWidget;
  final Widget? firstPageProgressIndicator;
  final Widget? newPageProgressIndicatorBuilder;
  final Widget? newPageErrorIndicatorBuilder;
  final bool shrinkWrapFirstPageIndicators;
  final VoidCallback? onRefresh;
  final double? itemExtent;
  final Color? loadingBackgroundColor;
  final Widget? firstPageErrorIndicatorBuilder;

  const CustomSliverListViewSeparated({
    super.key,
    required this.controller,
    required this.builder,
    this.emptyWidget,
    this.shrinkWrapFirstPageIndicators = false,
    this.onRefresh,
    this.itemExtent,
    this.loadingBackgroundColor,
    required this.separatorBuilder,
    this.firstPageProgressIndicator,
    this.newPageProgressIndicatorBuilder,
    this.newPageErrorIndicatorBuilder,
    this.firstPageErrorIndicatorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    // In version 5.x, use PagingListener for better state management
    return PagingListener<int, T>(
      controller: controller,
      builder: (context, state, fetchNextPage) {
        return PagedSliverList<int, T>.separated(
          state: state,
          fetchNextPage: fetchNextPage,
          itemExtent: itemExtent,
          shrinkWrapFirstPageIndicators: shrinkWrapFirstPageIndicators,
          separatorBuilder: separatorBuilder,
          builderDelegate: PagedChildBuilderDelegate<T>(
            itemBuilder: builder,
            noItemsFoundIndicatorBuilder: (_) => emptyWidget ?? const EmptyWidget(),
            firstPageProgressIndicatorBuilder: (_) =>
                buildFirstPageLoadingIndicator(
                  customIndicator: firstPageProgressIndicator,
                  backgroundColor: loadingBackgroundColor,
                ),
            firstPageErrorIndicatorBuilder: (_) =>
                buildFirstPageErrorIndicator(
                  controller: controller,
                  customIndicator: firstPageErrorIndicatorBuilder,
                  onRefresh: onRefresh,
                ),
            newPageProgressIndicatorBuilder: (_) =>
                buildNewPageLoadingIndicator(newPageProgressIndicatorBuilder),
            newPageErrorIndicatorBuilder: (_) =>
                buildNewPageErrorIndicator(
                  controller: controller,
                  customIndicator: newPageErrorIndicatorBuilder,
                ),
          ),
        );
      },
    );
  }
}

class CustomListViewSeparated<T> extends StatelessWidget with _PagingIndicatorBuilder<T> {
  final PagingController<int, T> controller;
  final Widget Function(BuildContext, T, int) builder;
  final Widget Function(BuildContext, int) separatorBuilder;
  final Widget emptyWidget;
  final Widget? firstPageProgressIndicator;
  final bool shrinkWrap;
  final VoidCallback? onRefresh;
  final ScrollPhysics? physics;
  final ScrollController? scrollController;
  final EdgeInsets? padding;
  final Widget? newPageProgressIndicatorBuilder;
  final Widget? newPageErrorIndicatorBuilder;
  final Widget? firstPageErrorIndicator;

  const CustomListViewSeparated({
    super.key,
    required this.controller,
    required this.builder,
    required this.separatorBuilder,
    this.emptyWidget = const SizedBox.shrink(),
    this.shrinkWrap = false,
    this.onRefresh,
    this.physics,
    this.scrollController,
    this.padding,
    this.firstPageProgressIndicator,
    this.newPageProgressIndicatorBuilder,
    this.newPageErrorIndicatorBuilder,
    this.firstPageErrorIndicator,
  });

  @override
  Widget build(BuildContext context) {
    // In version 5.x, use PagingListener for better state management
    return PagingListener<int, T>(
      controller: controller,
      builder: (context, state, fetchNextPage) {
        return PagedListView<int, T>.separated(
          state: state,
          fetchNextPage: fetchNextPage,
          scrollController: scrollController,
          shrinkWrap: shrinkWrap,
          physics: physics,
          padding: padding,
          builderDelegate: PagedChildBuilderDelegate<T>(
            itemBuilder: builder,
            noItemsFoundIndicatorBuilder: (_) => emptyWidget,
            firstPageProgressIndicatorBuilder: (_) =>
                buildFirstPageLoadingIndicator(
                  customIndicator: firstPageProgressIndicator,
                ),
            firstPageErrorIndicatorBuilder: (_) =>
                buildFirstPageErrorIndicator(
                  controller: controller,
                  customIndicator: firstPageErrorIndicator,
                  onRefresh: onRefresh,
                ),
            newPageProgressIndicatorBuilder: (_) =>
                buildNewPageLoadingIndicator(newPageProgressIndicatorBuilder),
            newPageErrorIndicatorBuilder: (_) =>
                buildNewPageErrorIndicator(
                  controller: controller,
                  customIndicator: newPageErrorIndicatorBuilder,
                ),
          ),
          separatorBuilder: separatorBuilder,
        );
      },
    );
  }
}

class CustomSliverGridView<T> extends StatelessWidget with _PagingIndicatorBuilder<T> {
  final PagingController<int, T> controller;
  final Widget Function(BuildContext, T, int) builder;
  final Widget? emptyWidget;
  final Widget? firstPageProgressIndicator;
  final Widget? newPageProgressIndicatorBuilder;
  final bool shrinkWrapFirstPageIndicators;
  /// If true, new page progress indicator is displayed as a grid child (occupies a grid cell)
  /// If false, it's displayed at the bottom of the grid (like a footer)
  final bool? showNewPageProgressIndicatorAsGridChild;
  final VoidCallback? onRefresh;
  final double? itemExtent;
  final Color? loadingBackgroundColor;
  final SliverGridDelegate delegate;
  final Widget? firstPageErrorIndicatorBuilder;
  /// Builder function to create the widget displayed when there's an error loading next page
  /// This controls WHAT is displayed (the content/widget)
  /// Use [showNewPageErrorIndicatorAsGridChild] to control WHERE it's displayed (as grid child or footer)
  final Widget? newPageErrorIndicatorBuilder;

  const CustomSliverGridView({
    super.key,
    required this.controller,
    required this.builder,
    required this.delegate,
    this.emptyWidget,
    this.shrinkWrapFirstPageIndicators = false,
    this.showNewPageProgressIndicatorAsGridChild,
    this.onRefresh,
    this.itemExtent,
    this.loadingBackgroundColor,
    this.firstPageProgressIndicator,
    this.newPageProgressIndicatorBuilder,
    this.firstPageErrorIndicatorBuilder,
    this.newPageErrorIndicatorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    // In version 5.x, use PagingListener for better state management
    return PagingListener<int, T>(
      controller: controller,
      builder: (context, state, fetchNextPage) {
        return PagedSliverGrid<int, T>(
          state: state,
          fetchNextPage: fetchNextPage,
          shrinkWrapFirstPageIndicators: shrinkWrapFirstPageIndicators,
          showNewPageProgressIndicatorAsGridChild:
              showNewPageProgressIndicatorAsGridChild ?? true,
          // Error indicator: show at bottom (footer), not as grid child
          showNewPageErrorIndicatorAsGridChild: false,
          // "No more items" indicator: show as grid child
          showNoMoreItemsIndicatorAsGridChild: true,
          builderDelegate: PagedChildBuilderDelegate<T>(
            itemBuilder: builder,
            newPageProgressIndicatorBuilder: (_) =>
                buildNewPageLoadingIndicator(newPageProgressIndicatorBuilder),
            noItemsFoundIndicatorBuilder: (_) => emptyWidget ?? const EmptyWidget(),
            firstPageProgressIndicatorBuilder: (_) =>
                buildFirstPageLoadingIndicator(
                  customIndicator: firstPageProgressIndicator,
                  backgroundColor: loadingBackgroundColor,
                ),
            firstPageErrorIndicatorBuilder: (_) =>
                buildFirstPageErrorIndicator(
                  controller: controller,
                  customIndicator: firstPageErrorIndicatorBuilder,
                  onRefresh: onRefresh,
                ),
            newPageErrorIndicatorBuilder: (_) =>
                buildNewPageErrorIndicator(
                  controller: controller,
                  customIndicator: newPageErrorIndicatorBuilder,
                ),
          ),
          gridDelegate: delegate,
        );
      },
    );
  }
}

class CustomGridView<T> extends StatelessWidget with _PagingIndicatorBuilder<T> {
  final PagingController<int, T> controller;
  final Widget Function(BuildContext, T, int) builder;
  final Widget? emptyWidget;
  final Widget? firstPageProgressIndicator;
  final Widget? newPageProgressIndicatorBuilder;
  final Widget? newPageErrorIndicatorBuilder;
  final bool shrinkWrapFirstPageIndicators;
  final VoidCallback? onRefresh;
  final double? itemExtent;
  final Color? loadingBackgroundColor;
  final SliverGridDelegate delegate;

  const CustomGridView({
    super.key,
    required this.controller,
    required this.builder,
    required this.delegate,
    this.emptyWidget,
    this.shrinkWrapFirstPageIndicators = false,
    this.onRefresh,
    this.itemExtent,
    this.loadingBackgroundColor,
    this.firstPageProgressIndicator,
    this.newPageProgressIndicatorBuilder,
    this.newPageErrorIndicatorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    // In version 5.x, use PagingListener for better state management
    return PagingListener<int, T>(
      controller: controller,
      builder: (context, state, fetchNextPage) {
        return PagedGridView<int, T>(
          state: state,
          fetchNextPage: fetchNextPage,
          builderDelegate: PagedChildBuilderDelegate<T>(
            itemBuilder: builder,
            noItemsFoundIndicatorBuilder: (_) => emptyWidget ?? const EmptyWidget(),
            firstPageProgressIndicatorBuilder: (_) =>
                buildFirstPageLoadingIndicator(
                  customIndicator: firstPageProgressIndicator,
                  backgroundColor: loadingBackgroundColor,
                ),
            firstPageErrorIndicatorBuilder: (_) =>
                buildFirstPageErrorIndicator(
                  controller: controller,
                  onRefresh: onRefresh,
                ),
            newPageProgressIndicatorBuilder: (_) =>
                buildNewPageLoadingIndicator(newPageProgressIndicatorBuilder),
            newPageErrorIndicatorBuilder: (_) =>
                buildNewPageErrorIndicator(
                  controller: controller,
                  customIndicator: newPageErrorIndicatorBuilder,
                ),
          ),
          gridDelegate: delegate,
        );
      },
    );
  }
}
