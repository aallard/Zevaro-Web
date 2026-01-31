import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/avatar.dart';

class VoteCard extends StatelessWidget {
  final DecisionVote vote;

  const VoteCard({super.key, required this.vote});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ZAvatar(
            name: vote.voterName ?? 'User',
            size: 36,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      vote.voterName ?? 'Unknown',
                      style: AppTypography.labelMedium,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getVoteColor(vote.vote).withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Text(
                        vote.vote,
                        style: AppTypography.labelSmall.copyWith(
                          color: _getVoteColor(vote.vote),
                        ),
                      ),
                    ),
                  ],
                ),
                if (vote.comment != null && vote.comment!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    vote.comment!,
                    style: AppTypography.bodySmall,
                  ),
                ],
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  _formatTime(vote.votedAt),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getVoteColor(String vote) {
    final lower = vote.toLowerCase();
    if (lower.contains('yes') ||
        lower.contains('approve') ||
        lower.contains('agree')) {
      return AppColors.success;
    } else if (lower.contains('no') ||
        lower.contains('reject') ||
        lower.contains('disagree')) {
      return AppColors.error;
    }
    return AppColors.primary;
  }

  String _formatTime(DateTime date) {
    return '${date.day}/${date.month} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
