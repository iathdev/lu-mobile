import 'package:flutter/material.dart';
import 'package:lu_mobile/core/network/api_exception.dart';
import 'package:lu_mobile/core/theme/app_spacing.dart';

/// Full-screen error state with retry button.
class ErrorView extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry;

  const ErrorView({
    super.key,
    required this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final (icon, title, subtitle) = _resolveError(error);

    return Center(
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  (IconData, String, String) _resolveError(Object error) {
    if (error is NetworkException) {
      return (
        Icons.wifi_off_rounded,
        'No Connection',
        'Check your internet connection and try again.',
      );
    }
    if (error is ServiceUnavailableException) {
      return (
        Icons.cloud_off_rounded,
        'Service Unavailable',
        'The server is temporarily unavailable. Please try again later.',
      );
    }
    if (error is UnauthorizedException) {
      return (
        Icons.lock_outline_rounded,
        'Session Expired',
        'Please sign in again.',
      );
    }
    return (
      Icons.error_outline_rounded,
      'Something Went Wrong',
      'An unexpected error occurred. Please try again.',
    );
  }
}
