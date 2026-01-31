import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../providers/decisions_providers.dart';
import 'comment_card.dart';

class DecisionComments extends ConsumerStatefulWidget {
  final Decision decision;

  const DecisionComments({super.key, required this.decision});

  @override
  ConsumerState<DecisionComments> createState() => _DecisionCommentsState();
}

class _DecisionCommentsState extends ConsumerState<DecisionComments> {
  final _controller = TextEditingController();
  String? _replyingTo;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commentState = ref.watch(addDecisionCommentProvider);
    final isLoading = commentState.isLoading;
    final comments = widget.decision.comments ?? [];

    // Build threaded structure
    final topLevelComments =
        comments.where((c) => c.parentId == null).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Discussion', style: AppTypography.h4),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '(${comments.length})',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Add comment form
            if (_replyingTo != null) ...[
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Row(
                  children: [
                    Text(
                      'Replying to comment',
                      style: AppTypography.bodySmall,
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: () => setState(() => _replyingTo = null),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: _replyingTo != null
                    ? 'Write a reply...'
                    : 'Add a comment...',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                  onPressed: isLoading ? null : _submitComment,
                ),
              ),
              maxLines: 3,
              minLines: 1,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Comments list
            if (comments.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 32,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'No comments yet',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: topLevelComments.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final comment = topLevelComments[index];
                  return _buildCommentThread(comment, comments);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentThread(
      DecisionComment comment, List<DecisionComment> allComments,
      {int depth = 0}) {
    final replies =
        allComments.where((c) => c.parentId == comment.id).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommentCard(
          comment: comment,
          depth: depth,
          onReply: () => setState(() => _replyingTo = comment.id),
        ),
        ...replies.map((reply) => Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: _buildCommentThread(reply, allComments, depth: depth + 1),
            )),
      ],
    );
  }

  Future<void> _submitComment() async {
    if (_controller.text.trim().isEmpty) return;

    final success =
        await ref.read(addDecisionCommentProvider.notifier).addComment(
              widget.decision.id,
              _controller.text.trim(),
              parentId: _replyingTo,
            );

    if (success && mounted) {
      _controller.clear();
      setState(() => _replyingTo = null);
    }
  }
}
