import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/avatar.dart';

class ActivityFeedPanel extends StatelessWidget {
  final List<DashboardActivityItem> activities;

  const ActivityFeedPanel({super.key, required this.activities});

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
          Text('Team Activity', style: AppTypography.h4),
          const SizedBox(height: AppSpacing.md),
          if (activities.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(
                child: Text('No recent activity', style: AppTypography.bodySmall),
              ),
            )
          else
            ...activities.take(8).map((a) => _ActivityItem(activity: a)),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final DashboardActivityItem activity;

  const _ActivityItem({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ZAvatar(
            name: activity.actor ?? 'System',
            imageUrl: activity.actorAvatarUrl,
            size: 28,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: AppTypography.bodySmall,
                    children: [
                      TextSpan(
                        text: activity.actor ?? 'System',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(text: ' ${activity.action}'),
                      if (activity.entityName != null)
                        TextSpan(
                          text: ' ${activity.entityName}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  _formatTimestamp(activity.timestamp),
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat.MMMd().format(timestamp);
  }
}
