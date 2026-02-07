import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/avatar.dart';

class DecisionQueuePanel extends StatelessWidget {
  final List<DashboardDecisionItem> decisions;

  const DecisionQueuePanel({super.key, required this.decisions});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Decision Queue', style: AppTypography.h4),
              const Spacer(),
              TextButton(
                onPressed: () => context.go(Routes.decisions),
                child: const Text('View Queue'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (decisions.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(
                child: Text(
                  'No pending decisions',
                  style: AppTypography.bodySmall,
                ),
              ),
            )
          else
            ...decisions.take(3).map((d) => _DecisionQueueItem(decision: d)),
        ],
      ),
    );
  }
}

class _DecisionQueueItem extends StatelessWidget {
  final DashboardDecisionItem decision;

  const _DecisionQueueItem({required this.decision});

  Color get _priorityColor {
    switch (decision.priority?.toUpperCase()) {
      case 'BLOCKING':
        return AppColors.error;
      case 'HIGH':
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          // Priority dot
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _priorityColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Title and assignee
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  decision.title,
                  style: AppTypography.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (decision.assigneeName != null)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xxs),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _priorityColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Text(
                        decision.assigneeName!,
                        style: AppTypography.labelSmall.copyWith(
                          color: _priorityColor,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Waiting time
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: decision.slaBreached
                  ? AppColors.error.withOpacity(0.1)
                  : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (decision.slaBreached)
                  const Padding(
                    padding: EdgeInsets.only(right: 4),
                    child:
                        Icon(Icons.local_fire_department, size: 12, color: AppColors.error),
                  ),
                Text(
                  decision.waitingTimeFormatted,
                  style: AppTypography.labelSmall.copyWith(
                    color: decision.slaBreached
                        ? AppColors.error
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Assignee large avatar on right
          if (decision.assigneeName != null)
            ZAvatar(
              name: decision.assigneeName!,
              imageUrl: decision.assigneeAvatarUrl,
              size: 40,
            ),
        ],
      ),
    );
  }
}
