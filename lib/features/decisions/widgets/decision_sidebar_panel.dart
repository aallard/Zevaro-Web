import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/avatar.dart';

class DecisionSidebarPanel extends StatelessWidget {
  final Decision decision;

  const DecisionSidebarPanel({super.key, required this.decision});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status
          _SidebarField(
            label: 'Status',
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Text(
                decision.status.displayName,
                style: AppTypography.labelMedium.copyWith(
                  color: _statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const Divider(height: AppSpacing.lg),

          // Assignee
          _SidebarField(
            label: 'Assignee',
            child: Row(
              children: [
                ZAvatar(
                  name: decision.assigneeName ?? 'Unassigned',
                  size: 28,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    decision.assigneeName ?? 'Unassigned',
                    style: AppTypography.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: AppSpacing.lg),

          // SLA
          _SidebarField(
            label: 'SLA',
            child: Row(
              children: [
                Icon(
                  decision.isSlaBreached
                      ? Icons.local_fire_department
                      : Icons.timer_outlined,
                  size: 16,
                  color: decision.isSlaBreached
                      ? AppColors.error
                      : AppColors.success,
                ),
                const SizedBox(width: AppSpacing.xxs),
                Text(
                  '${decision.urgency.slaHours}h',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  decision.isSlaBreached ? 'Breached' : 'Active',
                  style: AppTypography.bodySmall.copyWith(
                    color: decision.isSlaBreached
                        ? AppColors.error
                        : AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: AppSpacing.lg),

          // Priority
          _SidebarField(
            label: 'Priority',
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _urgencyColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Text(
                decision.urgency.displayName,
                style: AppTypography.labelMedium.copyWith(
                  color: _urgencyColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const Divider(height: AppSpacing.lg),

          // Type
          _SidebarField(
            label: 'Type',
            child: Text(
              decision.type.displayName,
              style: AppTypography.bodyMedium,
            ),
          ),

          if (decision.project != null) ...[
            const Divider(height: AppSpacing.lg),
            _SidebarField(
              label: 'Project',
              child: Text(
                decision.project!.name,
                style: AppTypography.bodyMedium,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color get _statusColor {
    switch (decision.status) {
      case DecisionStatus.NEEDS_INPUT:
        return AppColors.error;
      case DecisionStatus.UNDER_DISCUSSION:
        return AppColors.warning;
      case DecisionStatus.DECIDED:
        return AppColors.success;
      case DecisionStatus.IMPLEMENTED:
        return AppColors.primary;
      case DecisionStatus.DEFERRED:
        return AppColors.surfaceVariant;
      case DecisionStatus.CANCELLED:
        return AppColors.surfaceVariant;
    }
  }

  Color get _urgencyColor {
    final urgencyColor =
        Color(int.parse(decision.urgency.color.replaceFirst('#', '0xFF')));
    return urgencyColor;
  }
}

class _SidebarField extends StatelessWidget {
  final String label;
  final Widget child;

  const _SidebarField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        child,
      ],
    );
  }
}
