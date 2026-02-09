import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

part 'outcomes_providers.g.dart';

/// Filter state for outcomes
@riverpod
class OutcomeFilters extends _$OutcomeFilters {
  @override
  OutcomeFilterState build() => const OutcomeFilterState();

  void setStatus(OutcomeStatus? status) {
    state = state.copyWith(status: status, clearStatus: status == null);
  }

  void setPriority(OutcomePriority? priority) {
    state = state.copyWith(priority: priority, clearPriority: priority == null);
  }

  void setTeam(String? teamId) {
    state = state.copyWith(teamId: teamId, clearTeamId: teamId == null);
  }

  void setSearch(String? search) {
    state = state.copyWith(search: search);
  }

  void clearAll() {
    state = const OutcomeFilterState();
  }
}

class OutcomeFilterState {
  final OutcomeStatus? status;
  final OutcomePriority? priority;
  final String? teamId;
  final String? search;

  const OutcomeFilterState({
    this.status,
    this.priority,
    this.teamId,
    this.search,
  });

  OutcomeFilterState copyWith({
    OutcomeStatus? status,
    OutcomePriority? priority,
    String? teamId,
    String? search,
    bool clearStatus = false,
    bool clearPriority = false,
    bool clearTeamId = false,
  }) {
    return OutcomeFilterState(
      status: clearStatus ? null : (status ?? this.status),
      priority: clearPriority ? null : (priority ?? this.priority),
      teamId: clearTeamId ? null : (teamId ?? this.teamId),
      search: search ?? this.search,
    );
  }

  bool get hasFilters =>
      status != null ||
      priority != null ||
      teamId != null ||
      (search?.isNotEmpty ?? false);
}

/// Filtered outcomes list
@riverpod
Future<List<Outcome>> filteredOutcomes(FilteredOutcomesRef ref) async {
  final outcomeService = ref.watch(outcomeServiceProvider);
  final filters = ref.watch(outcomeFiltersProvider);

  final response = await outcomeService.listOutcomes(
    status: filters.status,
    priority: filters.priority,
    teamId: filters.teamId,
  );

  var outcomes = response.content;

  // Client-side search filter
  if (filters.search != null && filters.search!.isNotEmpty) {
    final searchLower = filters.search!.toLowerCase();
    outcomes = outcomes
        .where((o) =>
            o.title.toLowerCase().contains(searchLower) ||
            (o.description?.toLowerCase().contains(searchLower) ?? false))
        .toList();
  }

  return outcomes;
}

/// Outcome detail
@riverpod
Future<Outcome> outcomeDetail(OutcomeDetailRef ref, String id) async {
  final outcomeService = ref.watch(outcomeServiceProvider);
  return outcomeService.getOutcome(id);
}

/// Hypotheses for an outcome
@riverpod
Future<List<Hypothesis>> outcomeHypotheses(
    OutcomeHypothesesRef ref, String outcomeId) async {
  final hypothesisService = ref.watch(hypothesisServiceProvider);
  return hypothesisService.getHypothesesForOutcome(outcomeId);
}

/// Create outcome action
@riverpod
class CreateOutcome extends _$CreateOutcome {
  @override
  FutureOr<void> build() {}

  Future<Outcome?> create(CreateOutcomeRequest request) async {
    state = const AsyncValue.loading();

    try {
      final outcomeService = ref.read(outcomeServiceProvider);
      final outcome = await outcomeService.createOutcome(request);

      ref.invalidate(filteredOutcomesProvider);
      ref.invalidate(myOutcomesProvider);

      state = const AsyncValue.data(null);
      return outcome;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}

/// Update outcome status
@riverpod
class UpdateOutcomeStatus extends _$UpdateOutcomeStatus {
  @override
  FutureOr<void> build() {}

  Future<bool> updateStatus(String outcomeId, OutcomeStatus newStatus) async {
    state = const AsyncValue.loading();

    try {
      final outcomeService = ref.read(outcomeServiceProvider);
      await outcomeService.updateOutcome(
        outcomeId,
        UpdateOutcomeRequest(status: newStatus),
      );

      ref.invalidate(outcomeDetailProvider(outcomeId));
      ref.invalidate(filteredOutcomesProvider);

      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

/// Update key result progress
@riverpod
class UpdateKeyResultProgress extends _$UpdateKeyResultProgress {
  @override
  FutureOr<void> build() {}

  Future<bool> updateProgress(
      String outcomeId, String keyResultId, double newValue) async {
    state = const AsyncValue.loading();

    try {
      final outcomeService = ref.read(outcomeServiceProvider);
      await outcomeService.recordKeyResultProgress(
          outcomeId, keyResultId, newValue);

      ref.invalidate(outcomeDetailProvider(outcomeId));

      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

/// Add key result to an outcome
@riverpod
class AddKeyResult extends _$AddKeyResult {
  @override
  FutureOr<void> build() {}

  Future<KeyResult?> add(String outcomeId, CreateKeyResultRequest request) async {
    state = const AsyncValue.loading();

    try {
      final outcomeService = ref.read(outcomeServiceProvider);
      final keyResult = await outcomeService.addKeyResult(outcomeId, request);

      ref.invalidate(outcomeDetailProvider(outcomeId));

      state = const AsyncValue.data(null);
      return keyResult;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}
