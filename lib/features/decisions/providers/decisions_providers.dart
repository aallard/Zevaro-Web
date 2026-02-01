import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

part 'decisions_providers.g.dart';

/// View mode toggle (board vs list)
@riverpod
class DecisionViewMode extends _$DecisionViewMode {
  @override
  ViewMode build() => ViewMode.board;

  void setBoard() => state = ViewMode.board;
  void setList() => state = ViewMode.list;
  void toggle() =>
      state = state == ViewMode.board ? ViewMode.list : ViewMode.board;
}

enum ViewMode { board, list }

/// Filter state
@riverpod
class DecisionFilters extends _$DecisionFilters {
  @override
  DecisionFilterState build() => const DecisionFilterState();

  void setUrgency(DecisionUrgency? urgency) {
    state = state.copyWith(urgency: urgency, clearUrgency: urgency == null);
  }

  void setType(DecisionType? type) {
    state = state.copyWith(type: type, clearType: type == null);
  }

  void setTeam(String? teamId) {
    state = state.copyWith(teamId: teamId, clearTeamId: teamId == null);
  }

  void setSearch(String? search) {
    state = state.copyWith(search: search);
  }

  void clearAll() {
    state = const DecisionFilterState();
  }
}

class DecisionFilterState {
  final DecisionUrgency? urgency;
  final DecisionType? type;
  final String? teamId;
  final String? search;

  const DecisionFilterState({
    this.urgency,
    this.type,
    this.teamId,
    this.search,
  });

  DecisionFilterState copyWith({
    DecisionUrgency? urgency,
    DecisionType? type,
    String? teamId,
    String? search,
    bool clearUrgency = false,
    bool clearType = false,
    bool clearTeamId = false,
  }) {
    return DecisionFilterState(
      urgency: clearUrgency ? null : (urgency ?? this.urgency),
      type: clearType ? null : (type ?? this.type),
      teamId: clearTeamId ? null : (teamId ?? this.teamId),
      search: search ?? this.search,
    );
  }

  bool get hasFilters =>
      urgency != null ||
      type != null ||
      teamId != null ||
      (search?.isNotEmpty ?? false);
}

/// Filtered decisions grouped by status (for board view)
@riverpod
Future<Map<DecisionStatus, List<Decision>>> decisionsByStatus(
  DecisionsByStatusRef ref,
) async {
  final decisions = await ref.watch(decisionQueueProvider().future);
  final filters = ref.watch(decisionFiltersProvider);

  var filtered = decisions.where((d) {
    if (filters.urgency != null && d.urgency != filters.urgency) return false;
    if (filters.type != null && d.type != filters.type) return false;
    if (filters.teamId != null && d.teamId != filters.teamId) return false;
    if (filters.search != null && filters.search!.isNotEmpty) {
      final searchLower = filters.search!.toLowerCase();
      if (!d.title.toLowerCase().contains(searchLower) &&
          !(d.description?.toLowerCase().contains(searchLower) ?? false)) {
        return false;
      }
    }
    return true;
  }).toList();

  // Group by status
  return {
    DecisionStatus.NEEDS_INPUT:
        filtered.where((d) => d.status == DecisionStatus.NEEDS_INPUT).toList(),
    DecisionStatus.UNDER_DISCUSSION: filtered
        .where((d) => d.status == DecisionStatus.UNDER_DISCUSSION)
        .toList(),
    DecisionStatus.DECIDED:
        filtered.where((d) => d.status == DecisionStatus.DECIDED).toList(),
  };
}

/// Create decision action
@riverpod
class CreateDecision extends _$CreateDecision {
  @override
  FutureOr<void> build() {}

  Future<Decision?> create(CreateDecisionRequest request) async {
    state = const AsyncValue.loading();

    try {
      final decisionService = ref.read(decisionServiceProvider);
      final decision = await decisionService.createDecision(request);

      // Invalidate related providers
      ref.invalidate(decisionQueueProvider);
      ref.invalidate(decisionsByStatusProvider);

      state = const AsyncValue.data(null);
      return decision;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}

/// Selected decision for detail view
@riverpod
Future<Decision> decisionDetail(DecisionDetailRef ref, String id) async {
  final decisionService = ref.watch(decisionServiceProvider);
  return decisionService.getDecisionWithDetails(id);
}

/// Vote on a decision
@riverpod
class VoteOnDecision extends _$VoteOnDecision {
  @override
  FutureOr<void> build() {}

  Future<bool> vote(String decisionId, String voteValue,
      {String? comment}) async {
    state = const AsyncValue.loading();

    try {
      final actions = ref.read(decisionActionsProvider.notifier);
      await actions.vote(decisionId, voteValue, comment: comment);

      // Invalidate to refresh
      ref.invalidate(decisionDetailProvider(decisionId));
      ref.invalidate(decisionQueueProvider);

      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

/// Resolve a decision
@riverpod
class ResolveDecisionAction extends _$ResolveDecisionAction {
  @override
  FutureOr<void> build() {}

  Future<bool> resolve(
      String decisionId, ResolveDecisionRequest request) async {
    state = const AsyncValue.loading();

    try {
      final actions = ref.read(decisionActionsProvider.notifier);
      await actions.resolveDecision(decisionId, request);

      // Invalidate to refresh
      ref.invalidate(decisionDetailProvider(decisionId));
      ref.invalidate(decisionQueueProvider);
      ref.invalidate(decisionsByStatusProvider);

      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

/// Add comment to a decision
@riverpod
class AddDecisionComment extends _$AddDecisionComment {
  @override
  FutureOr<void> build() {}

  Future<bool> addComment(String decisionId, String content,
      {String? parentId}) async {
    state = const AsyncValue.loading();

    try {
      final decisionService = ref.read(decisionServiceProvider);
      await decisionService.addComment(decisionId, content, parentId: parentId);

      ref.invalidate(decisionDetailProvider(decisionId));

      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}
