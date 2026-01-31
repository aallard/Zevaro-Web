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
    final decisionsAsync = ref.watch(decisionQueueProvider());

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.how_to_vote_outlined,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text('Decision Queue', style: AppTypography.h4),
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
                  return _buildEmptyState();
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

  Widget _buildEmptyState() {
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
            style: AppTypography.labelLarge,
          ),
          const Text(
            'No pending decisions',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildDecisionItem(BuildContext context, Decision decision) {
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
                    style: AppTypography.labelMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    decision.slaStatusDisplay,
                    style: AppTypography.bodySmall.copyWith(
                      color: decision.isSlaBreached
                          ? AppColors.error
                          : AppColors.textTertiary,
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
