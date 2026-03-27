import 'package:flutter/material.dart';
import 'package:lu_mobile/core/theme/app_colors.dart';
import 'package:lu_mobile/core/theme/app_spacing.dart';
import 'package:lu_mobile/features/ocr/data/models/ocr_result_model.dart';

class OcrConfirmPage extends StatefulWidget {
  final List<OcrNewItem> newItems;
  final List<OcrLowConfidenceItem> lowConfidenceItems;

  const OcrConfirmPage({
    super.key,
    this.newItems = const [],
    this.lowConfidenceItems = const [],
  });

  @override
  State<OcrConfirmPage> createState() => _OcrConfirmPageState();
}

class _OcrConfirmPageState extends State<OcrConfirmPage> {
  bool _isSaving = false;
  bool _saved = false;

  int get totalItems => widget.newItems.length + widget.lowConfidenceItems.length;

  Future<void> _save() async {
    setState(() => _isSaving = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() {
      _isSaving = false;
      _saved = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_saved) return _buildSuccess(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Import')),
      body: _isSaving
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: AppSpacing.md),
                  Text('Saving vocabulary...'),
                ],
              ),
            )
          : ListView(
              padding: AppSpacing.pagePadding,
              children: [
                // Summary
                Container(
                  padding: AppSpacing.cardPadding,
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.06),
                    borderRadius: AppSpacing.borderRadiusMd,
                    border: Border.all(
                        color: AppColors.success.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.playlist_add_check,
                          color: AppColors.success, size: 32),
                      const SizedBox(width: AppSpacing.md),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$totalItems words to import',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'These will be added to your vocabulary',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Folder selection
                ListTile(
                  leading: const Icon(Icons.folder_outlined),
                  title: const Text('Add to folder'),
                  subtitle: const Text('None selected'),
                  trailing: const Icon(Icons.chevron_right),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppSpacing.borderRadiusSm,
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.outline),
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Folder selection — coming soon')),
                    );
                  },
                ),

                const SizedBox(height: AppSpacing.lg),

                // Items list
                Text('Words to import',
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: AppSpacing.sm),

                ...widget.newItems.map((item) => _ConfirmTile(
                      hanzi: item.hanzi,
                      confidence: item.confidence,
                      isNew: true,
                    )),
                ...widget.lowConfidenceItems.map((item) => _ConfirmTile(
                      hanzi: item.selectedCandidate ?? item.hanzi,
                      confidence: item.confidence,
                      isNew: true,
                      isLowConfidence: true,
                    )),

                const SizedBox(height: 100),
              ],
            ),
      bottomSheet: !_isSaving && !_saved
          ? Container(
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
                  child: ElevatedButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save),
                    label: Text('Save $totalItems Words'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildSuccess(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: AppSpacing.pagePadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 72,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                '$totalItems words saved!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'New vocabulary has been added to your collection',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                onPressed: () {
                  // Pop back to scan tab
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('Back to Home'),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: () {
                  // Pop to scan page for another scan
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('Scan Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConfirmTile extends StatelessWidget {
  final String hanzi;
  final double confidence;
  final bool isNew;
  final bool isLowConfidence;

  const _ConfirmTile({
    required this.hanzi,
    required this.confidence,
    this.isNew = false,
    this.isLowConfidence = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isLowConfidence ? AppColors.warning : AppColors.success;
    final pct = (confidence * 100).toInt();

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.04),
        borderRadius: AppSpacing.borderRadiusSm,
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Text(
            hanzi,
            style: TextStyle(
              fontSize: hanzi.length > 2 ? 18 : 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Text(
              '$pct%',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: color),
            ),
          ),
          if (isLowConfidence) ...[
            const SizedBox(width: 4),
            Icon(Icons.warning_amber_rounded, size: 16, color: color),
          ],
        ],
      ),
    );
  }
}
