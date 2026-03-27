import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lu_mobile/core/network/providers.dart';
import 'package:lu_mobile/core/router/route_paths.dart';
import 'package:lu_mobile/core/theme/app_spacing.dart';
import 'package:lu_mobile/features/vocabulary/data/models/vocabulary_model.dart';
import 'package:lu_mobile/features/vocabulary/data/repositories/vocabulary_repository.dart';

class VocabularySearchPage extends ConsumerStatefulWidget {
  const VocabularySearchPage({super.key});

  @override
  ConsumerState<VocabularySearchPage> createState() => _VocabularySearchPageState();
}

class _VocabularySearchPageState extends ConsumerState<VocabularySearchPage> {
  final _controller = TextEditingController();
  List<VocabularyListItem> _results = [];
  bool _isSearching = false;
  Timer? _debounce;

  void _onSearch(String query) {
    _debounce?.cancel();
    if (query.isEmpty) {
      setState(() {
        _results = [];
        _isSearching = false;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 400), () => _doSearch(query));
  }

  Future<void> _doSearch(String query) async {
    setState(() => _isSearching = true);
    final client = ref.read(apiClientProvider);
    final repo = VocabularyRepository(client);
    try {
      final result = await repo.search(query);
      if (!mounted) return;
      setState(() {
        _results = result.items;
        _isSearching = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSearching = false);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search hanzi, pinyin, or meaning...',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
          ),
          onChanged: _onSearch,
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                _onSearch('');
              },
            ),
        ],
      ),
      body: _controller.text.isEmpty
          ? Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.search, size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
                const SizedBox(height: AppSpacing.md),
                Text('Search across hanzi, pinyin, or meaning',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ]),
            )
          : _isSearching
              ? const Center(child: CircularProgressIndicator())
              : _results.isEmpty
                  ? Center(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.search_off, size: 64,
                            color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
                        const SizedBox(height: AppSpacing.md),
                        Text('No results found', style: Theme.of(context).textTheme.bodyLarge),
                      ]),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      itemCount: _results.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = _results[index];
                        return ListTile(
                          leading: Text(item.hanzi, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                          title: Text(item.pinyin ?? ''),
                          subtitle: Text(item.meaningVi ?? item.meaningEn ?? ''),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => context.push(RoutePaths.vocabularyDetailPath(item.id)),
                        );
                      },
                    ),
    );
  }
}
