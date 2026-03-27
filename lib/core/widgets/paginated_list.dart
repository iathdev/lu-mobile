import 'package:flutter/material.dart';
import 'package:lu_mobile/core/theme/app_spacing.dart';

/// Infinite scroll list that calls [onLoadMore] when near the bottom.
class PaginatedList<T> extends StatelessWidget {
  final List<T> items;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget? header;
  final EdgeInsets? padding;

  const PaginatedList({
    super.key,
    required this.items,
    required this.hasMore,
    required this.isLoadingMore,
    required this.onLoadMore,
    required this.itemBuilder,
    this.header,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.extentAfter < 200 &&
            hasMore &&
            !isLoadingMore) {
          onLoadMore();
        }
        return false;
      },
      child: ListView.builder(
        padding: padding ?? AppSpacing.pagePadding,
        itemCount: items.length + (hasMore ? 1 : 0) + (header != null ? 1 : 0),
        itemBuilder: (context, index) {
          if (header != null && index == 0) {
            return header!;
          }
          final itemIndex = header != null ? index - 1 : index;
          if (itemIndex >= items.length) {
            return const Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return itemBuilder(context, items[itemIndex], itemIndex);
        },
      ),
    );
  }
}
