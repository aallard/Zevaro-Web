import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

part 'templates_providers.g.dart';

/// Template action provider for create, delete, apply operations.
@riverpod
class TemplateActions extends _$TemplateActions {
  @override
  FutureOr<void> build() {}

  Future<void> create({
    required String name,
    String? description,
    required String structure,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(templateServiceProvider);
      await service.create(CreateTemplateRequest(
        name: name,
        description: description,
        structure: structure,
      ));
      ref.invalidate(programTemplatesProvider);
    });
  }

  Future<void> deleteTemplate(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(templateServiceProvider);
      await service.delete(id);
      ref.invalidate(programTemplatesProvider);
    });
  }

  Future<ApplyTemplateResponse?> apply({
    required String templateId,
    required String programName,
    String? programDescription,
    String? portfolioId,
  }) async {
    state = const AsyncLoading();
    ApplyTemplateResponse? result;
    state = await AsyncValue.guard(() async {
      final service = ref.read(templateServiceProvider);
      result = await service.apply(
        templateId,
        ApplyTemplateRequest(
          programName: programName,
          programDescription: programDescription,
          portfolioId: portfolioId,
        ),
      );
      ref.invalidate(programTemplatesProvider);
    });
    return result;
  }
}
