import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/loading_indicator.dart';

class DecisionQueuePreview extends ConsumerWidget {
  const DecisionQueuePreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final decisionsAsync = ref.watch(decisionQueueProvider());

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.how_to_vote_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text('Decision Queue', style: AppTypography.h4.copyWith(
                  color: theme.colorScheme.onSurface,
                )),
                const Spacer(),
                TextButton(
                  onPressed: () => context.go(Routes.decisions),
                  child: const Text('View all'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            decisionsAsync.when(
              data: (decisions) {
                if (decisions.isEmpty) {
                  return _buildEmptyState(context);
                }
                // Show top 5 most urgent
                final urgent = decisions.take(5).toList();
                return Column(
                  children:
                      urgent.map((d) => _buildDecisionItem(context, d)).toList(),
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
            Icons.check_circle_outline,
            size: 48,
            color: AppColors.success,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'All caught up!',
            style: AppTypography.labelLarge.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          Text(
            'No pending decisions',
            style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }

  Widget _buildDecisionItem(BuildContext context, Decision decision) {
    final theme = Theme.of(context);
    final urgencyColor =
        Color(int.parse(decision.urgency.color.replaceFirst('#', '0xFF')));

    return InkWell(
      onTap: () => context.go(Routes.decisionById(decision.id)),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.xs,
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: urgencyColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    decision.title,
                    style: AppTypography.labelMedium.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    decision.slaStatusDisplay,
                    style: AppTypography.bodySmall.copyWith(
                      color: decision.isSlaBreached
                          ? theme.colorScheme.error
                          : theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: urgencyColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Text(
                decision.urgency.displayName,
                style: AppTypography.labelSmall.copyWith(
                  color: urgencyColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
