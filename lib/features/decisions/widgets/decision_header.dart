import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import 'urgency_badge.dart';
import 'sla_indicator.dart';

class DecisionHeader extends StatelessWidget {
  final Decision decision;
  final VoidCallback? onEscalate;

  const DecisionHeader({
    super.key,
    required this.decision,
    this.onEscalate,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(decision.status);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status + Type row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getStatusIcon(decision.status),
                        size: 14,
                        color: statusColor,
                      ),
                      const SizedBox(width: AppSpacing.xxs),
                      Text(
                        decision.status.displayName,
                        style: AppTypography.labelMedium.copyWith(
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: Text(
                    decision.type.displayName,
                    style: AppTypography.labelMedium,
                  ),
                ),
                const Spacer(),
                UrgencyBadge(urgency: decision.urgency),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Title
            Text(
              decision.title,
              style: AppTypography.h2,
            ),
            const SizedBox(height: AppSpacing.md),

            // SLA + Actions
            Row(
              children: [
                SlaIndicator(decision: decision),
                const Spacer(),
                if (decision.status != DecisionStatus.DECIDED &&
                    onEscalate != null)
                  TextButton.icon(
                    onPressed: onEscalate,
                    icon: const Icon(Icons.trending_up, size: 16),
                    label: const Text('Escalate'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.warning,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(DecisionStatus status) {
    switch (status) {
      case DecisionStatus.NEEDS_INPUT:
        return AppColors.error;
      case DecisionStatus.UNDER_DISCUSSION:
        return AppColors.warning;
      case DecisionStatus.DECIDED:
        return AppColors.success;
    }
  }

  IconData _getStatusIcon(DecisionStatus status) {
    switch (status) {
      case DecisionStatus.NEEDS_INPUT:
        return Icons.pending_outlined;
      case DecisionStatus.UNDER_DISCUSSION:
        return Icons.forum_outlined;
      case DecisionStatus.DECIDED:
        return Icons.check_circle_outline;
    }
  }
}
