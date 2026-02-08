import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

part 'programs_providers.g.dart';

/// View mode toggle (card vs list)
enum ProgramViewMode { card, list }

@riverpod
class ProgramViewModeNotifier extends _$ProgramViewModeNotifier {
  @override
  ProgramViewMode build() => ProgramViewMode.card;

  void setCard() => state = ProgramViewMode.card;
  void setList() => state = ProgramViewMode.list;
  void toggle() => state = state == ProgramViewMode.card
      ? ProgramViewMode.list
      : ProgramViewMode.card;
}

/// Program filter state
@riverpod
class ProgramFilters extends _$ProgramFilters {
  @override
  ProgramFilterState build() => const ProgramFilterState();

  void setStatus(ProgramStatus? status) {
    state = ProgramFilterState(status: status, search: state.search);
  }

  void setSearch(String? search) {
    state = ProgramFilterState(status: state.status, search: search);
  }

  void clearAll() {
    state = const ProgramFilterState();
  }
}

class ProgramFilterState {
  final ProgramStatus? status;
  final String? search;

  const ProgramFilterState({this.status, this.search});

  bool get hasFilters =>
      status != null || (search?.isNotEmpty ?? false);
}

/// Filtered program list
@riverpod
Future<List<Program>> filteredPrograms(FilteredProgramsRef ref) async {
  final service = ref.watch(programServiceProvider);
  final filters = ref.watch(programFiltersProvider);

  final programs = await service.listPrograms(status: filters.status);

  if (filters.search != null && filters.search!.isNotEmpty) {
    final searchLower = filters.search!.toLowerCase();
    return programs.where((p) =>
        p.name.toLowerCase().contains(searchLower) ||
        (p.description?.toLowerCase().contains(searchLower) ?? false)
    ).toList();
  }

  return programs;
}

/// Create program action
@riverpod
class CreateProgram extends _$CreateProgram {
  @override
  FutureOr<void> build() {}

  Future<Program?> create(CreateProgramRequest request) async {
    state = const AsyncValue.loading();

    try {
      final service = ref.read(programServiceProvider);
      final program = await service.createProgram(request);

      ref.invalidate(filteredProgramsProvider);

      state = const AsyncValue.data(null);
      return program;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}
