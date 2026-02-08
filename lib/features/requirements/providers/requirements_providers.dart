import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

part 'requirements_providers.g.dart';

/// Create requirement action
@riverpod
class CreateRequirementAction extends _$CreateRequirementAction {
  @override
  FutureOr<void> build() {}

  Future<Requirement?> create(
      String specificationId, CreateRequirementRequest request) async {
    state = const AsyncValue.loading();

    try {
      final service = ref.read(requirementServiceProvider);
      final requirement = await service.create(specificationId, request);

      ref.invalidate(specificationRequirementsProvider(specificationId));

      state = const AsyncValue.data(null);
      return requirement;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}
