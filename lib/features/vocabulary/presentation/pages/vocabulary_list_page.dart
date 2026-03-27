import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lu_mobile/core/domain/pagination.dart';
import 'package:lu_mobile/core/network/providers.dart';
import 'package:lu_mobile/core/router/route_paths.dart';
import 'package:lu_mobile/core/theme/app_colors.dart';
import 'package:lu_mobile/core/theme/app_spacing.dart';
import 'package:lu_mobile/core/widgets/error_view.dart';
import 'package:lu_mobile/core/widgets/loading_view.dart';
import 'package:lu_mobile/features/vocabulary/data/models/vocabulary_model.dart';
import 'package:lu_mobile/features/vocabulary/data/repositories/vocabulary_repository.dart';

class VocabularyListPage extends ConsumerStatefulWidget {
  final int? hskLevel;
  final String? topicSlug;

  const VocabularyListPage({super.key, this.hskLevel, this.topicSlug});

  @override
  ConsumerState<VocabularyListPage> createState() => _VocabularyListPageState();
}

class _VocabularyListPageState extends ConsumerState<VocabularyListPage> {
  final List<VocabularyListItem> _items = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  Object? _error;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _loadPage();
  }

  Future<void> _loadPage() async {
    final client = ref.read(apiClientProvider);
    final repo = VocabularyRepository(client);

    try {
      final result = await repo.listByHskLevel(
        widget.hskLevel ?? 1,
        params: PaginationParams(page: _page),
      );
      if (!mounted) return;
      setState(() {
        _items.addAll(result.items);
        _hasMore = result.hasMore;
        _isLoading = false;
        _isLoadingMore = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  void _loadMore() {
    if (_isLoadingMore || !_hasMore) return;
    setState(() => _isLoadingMore = true);
    _page++;
    _loadPage();
  }

  Future<void> _refresh() async {
    setState(() {
      _items.clear();
      _page = 1;
      _hasMore = true;
      _isLoading = true;
      _error = null;
    });
    await _loadPage();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.hskLevel != null
        ? 'HSK ${widget.hskLevel}'
        : 'Topic: ${widget.topicSlug}';
    final color = widget.hskLevel != null
        ? AppColors.hskLevelColors[(widget.hskLevel! - 1).clamp(0, 8)]
        : Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _isLoading
          ? const LoadingView()
          : _error != null
              ? ErrorView(error: _error!, onRetry: _refresh)
              : _items.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.menu_book_outlined,
                              size: 64,
                              color: color.withValues(alpha: 0.4)),
                          const SizedBox(height: AppSpacing.md),
                          Text('No vocabulary data yet',
                              style: Theme.of(context).textTheme.bodyLarge),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _refresh,
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (n) {
                          if (n is ScrollEndNotification &&
                              n.metrics.extentAfter < 200) {
                            _loadMore();
                          }
                          return false;
                        },
                        child: ListView.separated(
                          padding:
                              const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                          itemCount: _items.length + (_hasMore ? 1 : 0),
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            if (index >= _items.length) {
                              return const Padding(
                                padding: EdgeInsets.all(AppSpacing.md),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            }
                            final item = _items[index];
                            return _VocabularyTile(
                                item: item, accentColor: color);
                          },
                        ),
                      ),
                    ),
    );
  }
}

class _VocabularyTile extends StatelessWidget {
  final VocabularyListItem item;
  final Color accentColor;

  const _VocabularyTile({required this.item, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      leading: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: accentColor.withValues(alpha: 0.1),
          borderRadius: AppSpacing.borderRadiusSm,
        ),
        alignment: Alignment.center,
        child: Text(
          item.hanzi,
          style: TextStyle(
            fontSize: item.hanzi.length > 2 ? 16 : 22,
            fontWeight: FontWeight.w700,
            color: accentColor,
          ),
        ),
      ),
      title: Text(
        item.pinyin ?? '',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
      subtitle: Text(
        item.meaningVi ?? item.meaningEn ?? '',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.push(RoutePaths.vocabularyDetailPath(item.id)),
    );
  }
}
