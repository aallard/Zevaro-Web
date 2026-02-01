import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import 'urgency_badge.dart';
import 'sla_indicator.dart';

class DecisionCard extends StatelessWidget {
  final Decision decision;
  final bool showStatus;

  const DecisionCard({
    super.key,
    required this.decision,
    this.showStatus = false,
  });

  @override
  Widget build(BuildContext context) {
    final urgencyColor =
        Color(int.parse(decision.urgency.color.replaceFirst('#', '0xFF')));

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go(Routes.decisionById(decision.id)),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: urgencyColor,
                width: 4,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Type + Urgency
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Text(
                        decision.type.displayName,
                        style: AppTypography.labelSmall,
                      ),
                    ),
                    const Spacer(),
                    UrgencyBadge(urgency: decision.urgency, compact: true),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                // Title
                Text(
                  decision.title,
                  style: AppTypography.labelLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),

                // Description preview
                if (decision.description?.isNotEmpty ?? false)
                  Text(
                    decision.description!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: AppSpacing.sm),

                // Footer: SLA + Stats
                Row(
                  children: [
                    SlaIndicator(decision: decision),
                    const Spacer(),
                    // Vote count
                    if (decision.voteCount > 0) ...[
                      const Icon(
                        Icons.how_to_vote_outlined,
                        size: 14,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${decision.voteCount}',
                        style: AppTypography.bodySmall,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                    // Comment count
                    if (decision.commentCount > 0) ...[
                      const Icon(
                        Icons.comment_outlined,
                        size: 14,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${decision.commentCount}',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
