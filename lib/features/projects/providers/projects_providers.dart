import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

part 'projects_providers.g.dart';

/// View mode toggle (card vs list)
enum ProjectViewMode { card, list }

@riverpod
class ProjectViewModeNotifier extends _$ProjectViewModeNotifier {
  @override
  ProjectViewMode build() => ProjectViewMode.card;

  void setCard() => state = ProjectViewMode.card;
  void setList() => state = ProjectViewMode.list;
  void toggle() => state = state == ProjectViewMode.card
      ? ProjectViewMode.list
      : ProjectViewMode.card;
}

/// Project filter state
@riverpod
class ProjectFilters extends _$ProjectFilters {
  @override
  ProjectFilterState build() => const ProjectFilterState();

  void setStatus(ProjectStatus? status) {
    state = ProjectFilterState(status: status, search: state.search);
  }

  void setSearch(String? search) {
    state = ProjectFilterState(status: state.status, search: search);
  }

  void clearAll() {
    state = const ProjectFilterState();
  }
}

class ProjectFilterState {
  final ProjectStatus? status;
  final String? search;

  const ProjectFilterState({this.status, this.search});

  bool get hasFilters =>
      status != null || (search?.isNotEmpty ?? false);
}

/// Filtered project list
@riverpod
Future<List<Project>> filteredProjects(FilteredProjectsRef ref) async {
  final service = ref.watch(projectServiceProvider);
  final filters = ref.watch(projectFiltersProvider);

  final projects = await service.listProjects(status: filters.status);

  if (filters.search != null && filters.search!.isNotEmpty) {
    final searchLower = filters.search!.toLowerCase();
    return projects.where((p) =>
        p.name.toLowerCase().contains(searchLower) ||
        (p.description?.toLowerCase().contains(searchLower) ?? false)
    ).toList();
  }

  return projects;
}

/// Create project action
@riverpod
class CreateProject extends _$CreateProject {
  @override
  FutureOr<void> build() {}

  Future<Project?> create(CreateProjectRequest request) async {
    state = const AsyncValue.loading();

    try {
      final service = ref.read(projectServiceProvider);
      final project = await service.createProject(request);

      ref.invalidate(filteredProjectsProvider);

      state = const AsyncValue.data(null);
      return project;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}
