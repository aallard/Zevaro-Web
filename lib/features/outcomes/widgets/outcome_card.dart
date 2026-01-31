import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import 'outcome_status_badge.dart';

class OutcomeCard extends StatelessWidget {
  final Outcome outcome;

  const OutcomeCard({super.key, required this.outcome});

  @override
  Widget build(BuildContext context) {
    final priorityColor =
        Color(int.parse(outcome.priority.color.replaceFirst('#', '0xFF')));

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go(Routes.outcomeById(outcome.id)),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: priorityColor, width: 4),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    OutcomeStatusBadge(status: outcome.status, compact: true),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Text(
                        outcome.priority.displayName,
                        style: AppTypography.labelSmall.copyWith(
                          color: priorityColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                // Title
                Text(
                  outcome.title,
                  style: AppTypography.labelLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),

                // Description
                if (outcome.description?.isNotEmpty ?? false)
                  Text(
                    outcome.description!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: AppSpacing.md),

                // Key Result Progress (overall)
                if (outcome.keyResults?.isNotEmpty ?? false) ...[
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusSm),
                          child: LinearProgressIndicator(
                            value: outcome.keyResultProgress / 100,
                            backgroundColor: AppColors.border,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getProgressColor(outcome.keyResultProgress),
                            ),
                            minHeight: 4,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        '${outcome.keyResultProgress.toStringAsFixed(0)}%',
                        style: AppTypography.labelSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],

                // Footer stats
                Row(
                  children: [
                    Icon(Icons.science_outlined,
                        size: 14, color: AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Text(
                      '${outcome.hypothesisCount}',
                      style: AppTypography.bodySmall,
                    ),
                    if (outcome.pendingDecisionCount > 0) ...[
                      const SizedBox(width: AppSpacing.xs),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${outcome.pendingDecisionCount} blocked',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.error,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                    const Spacer(),
                    Icon(Icons.flag_outlined,
                        size: 14, color: AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Text(
                      '${outcome.keyResults?.length ?? 0} KRs',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress >= 100) return AppColors.success;
    if (progress >= 70) return AppColors.success;
    if (progress >= 40) return AppColors.warning;
    return AppColors.primary;
  }
}
