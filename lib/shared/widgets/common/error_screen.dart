import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class ErrorScreen extends StatelessWidget {
  final String? error;
  final String? errorCode;
  final VoidCallback? onRetry;

  const ErrorScreen({
    super.key,
    this.error,
    this.errorCode,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Error code (if provided)
              if (errorCode != null) ...[
                Text(
                  errorCode!,
                  style: AppTypography.h1.copyWith(
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],

              // Title
              Text(
                'Something went wrong',
                style: AppTypography.h2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),

              // Error message
              Text(
                error ?? 'An unexpected error occurred. Please try again.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (onRetry != null) ...[
                    ElevatedButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                    ),
                    const SizedBox(width: AppSpacing.md),
                  ],
                  OutlinedButton.icon(
                    onPressed: () => context.go(Routes.dashboard),
                    icon: const Icon(Icons.home),
                    label: const Text('Go Home'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 404 Not Found Screen
class NotFoundScreen extends StatelessWidget {
  final String? path;

  const NotFoundScreen({super.key, this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 404 icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.search_off,
                  size: 64,
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // 404
              Text(
                '404',
                style: AppTypography.h1.copyWith(
                  fontSize: 72,
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Title
              Text(
                'Page Not Found',
                style: AppTypography.h2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),

              // Message
              Text(
                path != null
                    ? 'The page "$path" could not be found.'
                    : 'The page you\'re looking for doesn\'t exist.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Go home button
              ElevatedButton.icon(
                onPressed: () => context.go(Routes.dashboard),
                icon: const Icon(Icons.home),
                label: const Text('Go to Dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
