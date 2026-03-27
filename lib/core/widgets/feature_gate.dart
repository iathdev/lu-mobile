import 'package:flutter/material.dart';
import 'package:lu_mobile/core/theme/app_colors.dart';
import 'package:lu_mobile/core/theme/app_spacing.dart';
import 'package:lu_mobile/core/widgets/upgrade_cta.dart';

/// Wraps a child widget with entitlement check.
/// Shows [child] if entitled, otherwise shows a locked overlay with upgrade CTA.
class FeatureGate extends StatelessWidget {
  final bool isEntitled;
  final Widget child;
  final String? lockedMessage;

  const FeatureGate({
    super.key,
    required this.isEntitled,
    required this.child,
    this.lockedMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (isEntitled) return child;

    return Stack(
      children: [
        // Blurred/dimmed content
        Opacity(
          opacity: 0.3,
          child: IgnorePointer(child: child),
        ),
        // Lock overlay
        Positioned.fill(
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.proBadge.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_rounded,
                    size: 48,
                    color: AppColors.proBadge,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                UpgradeCta(
                  message: lockedMessage ?? 'This feature requires Pro',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
