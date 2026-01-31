import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/avatar.dart';

class CommentCard extends StatelessWidget {
  final DecisionComment comment;
  final VoidCallback? onReply;
  final int depth;

  const CommentCard({
    super.key,
    required this.comment,
    this.onReply,
    this.depth = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: depth * 24.0),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: depth > 0
            ? AppColors.surfaceVariant.withOpacity(0.5)
            : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: depth > 0
            ? Border(
                left: BorderSide(
                  color: AppColors.primary.withOpacity(0.3),
                  width: 2,
                ),
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ZAvatar(
                name: comment.authorName ?? 'User',
                size: 32,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.authorName ?? 'Unknown',
                      style: AppTypography.labelMedium,
                    ),
                    Text(
                      _formatTime(comment.createdAt),
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              if (onReply != null)
                TextButton.icon(
                  onPressed: onReply,
                  icon: const Icon(Icons.reply, size: 16),
                  label: const Text('Reply'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            comment.content,
            style: AppTypography.bodyMedium,
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime date) {
    return '${date.day}/${date.month} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
