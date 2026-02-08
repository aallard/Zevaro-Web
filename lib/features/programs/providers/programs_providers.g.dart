// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'programs_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredProgramsHash() => r'83077983cda9f64bed082d184358f8cb255f2d04';

/// Filtered program list
///
/// Copied from [filteredPrograms].
@ProviderFor(filteredPrograms)
final filteredProgramsProvider =
    AutoDisposeFutureProvider<List<Program>>.internal(
  filteredPrograms,
  name: r'filteredProgramsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredProgramsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredProgramsRef = AutoDisposeFutureProviderRef<List<Program>>;
String _$programViewModeNotifierHash() =>
    r'67ff04c3d670923a86626addfda3e2538be77720';

/// See also [ProgramViewModeNotifier].
@ProviderFor(ProgramViewModeNotifier)
final programViewModeNotifierProvider = AutoDisposeNotifierProvider<
    ProgramViewModeNotifier, ProgramViewMode>.internal(
  ProgramViewModeNotifier.new,
  name: r'programViewModeNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$programViewModeNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProgramViewModeNotifier = AutoDisposeNotifier<ProgramViewMode>;
String _$programFiltersHash() => r'0b90795c3992e96a9c454b241310065cb9baaa49';

/// Program filter state
///
/// Copied from [ProgramFilters].
@ProviderFor(ProgramFilters)
final programFiltersProvider =
    AutoDisposeNotifierProvider<ProgramFilters, ProgramFilterState>.internal(
  ProgramFilters.new,
  name: r'programFiltersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$programFiltersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProgramFilters = AutoDisposeNotifier<ProgramFilterState>;
String _$createProgramHash() => r'8ccc8b7f3642d946da98dd83321b7dff25fe01ba';

/// Create program action
///
/// Copied from [CreateProgram].
@ProviderFor(CreateProgram)
final createProgramProvider =
    AutoDisposeAsyncNotifierProvider<CreateProgram, void>.internal(
  CreateProgram.new,
  name: r'createProgramProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createProgramHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CreateProgram = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
