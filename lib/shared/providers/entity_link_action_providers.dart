import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

part 'entity_link_action_providers.g.dart';

/// Action provider for entity link create/delete.
@riverpod
class EntityLinkActions extends _$EntityLinkActions {
  @override
  FutureOr<void> build() {}

  Future<EntityLink?> create(CreateEntityLinkRequest request) async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(entityLinkServiceProvider);
      final link = await service.create(request);
      ref.invalidate(
          entityLinksProvider(request.sourceType, request.sourceId));
      state = const AsyncValue.data(null);
      return link;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<bool> deleteLink(
      String id, EntityType entityType, String entityId) async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(entityLinkServiceProvider);
      await service.delete(id);
      ref.invalidate(entityLinksProvider(entityType, entityId));
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}
