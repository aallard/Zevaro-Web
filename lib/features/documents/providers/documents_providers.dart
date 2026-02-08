import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

part 'documents_providers.g.dart';

/// Create document action
@riverpod
class CreateDocumentAction extends _$CreateDocumentAction {
  @override
  FutureOr<void> build() {}

  Future<Document?> create(CreateDocumentRequest request) async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(documentServiceProvider);
      final document = await service.create(request);
      ref.invalidate(documentTreeProvider(request.spaceId));
      ref.invalidate(spaceDocumentsProvider(request.spaceId));
      state = const AsyncValue.data(null);
      return document;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}

/// Document workflow actions (publish/archive)
@riverpod
class DocumentWorkflowAction extends _$DocumentWorkflowAction {
  @override
  FutureOr<void> build() {}

  Future<Document?> publish(String id) async {
    return _doAction(
        () => ref.read(documentServiceProvider).publish(id), id);
  }

  Future<Document?> archive(String id) async {
    return _doAction(
        () => ref.read(documentServiceProvider).archive(id), id);
  }

  Future<Document?> _doAction(
      Future<Document> Function() action, String id) async {
    state = const AsyncValue.loading();
    try {
      final result = await action();
      ref.invalidate(documentProvider(id));
      state = const AsyncValue.data(null);
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}

/// Update document action
@riverpod
class UpdateDocumentAction extends _$UpdateDocumentAction {
  @override
  FutureOr<void> build() {}

  Future<Document?> save(
      String id, UpdateDocumentRequest request) async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(documentServiceProvider);
      final document = await service.update(id, request);
      ref.invalidate(documentProvider(id));
      state = const AsyncValue.data(null);
      return document;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}
