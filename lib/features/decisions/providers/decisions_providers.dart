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

/// V2 filter state with cascading filters
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

  void setPortfolio(String? portfolioId) {
    // Cascade: clear program and workstream when portfolio changes
    state = DecisionFilterState(
      urgency: state.urgency,
      type: state.type,
      teamId: state.teamId,
      search: state.search,
      portfolioId: portfolioId,
      parentType: state.parentType,
      executionMode: state.executionMode,
      slaStatus: state.slaStatus,
      status: state.status,
    );
  }

  void setProgram(String? programId) {
    // Cascade: clear workstream when program changes
    state = DecisionFilterState(
      urgency: state.urgency,
      type: state.type,
      teamId: state.teamId,
      search: state.search,
      portfolioId: state.portfolioId,
      programId: programId,
      parentType: state.parentType,
      executionMode: state.executionMode,
      slaStatus: state.slaStatus,
      status: state.status,
    );
  }

  void setWorkstream(String? workstreamId) {
    state = state.copyWith(
      workstreamId: workstreamId,
      clearWorkstreamId: workstreamId == null,
    );
  }

  void setParentType(String? parentType) {
    state = state.copyWith(
      parentType: parentType,
      clearParentType: parentType == null,
    );
  }

  void setExecutionMode(String? executionMode) {
    state = state.copyWith(
      executionMode: executionMode,
      clearExecutionMode: executionMode == null,
    );
  }

  void setSlaStatus(String? slaStatus) {
    state = state.copyWith(
      slaStatus: slaStatus,
      clearSlaStatus: slaStatus == null,
    );
  }

  void setStatus(String? status) {
    state = state.copyWith(
      status: status,
      clearStatus: status == null,
    );
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
  final String? portfolioId;
  final String? programId;
  final String? workstreamId;
  final String? parentType;
  final String? executionMode;
  final String? slaStatus;
  final String? status;

  const DecisionFilterState({
    this.urgency,
    this.type,
    this.teamId,
    this.search,
    this.portfolioId,
    this.programId,
    this.workstreamId,
    this.parentType,
    this.executionMode,
    this.slaStatus,
    this.status,
  });

  DecisionFilterState copyWith({
    DecisionUrgency? urgency,
    DecisionType? type,
    String? teamId,
    String? search,
    String? portfolioId,
    String? programId,
    String? workstreamId,
    String? parentType,
    String? executionMode,
    String? slaStatus,
    String? status,
    bool clearUrgency = false,
    bool clearType = false,
    bool clearTeamId = false,
    bool clearPortfolioId = false,
    bool clearProgramId = false,
    bool clearWorkstreamId = false,
    bool clearParentType = false,
    bool clearExecutionMode = false,
    bool clearSlaStatus = false,
    bool clearStatus = false,
  }) {
    return DecisionFilterState(
      urgency: clearUrgency ? null : (urgency ?? this.urgency),
      type: clearType ? null : (type ?? this.type),
      teamId: clearTeamId ? null : (teamId ?? this.teamId),
      search: search ?? this.search,
      portfolioId:
          clearPortfolioId ? null : (portfolioId ?? this.portfolioId),
      programId: clearProgramId ? null : (programId ?? this.programId),
      workstreamId:
          clearWorkstreamId ? null : (workstreamId ?? this.workstreamId),
      parentType: clearParentType ? null : (parentType ?? this.parentType),
      executionMode:
          clearExecutionMode ? null : (executionMode ?? this.executionMode),
      slaStatus: clearSlaStatus ? null : (slaStatus ?? this.slaStatus),
      status: clearStatus ? null : (status ?? this.status),
    );
  }

  bool get hasFilters =>
      urgency != null ||
      type != null ||
      teamId != null ||
      (search?.isNotEmpty ?? false) ||
      portfolioId != null ||
      programId != null ||
      workstreamId != null ||
      parentType != null ||
      executionMode != null ||
      slaStatus != null ||
      status != null;

  bool get hasV2Filters =>
      portfolioId != null ||
      programId != null ||
      workstreamId != null ||
      parentType != null ||
      executionMode != null ||
      slaStatus != null;
}

/// V2 filtered decisions using server-side filtering
@riverpod
Future<List<Decision>> v2FilteredDecisions(
  V2FilteredDecisionsRef ref,
) async {
  final service = ref.watch(decisionServiceProvider);
  final filters = ref.watch(decisionFiltersProvider);

  List<Decision> decisions;

  if (filters.hasV2Filters) {
    final response = await service.listDecisions(
      portfolioId: filters.portfolioId,
      programId: filters.programId,
      workstreamId: filters.workstreamId,
      parentType: filters.parentType,
      executionMode: filters.executionMode,
      slaStatus: filters.slaStatus,
    );
    decisions = response.content;
  } else {
    decisions = await service.getPendingDecisions();
  }

  // Apply client-side filters (urgency, type, team, search, status)
  return decisions.where((d) {
    if (filters.urgency != null && d.urgency != filters.urgency) return false;
    if (filters.type != null && d.type != filters.type) return false;
    if (filters.teamId != null && d.teamId != filters.teamId) return false;
    if (filters.status != null &&
        d.status.name != filters.status) {
      return false;
    }
    if (filters.search != null && filters.search!.isNotEmpty) {
      final searchLower = filters.search!.toLowerCase();
      if (!d.title.toLowerCase().contains(searchLower) &&
          !(d.description?.toLowerCase().contains(searchLower) ?? false)) {
        return false;
      }
    }
    return true;
  }).toList();
}

/// Filtered decisions grouped by status (for board view)
@riverpod
Future<Map<DecisionStatus, List<Decision>>> decisionsByStatus(
  DecisionsByStatusRef ref,
) async {
  final filtered = await ref.watch(v2FilteredDecisionsProvider.future);

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

/// Queue summary stats
@riverpod
Future<QueueSummaryStats> queueSummaryStats(
  QueueSummaryStatsRef ref,
) async {
  final decisions = await ref.watch(v2FilteredDecisionsProvider.future);

  final total = decisions.length;
  final breached = decisions.where((d) => d.isSlaBreached).length;
  final atRisk = decisions
      .where((d) =>
          !d.isSlaBreached &&
          d.timeToSla != null &&
          d.timeToSla!.inHours < 2)
      .length;
  final onTrack = total - breached - atRisk;

  return QueueSummaryStats(
    total: total,
    breached: breached,
    atRisk: atRisk,
    onTrack: onTrack,
  );
}

class QueueSummaryStats {
  final int total;
  final int breached;
  final int atRisk;
  final int onTrack;

  const QueueSummaryStats({
    required this.total,
    required this.breached,
    required this.atRisk,
    required this.onTrack,
  });
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
      ref.invalidate(v2FilteredDecisionsProvider);

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
      ref.invalidate(v2FilteredDecisionsProvider);

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
