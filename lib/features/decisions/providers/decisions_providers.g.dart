// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decisions_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$decisionsByStatusHash() => r'73fa585c5caf663a519280539ff8653ecb1fd172';

/// Filtered decisions grouped by status (for board view)
///
/// Copied from [decisionsByStatus].
@ProviderFor(decisionsByStatus)
final decisionsByStatusProvider =
    AutoDisposeFutureProvider<Map<DecisionStatus, List<Decision>>>.internal(
  decisionsByStatus,
  name: r'decisionsByStatusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$decisionsByStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DecisionsByStatusRef
    = AutoDisposeFutureProviderRef<Map<DecisionStatus, List<Decision>>>;
String _$decisionViewModeHash() => r'b4bbd53b443ee9ca3ecf3a8eae3705ae3f8b02eb';

/// View mode toggle (board vs list)
///
/// Copied from [DecisionViewMode].
@ProviderFor(DecisionViewMode)
final decisionViewModeProvider =
    AutoDisposeNotifierProvider<DecisionViewMode, ViewMode>.internal(
  DecisionViewMode.new,
  name: r'decisionViewModeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$decisionViewModeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DecisionViewMode = AutoDisposeNotifier<ViewMode>;
String _$decisionFiltersHash() => r'dbf78a2e934814dc0a7fcd6a25c985b82f5e44c6';

/// Filter state
///
/// Copied from [DecisionFilters].
@ProviderFor(DecisionFilters)
final decisionFiltersProvider =
    AutoDisposeNotifierProvider<DecisionFilters, DecisionFilterState>.internal(
  DecisionFilters.new,
  name: r'decisionFiltersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$decisionFiltersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DecisionFilters = AutoDisposeNotifier<DecisionFilterState>;
String _$createDecisionHash() => r'817f93ae26209a77f5e2c08558d8379b58739ff5';

/// Create decision action
///
/// Copied from [CreateDecision].
@ProviderFor(CreateDecision)
final createDecisionProvider =
    AutoDisposeAsyncNotifierProvider<CreateDecision, void>.internal(
  CreateDecision.new,
  name: r'createDecisionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createDecisionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CreateDecision = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
