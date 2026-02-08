import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

part 'workstreams_providers.g.dart';

/// Create workstream action
@riverpod
class CreateWorkstreamAction extends _$CreateWorkstreamAction {
  @override
  FutureOr<void> build() {}

  Future<Workstream?> create(
      String programId, CreateWorkstreamRequest request) async {
    state = const AsyncValue.loading();

    try {
      final service = ref.read(workstreamServiceProvider);
      final workstream = await service.create(programId, request);

      ref.invalidate(programWorkstreamsProvider(programId));

      state = const AsyncValue.data(null);
      return workstream;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}
