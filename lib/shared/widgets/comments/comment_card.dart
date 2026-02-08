import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../common/avatar.dart';

class CommentCard extends StatelessWidget {
  final Comment comment;
  final bool isCurrentUser;
  final VoidCallback? onReply;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CommentCard({
    super.key,
    required this.comment,
    required this.isCurrentUser,
    this.onReply,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                // Author + timestamp
                Row(
                  children: [
                    Text(
                      comment.authorName ?? 'Unknown',
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    if (comment.edited)
                      Text(
                        '(edited)',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textTertiary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    const Spacer(),
                    if (comment.createdAt != null)
                      Text(
                        _formatTimestamp(comment.createdAt!),
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxs),

                // Body
                Text(
                  comment.body,
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(height: AppSpacing.xs),

                // Actions
                Row(
                  children: [
                    if (onReply != null)
                      _ActionButton(
                        label: 'Reply',
                        onTap: onReply!,
                      ),
                    if (comment.replyCount != null && comment.replyCount! > 0)
                      Padding(
                        padding:
                            const EdgeInsets.only(left: AppSpacing.sm),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                                AppSpacing.radiusFull),
                          ),
                          child: Text(
                            '${comment.replyCount} ${comment.replyCount == 1 ? 'reply' : 'replies'}',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.primary,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    const Spacer(),
                    if (isCurrentUser && onEdit != null)
                      _ActionButton(label: 'Edit', onTap: onEdit!),
                    if (isCurrentUser && onDelete != null) ...[
                      const SizedBox(width: AppSpacing.xs),
                      _ActionButton(
                        label: 'Delete',
                        onTap: onDelete!,
                        color: AppColors.error,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _ActionButton({
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: color ?? AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
