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

/// Stakeholder detail with stats
@riverpod
Future<Stakeholder> stakeholderDetail(
    StakeholderDetailRef ref, String id) async {
  final stakeholderService = ref.watch(stakeholderServiceProvider);
  return stakeholderService.getStakeholderWithStats(id);
}

/// My stakeholder profile
@riverpod
Future<Stakeholder> myStakeholderProfile(MyStakeholderProfileRef ref) async {
  final stakeholderService = ref.watch(stakeholderServiceProvider);
  return stakeholderService.getMyStakeholderProfile();
}

/// Send reminder to stakeholder
@riverpod
class SendReminder extends _$SendReminder {
  @override
  FutureOr<void> build() {}

  Future<bool> send(String stakeholderId, {String? message}) async {
    state = const AsyncValue.loading();

    try {
      final stakeholderService = ref.read(stakeholderServiceProvider);
      await stakeholderService.sendReminder(stakeholderId, message: message);

      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}
