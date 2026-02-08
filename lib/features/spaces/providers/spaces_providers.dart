import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

part 'spaces_providers.g.dart';

/// Create space action
@riverpod
class CreateSpaceAction extends _$CreateSpaceAction {
  @override
  FutureOr<void> build() {}

  Future<Space?> create(CreateSpaceRequest request) async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(spaceServiceProvider);
      final space = await service.create(request);
      ref.invalidate(spacesProvider);
      state = const AsyncValue.data(null);
      return space;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}

/// Currently selected document ID within a space detail view
@riverpod
class SelectedDocumentId extends _$SelectedDocumentId {
  @override
  String? build() => null;

  void select(String? id) => state = id;
}
