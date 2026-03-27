import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lu_mobile/core/router/route_paths.dart';
import 'package:lu_mobile/core/theme/app_colors.dart';
import 'package:lu_mobile/core/theme/app_spacing.dart';

/// Call-to-action banner for upgrading to Pro.
class UpgradeCta extends StatelessWidget {
  final String message;

  const UpgradeCta({
    super.key,
    this.message = 'Unlock this feature with Pro',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: AppSpacing.borderRadiusMd,
      ),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, color: AppColors.accent, size: 32),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => context.push(RoutePaths.upgrade),
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
            ),
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );
  }
}
