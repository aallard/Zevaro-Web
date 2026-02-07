// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dashboardStatsHash() => r'a342652733b5984250b7c428610397524b67174e';

/// Dashboard stats aggregation
///
/// Copied from [dashboardStats].
@ProviderFor(dashboardStats)
final dashboardStatsProvider =
    AutoDisposeFutureProvider<DashboardStats>.internal(
  dashboardStats,
  name: r'dashboardStatsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dashboardStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DashboardStatsRef = AutoDisposeFutureProviderRef<DashboardStats>;
String _$projectDashboardHash() => r'456e5ae7f8cdddc2e56842d23ad73a8703c5b526';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Project-scoped dashboard data
///
/// Copied from [projectDashboard].
@ProviderFor(projectDashboard)
const projectDashboardProvider = ProjectDashboardFamily();

/// Project-scoped dashboard data
///
/// Copied from [projectDashboard].
class ProjectDashboardFamily extends Family<AsyncValue<ProjectDashboard>> {
  /// Project-scoped dashboard data
  ///
  /// Copied from [projectDashboard].
  const ProjectDashboardFamily();

  /// Project-scoped dashboard data
  ///
  /// Copied from [projectDashboard].
  ProjectDashboardProvider call(
    String projectId,
  ) {
    return ProjectDashboardProvider(
      projectId,
    );
  }

  @override
  ProjectDashboardProvider getProviderOverride(
    covariant ProjectDashboardProvider provider,
  ) {
    return call(
      provider.projectId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'projectDashboardProvider';
}

/// Project-scoped dashboard data
///
/// Copied from [projectDashboard].
class ProjectDashboardProvider
    extends AutoDisposeFutureProvider<ProjectDashboard> {
  /// Project-scoped dashboard data
  ///
  /// Copied from [projectDashboard].
  ProjectDashboardProvider(
    String projectId,
  ) : this._internal(
          (ref) => projectDashboard(
            ref as ProjectDashboardRef,
            projectId,
          ),
          from: projectDashboardProvider,
          name: r'projectDashboardProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$projectDashboardHash,
          dependencies: ProjectDashboardFamily._dependencies,
          allTransitiveDependencies:
              ProjectDashboardFamily._allTransitiveDependencies,
          projectId: projectId,
        );

  ProjectDashboardProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.projectId,
  }) : super.internal();

  final String projectId;

  @override
  Override overrideWith(
    FutureOr<ProjectDashboard> Function(ProjectDashboardRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProjectDashboardProvider._internal(
        (ref) => create(ref as ProjectDashboardRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        projectId: projectId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ProjectDashboard> createElement() {
    return _ProjectDashboardProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectDashboardProvider && other.projectId == projectId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProjectDashboardRef on AutoDisposeFutureProviderRef<ProjectDashboard> {
  /// The parameter `projectId` of this provider.
  String get projectId;
}

class _ProjectDashboardProviderElement
    extends AutoDisposeFutureProviderElement<ProjectDashboard>
    with ProjectDashboardRef {
  _ProjectDashboardProviderElement(super.provider);

  @override
  String get projectId => (origin as ProjectDashboardProvider).projectId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
