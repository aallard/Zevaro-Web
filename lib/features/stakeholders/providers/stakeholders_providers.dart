import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

part 'stakeholders_providers.g.dart';

/// Leaderboard view mode
@riverpod
class LeaderboardPeriod extends _$LeaderboardPeriod {
  @override
  String build() => '30d'; // Default to 30 days

  void setPeriod(String period) => state = period;
}

/// Stakeholder detail
@riverpod
Future<Stakeholder> stakeholderDetail(
    StakeholderDetailRef ref, String id) async {
  final stakeholderService = ref.watch(stakeholderServiceProvider);
  return stakeholderService.getStakeholder(id);
}

/// Stakeholder's pending responses
@riverpod
Future<List<StakeholderResponse>> stakeholderPendingResponses(
  StakeholderPendingResponsesRef ref,
  String stakeholderId,
) async {
  final stakeholderService = ref.watch(stakeholderServiceProvider);
  final response = await stakeholderService.getResponseHistory(
    stakeholderId,
    pending: true,
  );
  return response.content;
}

/// Stakeholder's response history (completed)
@riverpod
Future<List<StakeholderResponse>> stakeholderResponseHistory(
  StakeholderResponseHistoryRef ref,
  String stakeholderId,
) async {
  final stakeholderService = ref.watch(stakeholderServiceProvider);
  final response = await stakeholderService.getResponseHistory(
    stakeholderId,
    pending: false,
  );
  return response.content;
}
