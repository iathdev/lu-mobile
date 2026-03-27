import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lu_mobile/core/router/route_paths.dart';
import 'package:lu_mobile/core/theme/app_colors.dart';
import 'package:lu_mobile/core/theme/app_spacing.dart';
import 'package:lu_mobile/features/vocabulary/data/mock_data.dart';

class HskLevelPage extends StatelessWidget {
  const HskLevelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HSK Levels'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.go(RoutePaths.search),
          ),
        ],
      ),
      body: Padding(
        padding: AppSpacing.pagePadding,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.85,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
          ),
          itemCount: hskLevels.length,
          itemBuilder: (context, index) {
            final level = hskLevels[index];
            return _HskLevelCard(level: level);
          },
        ),
      ),
    );
  }
}

class _HskLevelCard extends StatelessWidget {
  final HskLevelInfo level;

  const _HskLevelCard({required this.level});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.hskLevelColors[level.level - 1];
    final isPro = level.accessTier == 'pro';

    return GestureDetector(
      onTap: () => context.push(RoutePaths.hskLevelPath(level.level)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppSpacing.borderRadiusMd,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color, color.withValues(alpha: 0.7)],
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'HSK',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  Text(
                    '${level.level}',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${level.totalWords} words',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                  ),
                  Text(
                    level.stage,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 10,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            if (isPro)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.proBadge,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Text(
                    'PRO',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 9,
                        ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
