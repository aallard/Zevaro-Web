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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredHypothesesRef = AutoDisposeFutureProviderRef<List<Hypothesis>>;
String _$hypothesisDetailHash() => r'dea22b45d150f3b8aaa0f7fe7d400c3fa7ddbd49';

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

/// Hypothesis detail
///
/// Copied from [hypothesisDetail].
@ProviderFor(hypothesisDetail)
const hypothesisDetailProvider = HypothesisDetailFamily();

/// Hypothesis detail
///
/// Copied from [hypothesisDetail].
class HypothesisDetailFamily extends Family<AsyncValue<Hypothesis>> {
  /// Hypothesis detail
  ///
  /// Copied from [hypothesisDetail].
  const HypothesisDetailFamily();

  /// Hypothesis detail
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

/// Hypothesis detail
///
/// Copied from [hypothesisDetail].
class HypothesisDetailProvider extends AutoDisposeFutureProvider<Hypothesis> {
  /// Hypothesis detail
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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
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

String _$hypothesisListHash() => r'9bd5a64d926a60cc7b3ad4d2cc7d3e593674d26b';

/// Hypothesis list provider (for kanban board)
///
/// Copied from [hypothesisList].
@ProviderFor(hypothesisList)
const hypothesisListProvider = HypothesisListFamily();

/// Hypothesis list provider (for kanban board)
///
/// Copied from [hypothesisList].
class HypothesisListFamily extends Family<AsyncValue<List<Hypothesis>>> {
  /// Hypothesis list provider (for kanban board)
  ///
  /// Copied from [hypothesisList].
  const HypothesisListFamily();

  /// Hypothesis list provider (for kanban board)
  ///
  /// Copied from [hypothesisList].
  HypothesisListProvider call({
    required String? programId,
  }) {
    return HypothesisListProvider(
      programId: programId,
    );
  }

  @override
  HypothesisListProvider getProviderOverride(
    covariant HypothesisListProvider provider,
  ) {
    return call(
      programId: provider.programId,
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
  String? get name => r'hypothesisListProvider';
}

/// Hypothesis list provider (for kanban board)
///
/// Copied from [hypothesisList].
class HypothesisListProvider
    extends AutoDisposeFutureProvider<List<Hypothesis>> {
  /// Hypothesis list provider (for kanban board)
  ///
  /// Copied from [hypothesisList].
  HypothesisListProvider({
    required String? programId,
  }) : this._internal(
          (ref) => hypothesisList(
            ref as HypothesisListRef,
            programId: programId,
          ),
          from: hypothesisListProvider,
          name: r'hypothesisListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$hypothesisListHash,
          dependencies: HypothesisListFamily._dependencies,
          allTransitiveDependencies:
              HypothesisListFamily._allTransitiveDependencies,
          programId: programId,
        );

  HypothesisListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.programId,
  }) : super.internal();

  final String? programId;

