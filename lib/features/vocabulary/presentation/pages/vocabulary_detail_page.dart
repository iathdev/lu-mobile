import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lu_mobile/core/network/providers.dart';
import 'package:lu_mobile/core/theme/app_colors.dart';
import 'package:lu_mobile/core/theme/app_spacing.dart';
import 'package:lu_mobile/core/widgets/error_view.dart';
import 'package:lu_mobile/core/widgets/loading_view.dart';
import 'package:lu_mobile/features/vocabulary/data/models/vocabulary_model.dart';
import 'package:lu_mobile/features/vocabulary/data/repositories/vocabulary_repository.dart';

class VocabularyDetailPage extends ConsumerStatefulWidget {
  final String id;

  const VocabularyDetailPage({super.key, required this.id});

  @override
  ConsumerState<VocabularyDetailPage> createState() => _VocabularyDetailPageState();
}

class _VocabularyDetailPageState extends ConsumerState<VocabularyDetailPage> {
  VocabularyDetail? _detail;
  bool _isLoading = true;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final client = ref.read(apiClientProvider);
    final repo = VocabularyRepository(client);
    try {
      final detail = await repo.getDetail(widget.id);
      if (!mounted) return;
      setState(() {
        _detail = detail;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: const LoadingView(),
      );
    }
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: ErrorView(error: _error!, onRetry: _load),
      );
    }

    final detail = _detail!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text('HSK ${detail.hskLevel ?? ''}'),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _HanziSection(detail: detail),
            const SizedBox(height: AppSpacing.lg),
            _MeaningSection(detail: detail),
            const SizedBox(height: AppSpacing.lg),
            if (detail.radicals.isNotEmpty || detail.strokeCount != null)
              _CharacterInfoSection(detail: detail),
            if (detail.examples.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              _ExamplesSection(examples: detail.examples),
            ],
            if (detail.topics.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              _TopicsSection(topics: detail.topics),
            ],
            if (detail.grammarPoints.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              _GrammarSection(points: detail.grammarPoints),
            ],
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

// ---- Widgets (same as before, kept for completeness) ----

class _HanziSection extends StatelessWidget {
  final VocabularyDetail detail;
  const _HanziSection({required this.detail});

  @override
  Widget build(BuildContext context) {
    final color = detail.hskLevel != null
        ? AppColors.hskLevelColors[(detail.hskLevel! - 1).clamp(0, 8)]
        : Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: AppSpacing.borderRadiusLg,
      ),
      child: Column(
        children: [
          Text(detail.hanzi,
              style: TextStyle(fontSize: 72, fontWeight: FontWeight.w700, color: color, height: 1.2)),
          const SizedBox(height: AppSpacing.sm),
          Text(detail.pinyin ?? '',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant)),
          if (detail.recognitionOnly)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Chip(
                label: const Text('Recognition only'),
                backgroundColor: Colors.orange.withValues(alpha: 0.1),
                side: BorderSide.none,
                labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.orange),
              ),
            ),
        ],
      ),
    );
  }
}

class _MeaningSection extends StatelessWidget {
  final VocabularyDetail detail;
  const _MeaningSection({required this.detail});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Meaning', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        if (detail.meaningVi != null) _MeaningRow(label: 'Vietnamese', text: detail.meaningVi!),
        if (detail.meaningEn != null) _MeaningRow(label: 'English', text: detail.meaningEn!),
      ],
    );
  }
}

class _MeaningRow extends StatelessWidget {
  final String label;
  final String text;
  const _MeaningRow({required this.label, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(children: [
        SizedBox(width: 100, child: Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant))),
        Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyLarge)),
      ]),
    );
  }
}

class _CharacterInfoSection extends StatelessWidget {
  final VocabularyDetail detail;
  const _CharacterInfoSection({required this.detail});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Character Info', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
          if (detail.strokeCount != null) _InfoChip(icon: Icons.edit, label: '${detail.strokeCount} strokes'),
          if (detail.frequencyRank != null) _InfoChip(icon: Icons.trending_up, label: 'Rank #${detail.frequencyRank}'),
          ...detail.radicals.map((r) => _InfoChip(icon: Icons.auto_awesome, label: r)),
        ]),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: AppSpacing.borderRadiusSm),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
      ]),
    );
  }
}

class _ExamplesSection extends StatelessWidget {
  final List<ExampleDto> examples;
  const _ExamplesSection({required this.examples});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Examples', style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: AppSpacing.sm),
      ...examples.map((e) => Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: AppSpacing.cardPadding,
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: AppSpacing.borderRadiusSm),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(e.sentenceCn, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
              if (e.sentenceVi != null) ...[
                const SizedBox(height: 4),
                Text(e.sentenceVi!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ],
            ]),
          )),
    ]);
  }
}

class _TopicsSection extends StatelessWidget {
  final List<TopicDto> topics;
  const _TopicsSection({required this.topics});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Topics', style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: AppSpacing.sm),
      Wrap(spacing: AppSpacing.sm, children: topics.map((t) => Chip(label: Text(t.nameVi ?? t.nameEn ?? t.slug), avatar: const Icon(Icons.topic, size: 16))).toList()),
    ]);
  }
}

class _GrammarSection extends StatelessWidget {
  final List<GrammarPointDto> points;
  const _GrammarSection({required this.points});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Grammar', style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: AppSpacing.sm),
      ...points.map((gp) => Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: AppSpacing.cardPadding,
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.06),
              borderRadius: AppSpacing.borderRadiusSm,
              border: Border.all(color: AppColors.info.withValues(alpha: 0.2)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(gp.pattern, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.info, fontWeight: FontWeight.w600)),
              if (gp.rule != null) ...[const SizedBox(height: 4), Text(gp.rule!, style: Theme.of(context).textTheme.bodyMedium)],
              if (gp.exampleCn != null) ...[const SizedBox(height: 8), Text(gp.exampleCn!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500))],
              if (gp.exampleVi != null) Text(gp.exampleVi!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ]),
          )),
    ]);
  }
}
