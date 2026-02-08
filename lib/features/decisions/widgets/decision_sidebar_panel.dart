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
                  name: decision.assignedTo?.fullName ?? 'Unassigned',
                  size: 28,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    decision.assignedTo?.fullName ?? 'Unassigned',
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                      decision.slaStatusDisplay,
                      style: AppTypography.bodySmall.copyWith(
                        color: decision.isSlaBreached
                            ? AppColors.error
                            : AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                if (decision.timeToSla != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _formatDuration(decision.timeToSla!),
                    style: AppTypography.bodySmall.copyWith(
                      color: _parseHexColor(decision.slaColor),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
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

          // Parent entity
          if (decision.parentType != null) ...[
            const Divider(height: AppSpacing.lg),
            _SidebarField(
              label: 'Parent Entity',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Text(
                      decision.parentType!,
                      style: AppTypography.labelSmall.copyWith(
                        fontSize: 10,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (decision.parentTitle != null) ...[
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      decision.parentTitle!,
                      style: AppTypography.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],

          // Workstream
          if (decision.workstreamName != null) ...[
            const Divider(height: AppSpacing.lg),
            _SidebarField(
              label: 'Workstream',
              child: Text(
                decision.workstreamName!,
                style: AppTypography.bodyMedium,
              ),
            ),
          ],

          if (decision.program != null) ...[
            const Divider(height: AppSpacing.lg),
            _SidebarField(
              label: 'Program',
              child: Text(
                decision.program!.name,
                style: AppTypography.bodyMedium,
              ),
            ),
          ],

          if (decision.outcome != null) ...[
            const Divider(height: AppSpacing.lg),
            _SidebarField(
              label: 'Linked Outcome',
              child: Text(
                decision.outcome!.title,
                style: AppTypography.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],

          // Discussion stats
          const Divider(height: AppSpacing.lg),
          _SidebarField(
            label: 'Discussion',
            child: Row(
              children: [
                Row(
                  children: [
                    Icon(Icons.comment_outlined,
                        size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '${decision.commentCount ?? 0}',
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: AppSpacing.md),
                Row(
                  children: [
                    Icon(Icons.thumb_up_outlined,
                        size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '${decision.voteCount ?? 0}',
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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

  static Color _parseHexColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  }

  static String _formatDuration(Duration duration) {
    if (duration.inDays > 0) return '${duration.inDays}d ${duration.inHours % 24}h remaining';
    if (duration.inHours > 0) return '${duration.inHours}h ${duration.inMinutes % 60}m remaining';
    return '${duration.inMinutes}m remaining';
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
