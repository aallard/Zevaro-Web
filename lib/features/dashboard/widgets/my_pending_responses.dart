import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/loading_indicator.dart';

class MyPendingResponses extends ConsumerWidget {
  const MyPendingResponses({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final responsesAsync = ref.watch(myPendingResponsesProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.pending_actions,
                  color: AppColors.warning,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text('Awaiting Your Input', style: AppTypography.h4.copyWith(
                  color: theme.colorScheme.onSurface,
                )),
                const Spacer(),
                TextButton(
                  onPressed: () => context.go(Routes.stakeholders),
                  child: const Text('View all'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            responsesAsync.when(
              data: (responses) {
                if (responses.isEmpty) {
                  return _buildEmptyState(context);
                }
                final pending = responses.take(5).toList();
                return Column(
                  children: pending
                      .map((r) => _buildResponseItem(context, r))
                      .toList(),
                );
              },
              loading: () => const LoadingIndicator(),
              error: (e, _) => Text('Error: $e'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          const Icon(
            Icons.thumb_up_outlined,
            size: 48,
            color: AppColors.success,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            "You're responsive!",
            style: AppTypography.labelLarge.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          Text(
            'No pending responses needed',
            style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }

  Widget _buildResponseItem(BuildContext context, StakeholderResponse response) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => context.go(Routes.decisionById(response.decisionId)),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.xs,
        ),
        child: Row(
          children: [
            Icon(
              response.withinSla ? Icons.schedule : Icons.warning_amber,
              color:
                  response.withinSla ? theme.colorScheme.onSurface.withOpacity(0.6) : theme.colorScheme.error,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    response.decisionTitle ?? 'Decision',
                    style: AppTypography.labelMedium.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Waiting ${response.responseTimeDisplay}',
                    style: AppTypography.bodySmall.copyWith(
                      color: response.withinSla
                          ? theme.colorScheme.onSurface.withOpacity(0.5)
                          : theme.colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}
