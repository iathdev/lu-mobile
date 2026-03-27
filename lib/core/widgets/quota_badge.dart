import 'package:flutter/material.dart';
import 'package:lu_mobile/core/theme/app_colors.dart';
import 'package:lu_mobile/core/theme/app_spacing.dart';

/// Badge showing quota usage, e.g., "2/3 remaining".
class QuotaBadge extends StatelessWidget {
  final int used;
  final int limit;
  final String? label;

  const QuotaBadge({
    super.key,
    required this.used,
    required this.limit,
    this.label,
  });

  bool get isUnlimited => limit < 0;
  bool get isExceeded => !isUnlimited && used >= limit;
  int get remaining => isUnlimited ? -1 : limit - used;

  @override
  Widget build(BuildContext context) {
    final color = isExceeded
        ? AppColors.error
        : remaining <= 1
            ? AppColors.warning
            : Theme.of(context).colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppSpacing.borderRadiusSm,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        isUnlimited
            ? (label ?? 'Unlimited')
            : isExceeded
                ? (label ?? 'Limit reached')
                : '${label ?? ''} $remaining/$limit',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
      ),
    );
  }
}
