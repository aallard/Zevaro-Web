import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../providers/comment_action_providers.dart';
import '../common/loading_indicator.dart';
import '../common/error_view.dart';
import 'comment_card.dart';

class CommentSection extends ConsumerStatefulWidget {
  final CommentParentType parentType;
  final String parentId;

  const CommentSection({
    super.key,
    required this.parentType,
    required this.parentId,
  });

  @override
  ConsumerState<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends ConsumerState<CommentSection> {
  final _newCommentController = TextEditingController();
  String? _editingCommentId;
  final _editController = TextEditingController();
  String? _replyToCommentId;
  final _replyController = TextEditingController();
  final Map<String, bool> _expandedReplies = {};

  @override
  void dispose() {
    _newCommentController.dispose();
    _editController.dispose();
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _submitComment() async {
    final body = _newCommentController.text.trim();
    if (body.isEmpty) return;

    await ref.read(commentActionsProvider.notifier).create(
          CreateCommentRequest(
            parentType: widget.parentType,
            parentId: widget.parentId,
            body: body,
          ),
        );
    _newCommentController.clear();
  }

  Future<void> _submitReply(String parentCommentId) async {
    final body = _replyController.text.trim();
    if (body.isEmpty) return;

    await ref.read(commentActionsProvider.notifier).create(
          CreateCommentRequest(
            parentType: widget.parentType,
            parentId: widget.parentId,
            body: body,
            parentCommentId: parentCommentId,
          ),
        );
    _replyController.clear();
    setState(() => _replyToCommentId = null);
    // Also refresh replies for this comment
    ref.invalidate(commentRepliesProvider(parentCommentId));
  }

  Future<void> _submitEdit(String commentId) async {
    final body = _editController.text.trim();
    if (body.isEmpty) return;

    await ref.read(commentActionsProvider.notifier).updateComment(
          commentId,
          UpdateCommentRequest(body: body),
          widget.parentType,
          widget.parentId,
        );
    setState(() => _editingCommentId = null);
  }

  Future<void> _deleteComment(String commentId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Comment'),
        content: const Text('Are you sure you want to delete this comment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(commentActionsProvider.notifier).deleteComment(
            commentId,
            widget.parentType,
            widget.parentId,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final commentsAsync = ref.watch(
        entityCommentsProvider(widget.parentType, widget.parentId));
    final currentUser = ref.watch(currentUserProvider);
    final currentUserId = currentUser.valueOrNull?.id;

    return commentsAsync.when(
      data: (comments) {
        // Top-level comments only (no parent)
        final topLevel = comments
            .where((c) => c.parentCommentId == null)
            .toList()
          ..sort((a, b) => (b.createdAt ?? DateTime(0))
              .compareTo(a.createdAt ?? DateTime(0)));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (topLevel.isEmpty)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Center(
                  child: Text(
                    'No comments yet',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              )
            else
              ...topLevel.map((comment) => Column(
                    children: [
                      if (_editingCommentId == comment.id)
                        _EditInput(
                          controller: _editController,
                          onSubmit: () => _submitEdit(comment.id),
                          onCancel: () =>
                              setState(() => _editingCommentId = null),
                        )
                      else
                        CommentCard(
                          comment: comment,
                          isCurrentUser: currentUserId == comment.authorId,
                          onReply: () {
                            setState(() {
                              _replyToCommentId = comment.id;
                              _replyController.clear();
                            });
                          },
                          onEdit: () {
                            setState(() {
                              _editingCommentId = comment.id;
                              _editController.text = comment.body;
                            });
                          },
                          onDelete: () => _deleteComment(comment.id),
                        ),

                      // Reply count → expand replies
                      if (comment.replyCount != null &&
                          comment.replyCount! > 0)
                        _RepliesSection(
                          commentId: comment.id,
                          isExpanded:
                              _expandedReplies[comment.id] ?? false,
                          onToggle: () => setState(() {
                            _expandedReplies[comment.id] =
                                !(_expandedReplies[comment.id] ?? false);
                          }),
                          currentUserId: currentUserId,
                          parentType: widget.parentType,
                          parentId: widget.parentId,
                        ),

                      // Reply input
                      if (_replyToCommentId == comment.id)
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 44, right: AppSpacing.md),
                          child: _CommentInput(
                            controller: _replyController,
                            hintText: 'Write a reply...',
                            onSubmit: () =>
                                _submitReply(comment.id),
                            onCancel: () => setState(
                                () => _replyToCommentId = null),
                          ),
                        ),

                      const Divider(height: 1),
                    ],
                  )),

            // New comment input
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: _CommentInput(
                controller: _newCommentController,
                hintText: 'Add a comment...',
                onSubmit: _submitComment,
              ),
            ),
          ],
        );
      },
      loading: () => const LoadingIndicator(message: 'Loading comments...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () => ref.invalidate(
            entityCommentsProvider(widget.parentType, widget.parentId)),
      ),
    );
  }
}

/// Expandable replies section under a comment.
class _RepliesSection extends ConsumerWidget {
  final String commentId;
  final bool isExpanded;
  final VoidCallback onToggle;
  final String? currentUserId;
  final CommentParentType parentType;
  final String parentId;

  const _RepliesSection({
    required this.commentId,
    required this.isExpanded,
    required this.onToggle,
    required this.currentUserId,
    required this.parentType,
    required this.parentId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!isExpanded) {
      return Padding(
        padding: const EdgeInsets.only(left: 44),
        child: InkWell(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.xxs),
            child: Text(
              'Show replies',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }

    final repliesAsync = ref.watch(commentRepliesProvider(commentId));

    return Padding(
      padding: const EdgeInsets.only(left: 44),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.xxs),
              child: Text(
                'Hide replies',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          repliesAsync.when(
            data: (replies) => Column(
              children: replies
                  .map((reply) => CommentCard(
                        comment: reply,
                        isCurrentUser: currentUserId == reply.authorId,
                      ))
                  .toList(),
            ),
            loading: () => const Padding(
              padding: EdgeInsets.all(AppSpacing.sm),
              child: SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Text(
                'Failed to load replies',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Input field for new comments or replies.
class _CommentInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback onSubmit;
  final VoidCallback? onCancel;

  const _CommentInput({
    required this.controller,
    required this.hintText,
    required this.onSubmit,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppTypography.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(AppSpacing.radiusMd),
                borderSide:
                    const BorderSide(color: AppColors.border),
              ),
            ),
            maxLines: 3,
            minLines: 1,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        if (onCancel != null) ...[
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: onCancel,
            tooltip: 'Cancel',
          ),
        ],
        IconButton(
          icon: const Icon(Icons.send, size: 18),
          onPressed: onSubmit,
          color: AppColors.primary,
          tooltip: 'Send',
        ),
      ],
    );
  }
}

/// Inline edit input.
class _EditInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  const _EditInput({
    required this.controller,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(width: 40),
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: 5,
              minLines: 2,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusMd),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: onCancel,
          ),
          IconButton(
            icon: const Icon(Icons.check, size: 18),
            onPressed: onSubmit,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
