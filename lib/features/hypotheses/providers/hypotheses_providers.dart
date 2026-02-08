import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

part 'hypotheses_providers.g.dart';

/// Filter state for hypotheses
@riverpod
class HypothesisFilters extends _$HypothesisFilters {
  @override
  HypothesisFilterState build() => const HypothesisFilterState();

  void setStatus(HypothesisStatus? status) {
    state = state.copyWith(status: status, clearStatus: status == null);
  }

  void setOutcome(String? outcomeId) {
    state = state.copyWith(outcomeId: outcomeId, clearOutcomeId: outcomeId == null);
  }

  void setTeam(String? teamId) {
    state = state.copyWith(teamId: teamId, clearTeamId: teamId == null);
  }

  void setOnlyBlocked(bool onlyBlocked) {
    state = state.copyWith(onlyBlocked: onlyBlocked);
  }

  void setSearch(String? search) {
    state = state.copyWith(search: search);
  }

  void clearAll() {
    state = const HypothesisFilterState();
  }
}

class HypothesisFilterState {
  final HypothesisStatus? status;
  final String? outcomeId;
  final String? teamId;
  final bool onlyBlocked;
  final String? search;

  const HypothesisFilterState({
    this.status,
    this.outcomeId,
    this.teamId,
    this.onlyBlocked = false,
    this.search,
  });

  HypothesisFilterState copyWith({
    HypothesisStatus? status,
    String? outcomeId,
    String? teamId,
    bool? onlyBlocked,
    String? search,
    bool clearStatus = false,
    bool clearOutcomeId = false,
    bool clearTeamId = false,
  }) {
    return HypothesisFilterState(
      status: clearStatus ? null : (status ?? this.status),
      outcomeId: clearOutcomeId ? null : (outcomeId ?? this.outcomeId),
      teamId: clearTeamId ? null : (teamId ?? this.teamId),
      onlyBlocked: onlyBlocked ?? this.onlyBlocked,
      search: search ?? this.search,
    );
  }

  bool get hasFilters =>
      status != null ||
      outcomeId != null ||
      teamId != null ||
      onlyBlocked ||
      (search?.isNotEmpty ?? false);
}

/// Filtered hypotheses list
@riverpod
Future<List<Hypothesis>> filteredHypotheses(FilteredHypothesesRef ref) async {
  final hypothesisService = ref.watch(hypothesisServiceProvider);
  final filters = ref.watch(hypothesisFiltersProvider);

  List<Hypothesis> hypotheses;

  if (filters.onlyBlocked) {
    hypotheses = await hypothesisService.getBlockedHypotheses();
  } else {
    final response = await hypothesisService.listHypotheses(
      status: filters.status,
      outcomeId: filters.outcomeId,
      teamId: filters.teamId,
    );
    hypotheses = response.content;
  }

  // Client-side search filter
  if (filters.search != null && filters.search!.isNotEmpty) {
    final searchLower = filters.search!.toLowerCase();
    hypotheses = hypotheses
        .where((h) =>
            h.statement.toLowerCase().contains(searchLower) ||
            (h.description?.toLowerCase().contains(searchLower) ?? false))
        .toList();
  }

  // Sort by priority score (highest first)
  hypotheses.sort((a, b) => b.priorityScore.compareTo(a.priorityScore));

  return hypotheses;
}

/// Hypothesis detail with metrics
@riverpod
Future<Hypothesis> hypothesisDetail(HypothesisDetailRef ref, String id) async {
  final hypothesisService = ref.watch(hypothesisServiceProvider);
  return hypothesisService.getHypothesisWithMetrics(id);
}

/// Transition hypothesis status
@riverpod
class TransitionHypothesisStatus extends _$TransitionHypothesisStatus {
  @override
  FutureOr<void> build() {}

  Future<bool> transition(String hypothesisId, HypothesisStatus newStatus) async {
    state = const AsyncValue.loading();

    try {
      final hypothesisService = ref.read(hypothesisServiceProvider);
      await hypothesisService.transitionStatus(hypothesisId, newStatus);

      ref.invalidate(hypothesisDetailProvider(hypothesisId));
      ref.invalidate(filteredHypothesesProvider);
      ref.invalidate(blockedHypothesesProvider);

      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

/// Validate hypothesis (terminal success state)
@riverpod
class ValidateHypothesis extends _$ValidateHypothesis {
  @override
  FutureOr<void> build() {}

  Future<bool> validate(String hypothesisId, {String? notes}) async {
    state = const AsyncValue.loading();

    try {
      final hypothesisService = ref.read(hypothesisServiceProvider);
      await hypothesisService.validate(hypothesisId, notes: notes);

      ref.invalidate(hypothesisDetailProvider(hypothesisId));
      ref.invalidate(filteredHypothesesProvider);

      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

/// Invalidate hypothesis (terminal failure state)
@riverpod
class InvalidateHypothesis extends _$InvalidateHypothesis {
  @override
  FutureOr<void> build() {}

  Future<bool> invalidate(String hypothesisId, {String? notes}) async {
    state = const AsyncValue.loading();

    try {
      final hypothesisService = ref.read(hypothesisServiceProvider);
      await hypothesisService.invalidate(hypothesisId, notes: notes);

      ref.invalidate(hypothesisDetailProvider(hypothesisId));
      ref.invalidate(filteredHypothesesProvider);

      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

/// Create hypothesis
@riverpod
class CreateHypothesis extends _$CreateHypothesis {
  @override
  FutureOr<void> build() {}

  Future<Hypothesis?> create(CreateHypothesisRequest request) async {
    state = const AsyncValue.loading();

    try {
      final hypothesisService = ref.read(hypothesisServiceProvider);
      final hypothesis = await hypothesisService.createHypothesis(request);

      ref.invalidate(filteredHypothesesProvider);
      ref.invalidate(myHypothesesProvider);

      state = const AsyncValue.data(null);
      return hypothesis;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}

/// Hypothesis list provider (for kanban board)
@riverpod
Future<List<Hypothesis>> hypothesisList(
  HypothesisListRef ref, {
  required String? programId,
}) async {
  final hypothesisService = ref.watch(hypothesisServiceProvider);

  if (programId == null) {
    return [];
  }

  final response = await hypothesisService.listHypotheses();
  return response.content;
}

/// Single hypothesis provider (for detail screen)
@riverpod
Future<Hypothesis> hypothesis(HypothesisRef ref, String id) async {
  final hypothesisService = ref.watch(hypothesisServiceProvider);
  return hypothesisService.getHypothesis(id);
}

/// Hypothesis experiments provider
@riverpod
Future<List<Experiment>> hypothesisExperiments(
  HypothesisExperimentsRef ref,
  String hypothesisId,
) async {
  // TODO: SDK does not yet expose getHypothesisExperiments
  return [];
}
