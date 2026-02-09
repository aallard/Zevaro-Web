import 'dart:async';
import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

part 'attachment_action_providers.g.dart';

/// Action provider for attachment upload/delete.
@riverpod
class AttachmentActions extends _$AttachmentActions {
  @override
  FutureOr<void> build() {}

  Future<Attachment?> upload(AttachmentParentType parentType, String parentId,
      String filePath, String fileName) async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(attachmentServiceProvider);
      final attachment =
          await service.upload(parentType, parentId, filePath, fileName);
      ref.invalidate(entityAttachmentsProvider(parentType, parentId));
      state = const AsyncValue.data(null);
      return attachment;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<Attachment?> uploadFromBytes(AttachmentParentType parentType,
      String parentId, Uint8List bytes, String fileName) async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(attachmentServiceProvider);
      final attachment =
          await service.uploadFromBytes(parentType, parentId, bytes, fileName);
      ref.invalidate(entityAttachmentsProvider(parentType, parentId));
      state = const AsyncValue.data(null);
      return attachment;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<bool> deleteAttachment(
      String id, AttachmentParentType parentType, String parentId) async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(attachmentServiceProvider);
      await service.delete(id);
      ref.invalidate(entityAttachmentsProvider(parentType, parentId));
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Gets the download URL for an attachment.
  String getDownloadUrl(String id) {
    final service = ref.read(attachmentServiceProvider);
    return service.getDownloadUrl(id);
  }
}
