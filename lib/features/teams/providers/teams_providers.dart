import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

part 'teams_providers.g.dart';

/// All teams the user can see
@riverpod
Future<List<Team>> teamsList(TeamsListRef ref) async {
  final teamService = ref.watch(teamServiceProvider);
  final response = await teamService.listTeams();
  return response.content;
}

/// Team detail with members
@riverpod
Future<Team> teamDetail(TeamDetailRef ref, String id) async {
  final teamService = ref.watch(teamServiceProvider);
  return teamService.getTeamWithMembers(id);
}

/// Add team member
@riverpod
class AddTeamMember extends _$AddTeamMember {
  @override
  FutureOr<void> build() {}

  Future<bool> add(String teamId, String userId, TeamMemberRole role) async {
    state = const AsyncValue.loading();

    try {
      final teamService = ref.read(teamServiceProvider);
      await teamService.addMember(
        teamId,
        AddTeamMemberRequest(userId: userId, role: role),
      );

      ref.invalidate(teamDetailProvider(teamId));

      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

/// Update member role
@riverpod
class UpdateMemberRole extends _$UpdateMemberRole {
  @override
  FutureOr<void> build() {}

  Future<bool> changeRole(
      String teamId, String memberId, TeamMemberRole newRole) async {
    state = const AsyncValue.loading();

    try {
      final teamService = ref.read(teamServiceProvider);
      await teamService.updateMemberRole(teamId, memberId, newRole);

      ref.invalidate(teamDetailProvider(teamId));

      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

/// Remove team member
@riverpod
class RemoveTeamMember extends _$RemoveTeamMember {
  @override
  FutureOr<void> build() {}

  Future<bool> remove(String teamId, String memberId) async {
    state = const AsyncValue.loading();

    try {
      final teamService = ref.read(teamServiceProvider);
      await teamService.removeMember(teamId, memberId);

      ref.invalidate(teamDetailProvider(teamId));

      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

/// Create team
@riverpod
class CreateTeam extends _$CreateTeam {
  @override
  FutureOr<void> build() {}

  Future<Team?> create(CreateTeamRequest request) async {
    state = const AsyncValue.loading();

    try {
      final teamService = ref.read(teamServiceProvider);
      final team = await teamService.createTeam(request);

      ref.invalidate(teamsListProvider);
      ref.invalidate(myTeamsProvider);

      state = const AsyncValue.data(null);
      return team;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}

/// Users available to invite (not already team members)
@riverpod
Future<List<User>> availableUsers(AvailableUsersRef ref, String teamId) async {
  final userService = ref.watch(userServiceProvider);
  final team = await ref.watch(teamDetailProvider(teamId).future);

  final allUsers = await userService.listUsers();
  final memberUserIds = team.members?.map((m) => m.user.id).toSet() ?? {};

  return allUsers.content.where((u) => !memberUserIds.contains(u.id)).toList();
}
