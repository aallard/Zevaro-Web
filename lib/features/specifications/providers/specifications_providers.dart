import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

part 'specifications_providers.g.dart';

/// Create specification action
@riverpod
class CreateSpecificationAction extends _$CreateSpecificationAction {
  @override
  FutureOr<void> build() {}

  Future<Specification?> create(
      String workstreamId, CreateSpecificationRequest request) async {
    state = const AsyncValue.loading();

    try {
      final service = ref.read(specificationServiceProvider);
      final specification = await service.create(workstreamId, request);

      ref.invalidate(workstreamSpecificationsProvider(workstreamId));

      state = const AsyncValue.data(null);
      return specification;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}

/// Specification workflow actions
@riverpod
class SpecificationWorkflowAction extends _$SpecificationWorkflowAction {
  @override
  FutureOr<void> build() {}

  Future<Specification?> submitForReview(String id) async {
    return _doAction(() => ref.read(specificationServiceProvider).submitForReview(id), id);
  }

  Future<Specification?> approve(String id) async {
    return _doAction(() => ref.read(specificationServiceProvider).approve(id), id);
  }

  Future<Specification?> reject(String id) async {
    return _doAction(() => ref.read(specificationServiceProvider).reject(id), id);
  }

  Future<Specification?> startWork(String id) async {
    return _doAction(() => ref.read(specificationServiceProvider).startWork(id), id);
  }

  Future<Specification?> markDelivered(String id) async {
    return _doAction(() => ref.read(specificationServiceProvider).markDelivered(id), id);
  }

  Future<Specification?> markAccepted(String id) async {
    return _doAction(() => ref.read(specificationServiceProvider).markAccepted(id), id);
  }

  Future<Specification?> _doAction(
      Future<Specification> Function() action, String id) async {
    state = const AsyncValue.loading();
    try {
      final result = await action();
      ref.invalidate(specificationProvider(id));
      state = const AsyncValue.data(null);
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}
