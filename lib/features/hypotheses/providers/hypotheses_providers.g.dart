// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hypotheses_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredHypothesesHash() =>
    r'e5bc599b93426225418eddb3280b80d8585ad3a3';

/// Filtered hypotheses list
///
/// Copied from [filteredHypotheses].
@ProviderFor(filteredHypotheses)
final filteredHypothesesProvider =
    AutoDisposeFutureProvider<List<Hypothesis>>.internal(
  filteredHypotheses,
  name: r'filteredHypothesesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredHypothesesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FilteredHypothesesRef = AutoDisposeFutureProviderRef<List<Hypothesis>>;
String _$hypothesisDetailHash() => r'f41f7926a6a517f4adeafa2c28a8e72b3905a76a';

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

/// Hypothesis detail with metrics
///
/// Copied from [hypothesisDetail].
@ProviderFor(hypothesisDetail)
const hypothesisDetailProvider = HypothesisDetailFamily();

/// Hypothesis detail with metrics
///
/// Copied from [hypothesisDetail].
class HypothesisDetailFamily extends Family<AsyncValue<Hypothesis>> {
  /// Hypothesis detail with metrics
  ///
  /// Copied from [hypothesisDetail].
  const HypothesisDetailFamily();

  /// Hypothesis detail with metrics
  ///
  /// Copied from [hypothesisDetail].
  HypothesisDetailProvider call(
    String id,
  ) {
    return HypothesisDetailProvider(
      id,
    );
  }

  @override
  HypothesisDetailProvider getProviderOverride(
    covariant HypothesisDetailProvider provider,
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
  String? get name => r'hypothesisDetailProvider';
}

/// Hypothesis detail with metrics
///
/// Copied from [hypothesisDetail].
class HypothesisDetailProvider extends AutoDisposeFutureProvider<Hypothesis> {
  /// Hypothesis detail with metrics
  ///
  /// Copied from [hypothesisDetail].
  HypothesisDetailProvider(
    String id,
  ) : this._internal(
          (ref) => hypothesisDetail(
            ref as HypothesisDetailRef,
            id,
          ),
          from: hypothesisDetailProvider,
          name: r'hypothesisDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$hypothesisDetailHash,
          dependencies: HypothesisDetailFamily._dependencies,
          allTransitiveDependencies:
              HypothesisDetailFamily._allTransitiveDependencies,
          id: id,
        );

  HypothesisDetailProvider._internal(
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
    FutureOr<Hypothesis> Function(HypothesisDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HypothesisDetailProvider._internal(
        (ref) => create(ref as HypothesisDetailRef),
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
  AutoDisposeFutureProviderElement<Hypothesis> createElement() {
    return _HypothesisDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HypothesisDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin HypothesisDetailRef on AutoDisposeFutureProviderRef<Hypothesis> {
  /// The parameter `id` of this provider.
  String get id;
}

class _HypothesisDetailProviderElement
    extends AutoDisposeFutureProviderElement<Hypothesis>
    with HypothesisDetailRef {
  _HypothesisDetailProviderElement(super.provider);

  @override
  String get id => (origin as HypothesisDetailProvider).id;
}

String _$hypothesisFiltersHash() => r'5e4882b87371ba0a61ffd0acb4e7aeec1a1f37c1';

/// Filter state for hypotheses
///
/// Copied from [HypothesisFilters].
@ProviderFor(HypothesisFilters)
final hypothesisFiltersProvider = AutoDisposeNotifierProvider<HypothesisFilters,
    HypothesisFilterState>.internal(
  HypothesisFilters.new,
  name: r'hypothesisFiltersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hypothesisFiltersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HypothesisFilters = AutoDisposeNotifier<HypothesisFilterState>;
String _$transitionHypothesisStatusHash() =>
    r'dfc9dfe84bd09f5398936d64e41f1fb8b4054cf0';

/// Transition hypothesis status
///
/// Copied from [TransitionHypothesisStatus].
@ProviderFor(TransitionHypothesisStatus)
final transitionHypothesisStatusProvider =
    AutoDisposeAsyncNotifierProvider<TransitionHypothesisStatus, void>.internal(
  TransitionHypothesisStatus.new,
  name: r'transitionHypothesisStatusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transitionHypothesisStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TransitionHypothesisStatus = AutoDisposeAsyncNotifier<void>;
String _$validateHypothesisHash() =>
    r'e67b0831e80f311b4d107f685753d65e97e35020';

/// Validate hypothesis (terminal success state)
///
/// Copied from [ValidateHypothesis].
@ProviderFor(ValidateHypothesis)
final validateHypothesisProvider =
    AutoDisposeAsyncNotifierProvider<ValidateHypothesis, void>.internal(
  ValidateHypothesis.new,
  name: r'validateHypothesisProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$validateHypothesisHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ValidateHypothesis = AutoDisposeAsyncNotifier<void>;
String _$invalidateHypothesisHash() =>
    r'a09a6aeb0c29ea0270287a2d6e4d8670c31d1cf7';

/// Invalidate hypothesis (terminal failure state)
///
/// Copied from [InvalidateHypothesis].
@ProviderFor(InvalidateHypothesis)
final invalidateHypothesisProvider =
    AutoDisposeAsyncNotifierProvider<InvalidateHypothesis, void>.internal(
  InvalidateHypothesis.new,
  name: r'invalidateHypothesisProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$invalidateHypothesisHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$InvalidateHypothesis = AutoDisposeAsyncNotifier<void>;
String _$createHypothesisHash() => r'66dd56245ffd1fbc89a485fce88323bfa1393efd';

/// Create hypothesis
///
/// Copied from [CreateHypothesis].
@ProviderFor(CreateHypothesis)
final createHypothesisProvider =
    AutoDisposeAsyncNotifierProvider<CreateHypothesis, void>.internal(
  CreateHypothesis.new,
  name: r'createHypothesisProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createHypothesisHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CreateHypothesis = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
