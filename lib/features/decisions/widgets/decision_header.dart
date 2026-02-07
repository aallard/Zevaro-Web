import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/avatar.dart';
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
            // Badges row: Priority, Type, Timestamp, Escalate
            Row(
              children: [
                // Priority badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: _getPriorityColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: Text(
                    _getPriorityLabel(),
                    style: AppTypography.labelSmall.copyWith(
                      color: _getPriorityColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                // Type badge (outlined)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: Text(
                    decision.type.displayName,
                    style: AppTypography.labelSmall,
                  ),
                ),
                const Spacer(),
                // Relative timestamp
                Text(
                  _getRelativeTime(decision.createdAt),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Title
            Text(
              decision.title,
              style: AppTypography.h2,
            ),
            const SizedBox(height: AppSpacing.md),

            // Subtitle: Created by, Created time, Assigned to
            Row(
              children: [
                Icon(Icons.person_outline, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: AppSpacing.xs),
                if (decision.owner != null)
                  Text(
                    'Created by ${decision.owner!.fullName}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  )
                else
                  Text(
                    'Created',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '·',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  _getRelativeTime(decision.createdAt),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '·',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Assigned to',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                if (decision.assignedTo != null)
                  Text(
                    decision.assignedTo!.fullName,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                else
                  Text(
                    'Unassigned',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // SLA + Escalate Actions
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

  Color _getPriorityColor() {
    final urgencyColor =
        Color(int.parse(decision.urgency.color.replaceFirst('#', '0xFF')));
    return urgencyColor;
  }

  String _getPriorityLabel() {
    return decision.urgency.displayName;
  }

  String _getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) {
      return 'just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Color _getStatusColor(DecisionStatus status) {
    switch (status) {
      case DecisionStatus.NEEDS_INPUT:
        return AppColors.error;
      case DecisionStatus.UNDER_DISCUSSION:
        return AppColors.warning;
      case DecisionStatus.DECIDED:
        return AppColors.success;
      case DecisionStatus.IMPLEMENTED:
        return AppColors.success;
      case DecisionStatus.DEFERRED:
        return AppColors.surfaceVariant;
      case DecisionStatus.CANCELLED:
        return AppColors.surfaceVariant;
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
      case DecisionStatus.IMPLEMENTED:
        return Icons.rocket_launch_outlined;
      case DecisionStatus.DEFERRED:
        return Icons.pause_circle_outline;
      case DecisionStatus.CANCELLED:
        return Icons.cancel_outlined;
    }
  }
}
