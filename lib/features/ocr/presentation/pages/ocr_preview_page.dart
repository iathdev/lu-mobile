import 'package:flutter/material.dart';
import 'package:lu_mobile/core/theme/app_colors.dart';
import 'package:lu_mobile/core/theme/app_spacing.dart';
import 'package:lu_mobile/features/ocr/data/models/ocr_result_model.dart';
import 'package:lu_mobile/features/ocr/presentation/pages/ocr_confirm_page.dart';

class OcrPreviewPage extends StatefulWidget {
  final OcrScanResult result;

  const OcrPreviewPage({super.key, required this.result});

  @override
  State<OcrPreviewPage> createState() => _OcrPreviewPageState();
}

class _OcrPreviewPageState extends State<OcrPreviewPage> {
  late final OcrScanResult result = widget.result;

  int get selectedNewCount => result.newItems.where((i) => i.selected).length;
  int get selectedLowCount =>
      result.lowConfidenceItems.where((i) => i.selected).length;
  int get totalSelected => selectedNewCount + selectedLowCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Results'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: Chip(
              label: Text(
                '${result.metadata.processingTimeMs}ms',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              avatar: const Icon(Icons.timer_outlined, size: 14),
              visualDensity: VisualDensity.compact,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          // Summary header
          _SummaryHeader(result: result),

          // New items
          if (result.newItems.isNotEmpty) ...[
            _SectionHeader(
              title: 'New Words',
              subtitle: '${result.newItems.length} found',
              color: AppColors.success,
              icon: Icons.add_circle_outline,
            ),
            ...result.newItems.map((item) => _NewItemTile(
                  item: item,
                  onToggle: () => setState(() => item.selected = !item.selected),
                )),
          ],

          // Existing items
          if (result.existingItems.isNotEmpty) ...[
            _SectionHeader(
              title: 'Already Saved',
              subtitle: '${result.existingItems.length} found',
              color: AppColors.info,
              icon: Icons.check_circle_outline,
            ),
            ...result.existingItems
                .map((item) => _ExistingItemTile(item: item)),
          ],

          // Low confidence items
          if (result.lowConfidenceItems.isNotEmpty) ...[
            _SectionHeader(
              title: 'Needs Review',
              subtitle: '${result.lowConfidenceItems.length} uncertain',
              color: AppColors.warning,
              icon: Icons.help_outline,
            ),
            ...result.lowConfidenceItems.map((item) => _LowConfidenceTile(
                  item: item,
                  onToggle: () => setState(() => item.selected = !item.selected),
                  onSelectCandidate: (candidate) {
                    setState(() {
                      item.selectedCandidate = candidate;
                      item.selected = true;
                    });
                  },
                )),
          ],
        ],
      ),
      bottomSheet: _BottomAction(
        selectedCount: totalSelected,
        onConfirm: totalSelected > 0
            ? () {
                final selectedNew =
                    result.newItems.where((i) => i.selected).toList();
                final selectedLow = result.lowConfidenceItems
                    .where((i) => i.selected)
                    .toList();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => OcrConfirmPage(
                      newItems: selectedNew,
                      lowConfidenceItems: selectedLow,
                    ),
                  ),
                );
              }
            : null,
      ),
    );
  }
}

class _SummaryHeader extends StatelessWidget {
  final OcrScanResult result;

  const _SummaryHeader({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: AppSpacing.borderRadiusMd,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            value: '${result.totalDetected}',
            label: 'Detected',
            color: Theme.of(context).colorScheme.onSurface,
          ),
          _StatItem(
            value: '${result.newItems.length}',
            label: 'New',
            color: AppColors.success,
          ),
          _StatItem(
            value: '${result.existingItems.length}',
            label: 'Existing',
            color: AppColors.info,
          ),
          _StatItem(
            value: '${result.lowConfidenceItems.length}',
            label: 'Uncertain',
            color: AppColors.warning,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.md, AppSpacing.lg, AppSpacing.md, AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: color, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

class _NewItemTile extends StatelessWidget {
  final OcrNewItem item;
  final VoidCallback onToggle;

  const _NewItemTile({required this.item, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.1),
          borderRadius: AppSpacing.borderRadiusSm,
        ),
        alignment: Alignment.center,
        child: Text(
          item.hanzi,
          style: TextStyle(
            fontSize: item.hanzi.length > 2 ? 14 : 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      title: Text(item.hanzi),
      subtitle: _ConfidenceBar(confidence: item.confidence),
      trailing: Checkbox(
        value: item.selected,
        onChanged: (_) => onToggle(),
        activeColor: AppColors.success,
      ),
    );
  }
}

class _ExistingItemTile extends StatelessWidget {
  final OcrExistingItem item;

  const _ExistingItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.info.withValues(alpha: 0.1),
          borderRadius: AppSpacing.borderRadiusSm,
        ),
        alignment: Alignment.center,
        child: Text(
          item.hanzi,
          style: TextStyle(
            fontSize: item.hanzi.length > 2 ? 14 : 20,
            fontWeight: FontWeight.w700,
            color: AppColors.info,
          ),
        ),
      ),
      title: Text(item.hanzi),
      subtitle: Text(item.pinyin ?? ''),
      trailing: const Icon(Icons.check_circle, color: AppColors.info),
    );
  }
}

class _LowConfidenceTile extends StatelessWidget {
  final OcrLowConfidenceItem item;
  final VoidCallback onToggle;
  final ValueChanged<String> onSelectCandidate;

  const _LowConfidenceTile({
    required this.item,
    required this.onToggle,
    required this.onSelectCandidate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: AppSpacing.borderRadiusSm,
              border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
            ),
            alignment: Alignment.center,
            child: Text(
              item.selectedCandidate ?? item.hanzi,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.warning,
              ),
            ),
          ),
          title: Row(
            children: [
              Text(item.hanzi),
              const SizedBox(width: 8),
              Text(
                '${(item.confidence * 100).toInt()}%',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.warning,
                    ),
              ),
            ],
          ),
          subtitle: const Text('Did you mean?'),
          trailing: Checkbox(
            value: item.selected,
            onChanged: (_) => onToggle(),
            activeColor: AppColors.warning,
          ),
        ),
        // Candidate chips
        if (item.candidates.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(72, 0, AppSpacing.md, AppSpacing.sm),
            child: Wrap(
              spacing: AppSpacing.sm,
              children: item.candidates.map((c) {
                final isSelected = item.selectedCandidate == c;
                return ChoiceChip(
                  label: Text(c, style: const TextStyle(fontSize: 18)),
                  selected: isSelected,
                  onSelected: (_) => onSelectCandidate(c),
                  selectedColor: AppColors.warning.withValues(alpha: 0.2),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

class _ConfidenceBar extends StatelessWidget {
  final double confidence;

  const _ConfidenceBar({required this.confidence});

  @override
  Widget build(BuildContext context) {
    final pct = (confidence * 100).toInt();
    final color = confidence >= 0.9
        ? AppColors.confidenceHigh
        : confidence >= 0.75
            ? AppColors.confidenceMedium
            : AppColors.confidenceLow;

    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: confidence,
              backgroundColor: color.withValues(alpha: 0.15),
              color: color,
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$pct%',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
        ),
      ],
    );
  }
}

class _BottomAction extends StatelessWidget {
  final int selectedCount;
  final VoidCallback? onConfirm;

  const _BottomAction({required this.selectedCount, this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onConfirm,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(
              selectedCount > 0
                  ? 'Import $selectedCount Words'
                  : 'Select words to import',
            ),
          ),
        ),
      ),
    );
  }
}
