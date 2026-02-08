import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

part 'comment_action_providers.g.dart';

/// Action provider for comment create/update/delete.
@riverpod
class CommentActions extends _$CommentActions {
  @override
  FutureOr<void> build() {}

  Future<Comment?> create(CreateCommentRequest request) async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(commentServiceProvider);
      final comment = await service.create(request);
      ref.invalidate(
          entityCommentsProvider(request.parentType, request.parentId));
      state = const AsyncValue.data(null);
      return comment;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<Comment?> updateComment(String id, UpdateCommentRequest request,
      CommentParentType parentType, String parentId) async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(commentServiceProvider);
      final comment = await service.update(id, request);
      ref.invalidate(entityCommentsProvider(parentType, parentId));
      state = const AsyncValue.data(null);
      return comment;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<bool> deleteComment(
      String id, CommentParentType parentType, String parentId) async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(commentServiceProvider);
      await service.delete(id);
      ref.invalidate(entityCommentsProvider(parentType, parentId));
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

/// Replies to a specific comment.
@riverpod
Future<List<Comment>> commentReplies(Ref ref, String commentId) async {
  final service = ref.watch(commentServiceProvider);
  return service.getReplies(commentId);
}
