// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experiments_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredExperimentsHash() =>
    r'3303c3f6f458f9b36220b98faf1a44d26dc65b3d';

/// Filtered experiments
///
/// Copied from [filteredExperiments].
@ProviderFor(filteredExperiments)
final filteredExperimentsProvider =
    AutoDisposeFutureProvider<List<Experiment>>.internal(
  filteredExperiments,
  name: r'filteredExperimentsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredExperimentsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredExperimentsRef = AutoDisposeFutureProviderRef<List<Experiment>>;
String _$allExperimentsHash() => r'4109877ad88f0600ed62d617de14032ef3675531';

/// All experiments (for summary stats)
///
/// Copied from [allExperiments].
@ProviderFor(allExperiments)
final allExperimentsProvider =
    AutoDisposeFutureProvider<List<Experiment>>.internal(
  allExperiments,
  name: r'allExperimentsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allExperimentsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllExperimentsRef = AutoDisposeFutureProviderRef<List<Experiment>>;
String _$experimentDetailHash() => r'9d34a6bfe99cf3554dc4c93c23ec07a95e238561';

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

/// Experiment detail
///
/// Copied from [experimentDetail].
@ProviderFor(experimentDetail)
const experimentDetailProvider = ExperimentDetailFamily();

/// Experiment detail
///
/// Copied from [experimentDetail].
class ExperimentDetailFamily extends Family<AsyncValue<Experiment>> {
  /// Experiment detail
  ///
  /// Copied from [experimentDetail].
  const ExperimentDetailFamily();

  /// Experiment detail
  ///
  /// Copied from [experimentDetail].
  ExperimentDetailProvider call(
    String id,
  ) {
    return ExperimentDetailProvider(
      id,
    );
  }

  @override
  ExperimentDetailProvider getProviderOverride(
    covariant ExperimentDetailProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'experimentDetailProvider';
}

/// Experiment detail
///
/// Copied from [experimentDetail].
class ExperimentDetailProvider extends AutoDisposeFutureProvider<Experiment> {
  /// Experiment detail
  ///
  /// Copied from [experimentDetail].
  ExperimentDetailProvider(
    String id,
  ) : this._internal(
          (ref) => experimentDetail(
            ref as ExperimentDetailRef,
            id,
          ),
          from: experimentDetailProvider,
          name: r'experimentDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$experimentDetailHash,
          dependencies: ExperimentDetailFamily._dependencies,
          allTransitiveDependencies:
              ExperimentDetailFamily._allTransitiveDependencies,
          id: id,
        );

  ExperimentDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<Experiment> Function(ExperimentDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExperimentDetailProvider._internal(
        (ref) => create(ref as ExperimentDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Experiment> createElement() {
    return _ExperimentDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExperimentDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExperimentDetailRef on AutoDisposeFutureProviderRef<Experiment> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ExperimentDetailProviderElement
    extends AutoDisposeFutureProviderElement<Experiment>
    with ExperimentDetailRef {
  _ExperimentDetailProviderElement(super.provider);

  @override
  String get id => (origin as ExperimentDetailProvider).id;
}

String _$experimentFilterNotifierHash() =>
    r'4bd28bddac1ecb179d0220db828f2df94aef9a54';

/// See also [ExperimentFilterNotifier].
@ProviderFor(ExperimentFilterNotifier)
final experimentFilterNotifierProvider = AutoDisposeNotifierProvider<
    ExperimentFilterNotifier, ExperimentFilterTab>.internal(
  ExperimentFilterNotifier.new,
  name: r'experimentFilterNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$experimentFilterNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ExperimentFilterNotifier = AutoDisposeNotifier<ExperimentFilterTab>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
