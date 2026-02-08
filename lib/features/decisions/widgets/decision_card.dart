import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/avatar.dart';
import 'sla_indicator.dart';

class DecisionCard extends StatelessWidget {
  final Decision decision;

  const DecisionCard({super.key, required this.decision});

  Color get _typeColor {
    // Color-coded by DecisionType
    switch (decision.type) {
      case DecisionType.ARCHITECTURAL:
        return const Color(0xFF4F46E5); // Indigo
      case DecisionType.PRODUCT:
        return const Color(0xFF3B82F6); // Blue
      case DecisionType.TECHNICAL:
        return const Color(0xFF6B7280); // Gray
      case DecisionType.UX:
        return const Color(0xFFEC4899); // Pink
      case DecisionType.STRATEGIC:
        return const Color(0xFFF59E0B); // Amber
      case DecisionType.OPERATIONAL:
        return const Color(0xFF14B8A6); // Teal
      case DecisionType.RESOURCE:
        return const Color(0xFF8B5CF6); // Purple
      case DecisionType.SCOPE:
        return const Color(0xFF059669); // Emerald
      case DecisionType.TIMELINE:
        return const Color(0xFFDC2626); // Red
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go(Routes.decisionById(decision.id)),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with type badge and three-dot menu
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                child: Row(
                  children: [
                    // Type badge with colored border
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: _typeColor, width: 1),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Text(
                        decision.type.displayName.toUpperCase(),
                        style: AppTypography.labelSmall.copyWith(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: _typeColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Three-dot menu
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        // TODO: Handle menu actions (edit, delete, etc.)
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 16),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'escalate',
                          child: Row(
                            children: [
                              Icon(Icons.trending_up, size: 16),
                              SizedBox(width: 8),
                              Text('Escalate'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 16),
                              SizedBox(width: 8),
                              Text('Delete'),
                            ],
                          ),
                        ),
                      ],
                      child: Icon(
                        Icons.more_vert,
                        size: 16,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),

              // Parent type + title
              if (decision.parentType != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.textTertiary.withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                        child: Text(
                          decision.parentType!,
                          style: AppTypography.labelSmall.copyWith(
                            fontSize: 8,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ),
                      if (decision.parentTitle != null) ...[
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            decision.parentTitle!,
                            style: AppTypography.labelSmall.copyWith(
                              fontSize: 9,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Text(
                  decision.title,
                  style: AppTypography.labelLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),

              // Assignee + waiting time badge
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Row(
                  children: [
                    if (decision.assignedTo != null) ...[
                      ZAvatar(
                        name: decision.assignedTo!.fullName,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.xxs),
                      Expanded(
                        child: Text(
                          decision.assignedTo!.fullName,
                          style: AppTypography.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ] else
                      const Spacer(),
                    // Duration badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 10,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            _formatWaitTime(decision.createdAt),
                            style: AppTypography.labelSmall.copyWith(
                              fontSize: 10,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xs),

              // SLA indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: SlaIndicator(decision: decision, compact: true),
              ),
              const SizedBox(height: AppSpacing.xs),

              // Bottom icons: comments, votes, drag handle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Row(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 14,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${decision.commentCount}',
                      style: AppTypography.labelSmall,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Icon(
                      Icons.thumb_up_outlined,
                      size: 14,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${decision.voteCount}',
                      style: AppTypography.labelSmall,
                    ),
                    const Spacer(),
                    // Drag handle (visual only)
                    Icon(
                      Icons.drag_indicator,
                      size: 16,
                      color: AppColors.textTertiary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
            ],
          ),
        ),
      ),
    );
  }

  String _formatWaitTime(DateTime createdAt) {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h ${diff.inMinutes % 60}m';
    return '${diff.inDays}d ${diff.inHours % 24}h';
  }
}
