import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

part 'dashboard_providers.g.dart';

/// Dashboard stats aggregation
@riverpod
Future<DashboardStats> dashboardStats(DashboardStatsRef ref) async {
  final decisions = await ref.watch(decisionQueueProvider().future);
  final blockingDecisions = await ref.watch(blockingDecisionsProvider.future);
  final myResponses = await ref.watch(myPendingResponsesProvider.future);
  final myOutcomes = await ref.watch(myOutcomesProvider.future);
  final myHypotheses = await ref.watch(myHypothesesProvider.future);
  final blockedHypotheses = await ref.watch(blockedHypothesesProvider.future);

  return DashboardStats(
    pendingDecisions: decisions.length,
    blockingDecisions: blockingDecisions.length,
    myPendingResponses: myResponses.length,
    activeOutcomes:
        myOutcomes.where((o) => o.status.isActive).length,
    activeHypotheses: myHypotheses.where((h) => h.status.isActive).length,
    blockedHypotheses: blockedHypotheses.length,
  );
}

/// Project-scoped dashboard data
@riverpod
Future<ProjectDashboard> projectDashboard(
  ProjectDashboardRef ref,
  String projectId,
) async {
  return ref.watch(projectDashboardProvider(projectId).future);
}

class DashboardStats {
  final int pendingDecisions;
  final int blockingDecisions;
  final int myPendingResponses;
  final int activeOutcomes;
  final int activeHypotheses;
  final int blockedHypotheses;

  const DashboardStats({
    required this.pendingDecisions,
    required this.blockingDecisions,
    required this.myPendingResponses,
    required this.activeOutcomes,
    required this.activeHypotheses,
    required this.blockedHypotheses,
  });

  bool get hasUrgentItems => blockingDecisions > 0 || myPendingResponses > 0;
}
