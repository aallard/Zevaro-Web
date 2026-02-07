import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

part 'experiments_providers.g.dart';

/// Filter state for experiments
enum ExperimentFilterTab { running, completed, draft }

@riverpod
class ExperimentFilterNotifier extends _$ExperimentFilterNotifier {
  @override
  ExperimentFilterTab build() => ExperimentFilterTab.running;

  void setTab(ExperimentFilterTab tab) => state = tab;
}

/// Filtered experiments
@riverpod
Future<List<Experiment>> filteredExperiments(
  FilteredExperimentsRef ref,
) async {
  final service = ref.watch(experimentServiceProvider);
  final tab = ref.watch(experimentFilterNotifierProvider);
  final selectedProjectId = ref.watch(selectedProjectIdProvider);

  ExperimentStatus? status;
  switch (tab) {
    case ExperimentFilterTab.running:
      status = ExperimentStatus.RUNNING;
      break;
    case ExperimentFilterTab.completed:
      status = ExperimentStatus.CONCLUDED;
      break;
    case ExperimentFilterTab.draft:
      status = ExperimentStatus.DRAFT;
      break;
  }

  return service.listExperiments(
    status: status,
    projectId: selectedProjectId,
  );
}

/// Experiment detail
@riverpod
Future<Experiment> experimentDetail(
  ExperimentDetailRef ref,
  String id,
) async {
  final service = ref.watch(experimentServiceProvider);
  return service.getExperiment(id);
}
