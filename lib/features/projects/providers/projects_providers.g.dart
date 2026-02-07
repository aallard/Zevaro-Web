// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projects_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredProjectsHash() => r'c41c4e351fd85677fbc6c04793218099aa3c4ded';

/// Filtered project list
///
/// Copied from [filteredProjects].
@ProviderFor(filteredProjects)
final filteredProjectsProvider =
    AutoDisposeFutureProvider<List<Project>>.internal(
  filteredProjects,
  name: r'filteredProjectsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredProjectsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredProjectsRef = AutoDisposeFutureProviderRef<List<Project>>;
String _$projectViewModeNotifierHash() =>
    r'8b9ab051c64065197b6baece579bfd6533c03c36';

/// See also [ProjectViewModeNotifier].
@ProviderFor(ProjectViewModeNotifier)
final projectViewModeNotifierProvider = AutoDisposeNotifierProvider<
    ProjectViewModeNotifier, ProjectViewMode>.internal(
  ProjectViewModeNotifier.new,
  name: r'projectViewModeNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$projectViewModeNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProjectViewModeNotifier = AutoDisposeNotifier<ProjectViewMode>;
String _$projectFiltersHash() => r'ed3fd69ec3ddbec537fedddeb3a74f860a80d42d';

/// Project filter state
///
/// Copied from [ProjectFilters].
@ProviderFor(ProjectFilters)
final projectFiltersProvider =
    AutoDisposeNotifierProvider<ProjectFilters, ProjectFilterState>.internal(
  ProjectFilters.new,
  name: r'projectFiltersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$projectFiltersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProjectFilters = AutoDisposeNotifier<ProjectFilterState>;
String _$createProjectHash() => r'f83a0e48a98b4dbfeef11ac4cede4a16f266f790';

/// Create project action
///
/// Copied from [CreateProject].
@ProviderFor(CreateProject)
final createProjectProvider =
    AutoDisposeAsyncNotifierProvider<CreateProject, void>.internal(
  CreateProject.new,
  name: r'createProjectProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createProjectHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CreateProject = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
