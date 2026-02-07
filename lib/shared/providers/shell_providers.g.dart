// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shell_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedProjectIdHash() => r'14cc79b1a84dff7cfb5b7fa608b471c5fca4e5e4';

/// Selected project ID (from SDK)
///
/// Copied from [selectedProjectId].
@ProviderFor(selectedProjectId)
final selectedProjectIdProvider = AutoDisposeProvider<String?>.internal(
  selectedProjectId,
  name: r'selectedProjectIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedProjectIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedProjectIdRef = AutoDisposeProviderRef<String?>;
String _$selectedProjectHash() => r'd8e9f319734da38c0c2cf624adf6023d4853c5e7';

/// Selected project details (from SDK)
///
/// Copied from [selectedProject].
@ProviderFor(selectedProject)
final selectedProjectProvider = AutoDisposeFutureProvider<Project?>.internal(
  selectedProject,
  name: r'selectedProjectProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedProjectHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedProjectRef = AutoDisposeFutureProviderRef<Project?>;
String _$sidebarCollapsedHash() => r'543dbbb35288c3827db285783f0404f524135d20';

/// Sidebar collapsed state
///
/// Copied from [SidebarCollapsed].
@ProviderFor(SidebarCollapsed)
final sidebarCollapsedProvider =
    AutoDisposeNotifierProvider<SidebarCollapsed, bool>.internal(
  SidebarCollapsed.new,
  name: r'sidebarCollapsedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sidebarCollapsedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SidebarCollapsed = AutoDisposeNotifier<bool>;
String _$currentNavIndexHash() => r'907164ca0e294d0a80b450e0b82949f035b4c69c';

/// Current navigation index (for highlighting)
///
/// Copied from [CurrentNavIndex].
@ProviderFor(CurrentNavIndex)
final currentNavIndexProvider =
    AutoDisposeNotifierProvider<CurrentNavIndex, int>.internal(
  CurrentNavIndex.new,
  name: r'currentNavIndexProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentNavIndexHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentNavIndex = AutoDisposeNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