  @override
  Override overrideWith(
    FutureOr<List<Hypothesis>> Function(HypothesisListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HypothesisListProvider._internal(
        (ref) => create(ref as HypothesisListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        programId: programId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Hypothesis>> createElement() {
    return _HypothesisListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HypothesisListProvider && other.programId == programId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, programId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HypothesisListRef on AutoDisposeFutureProviderRef<List<Hypothesis>> {
  /// The parameter `programId` of this provider.
  String? get programId;
}

class _HypothesisListProviderElement
    extends AutoDisposeFutureProviderElement<List<Hypothesis>>
    with HypothesisListRef {
  _HypothesisListProviderElement(super.provider);

  @override
  String? get programId => (origin as HypothesisListProvider).programId;
}

String _$hypothesisHash() => r'85cd257943b92344bdad955a711d3f41e2abf258';

/// Single hypothesis provider (for detail screen)
///
/// Copied from [hypothesis].
@ProviderFor(hypothesis)
const hypothesisProvider = HypothesisFamily();

/// Single hypothesis provider (for detail screen)
///
/// Copied from [hypothesis].
class HypothesisFamily extends Family<AsyncValue<Hypothesis>> {
  /// Single hypothesis provider (for detail screen)
  ///
  /// Copied from [hypothesis].
  const HypothesisFamily();

  /// Single hypothesis provider (for detail screen)
  ///
  /// Copied from [hypothesis].
  HypothesisProvider call(
    String id,
  ) {
    return HypothesisProvider(
      id,
    );
  }

  @override
  HypothesisProvider getProviderOverride(
    covariant HypothesisProvider provider,
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
  String? get name => r'hypothesisProvider';
}

/// Single hypothesis provider (for detail screen)
///
/// Copied from [hypothesis].
class HypothesisProvider extends AutoDisposeFutureProvider<Hypothesis> {
  /// Single hypothesis provider (for detail screen)
  ///
  /// Copied from [hypothesis].
  HypothesisProvider(
    String id,
  ) : this._internal(
          (ref) => hypothesis(
            ref as HypothesisRef,
            id,
          ),
          from: hypothesisProvider,
          name: r'hypothesisProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$hypothesisHash,
          dependencies: HypothesisFamily._dependencies,
          allTransitiveDependencies:
              HypothesisFamily._allTransitiveDependencies,
          id: id,
        );

  HypothesisProvider._internal(
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
    FutureOr<Hypothesis> Function(HypothesisRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HypothesisProvider._internal(
        (ref) => create(ref as HypothesisRef),
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
    return _HypothesisProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HypothesisProvider && other.id == id;
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
mixin HypothesisRef on AutoDisposeFutureProviderRef<Hypothesis> {
  /// The parameter `id` of this provider.
  String get id;
}

class _HypothesisProviderElement
    extends AutoDisposeFutureProviderElement<Hypothesis> with HypothesisRef {
  _HypothesisProviderElement(super.provider);

  @override
  String get id => (origin as HypothesisProvider).id;
}

String _$hypothesisExperimentsHash() =>
    r'd6ebefcc84a01f44ecceb7c0ac1400a5896019a8';

/// Hypothesis experiments provider
///
/// Copied from [hypothesisExperiments].
@ProviderFor(hypothesisExperiments)
const hypothesisExperimentsProvider = HypothesisExperimentsFamily();

/// Hypothesis experiments provider
///
/// Copied from [hypothesisExperiments].
class HypothesisExperimentsFamily extends Family<AsyncValue<List<Experiment>>> {
  /// Hypothesis experiments provider
  ///
  /// Copied from [hypothesisExperiments].
  const HypothesisExperimentsFamily();

  /// Hypothesis experiments provider
  ///
  /// Copied from [hypothesisExperiments].
  HypothesisExperimentsProvider call(
    String hypothesisId,
  ) {
    return HypothesisExperimentsProvider(
      hypothesisId,
    );
  }

  @override
  HypothesisExperimentsProvider getProviderOverride(
    covariant HypothesisExperimentsProvider provider,
  ) {
    return call(
      provider.hypothesisId,
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
  String? get name => r'hypothesisExperimentsProvider';
}

/// Hypothesis experiments provider
///
/// Copied from [hypothesisExperiments].
class HypothesisExperimentsProvider
    extends AutoDisposeFutureProvider<List<Experiment>> {
  /// Hypothesis experiments provider
  ///
  /// Copied from [hypothesisExperiments].
  HypothesisExperimentsProvider(
    String hypothesisId,
  ) : this._internal(
          (ref) => hypothesisExperiments(
            ref as HypothesisExperimentsRef,
            hypothesisId,
          ),
          from: hypothesisExperimentsProvider,
          name: r'hypothesisExperimentsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$hypothesisExperimentsHash,
          dependencies: HypothesisExperimentsFamily._dependencies,
          allTransitiveDependencies:
              HypothesisExperimentsFamily._allTransitiveDependencies,
          hypothesisId: hypothesisId,
        );

  HypothesisExperimentsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.hypothesisId,
  }) : super.internal();

  final String hypothesisId;

  @override
  Override overrideWith(
    FutureOr<List<Experiment>> Function(HypothesisExperimentsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HypothesisExperimentsProvider._internal(
        (ref) => create(ref as HypothesisExperimentsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        hypothesisId: hypothesisId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Experiment>> createElement() {
    return _HypothesisExperimentsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HypothesisExperimentsProvider &&
        other.hypothesisId == hypothesisId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, hypothesisId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HypothesisExperimentsRef
    on AutoDisposeFutureProviderRef<List<Experiment>> {
  /// The parameter `hypothesisId` of this provider.
  String get hypothesisId;
}

class _HypothesisExperimentsProviderElement
    extends AutoDisposeFutureProviderElement<List<Experiment>>
    with HypothesisExperimentsRef {
  _HypothesisExperimentsProviderElement(super.provider);

  @override
  String get hypothesisId =>
      (origin as HypothesisExperimentsProvider).hypothesisId;
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
    r'945b5d7d32089166134b6e2b8e768f3728fa3950';

/// Validate hypothesis (terminal success state via conclude)
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
    r'7bbacf3f5f0fba4230f0030b03dee71f2cff169d';

/// Invalidate hypothesis (terminal failure state via conclude)
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
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
