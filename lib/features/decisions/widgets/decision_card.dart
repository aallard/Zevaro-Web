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

  Color get _priorityColor {
    final urgencyColor =
        Color(int.parse(decision.urgency.color.replaceFirst('#', '0xFF')));
    return urgencyColor;
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
              // Colored top border
              Container(
                height: 3,
                decoration: BoxDecoration(
                  color: _priorityColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppSpacing.radiusMd),
                    topRight: Radius.circular(AppSpacing.radiusMd),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Type badge
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
                      child: Text(
                        decision.type.displayName.toUpperCase(),
                        style: AppTypography.labelSmall.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),

                    // Title
                    Text(
                      decision.title,
                      style: AppTypography.labelLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),

                    // Assignee + waiting time
                    Row(
                      children: [
                        if (decision.assigneeName != null) ...[
                          ZAvatar(
                            name: decision.assigneeName!,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.xxs),
                          Expanded(
                            child: Text(
                              decision.assigneeName!,
                              style: AppTypography.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ] else
                          const Spacer(),
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          _formatWaitTime(decision.createdAt),
                          style: AppTypography.labelSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),

                    // SLA indicator
                    SlaIndicator(decision: decision, compact: true),

                    const SizedBox(height: AppSpacing.xs),

                    // Bottom icons: comments, votes
                    Row(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 14,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: 2),
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
                        const SizedBox(width: 2),
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
                  ],
                ),
              ),
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
