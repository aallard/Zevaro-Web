// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outcomes_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredOutcomesHash() => r'6cdddab11a57c7caf3717ba54edc6529f2526fbe';

/// Filtered outcomes list
///
/// Copied from [filteredOutcomes].
@ProviderFor(filteredOutcomes)
final filteredOutcomesProvider =
    AutoDisposeFutureProvider<List<Outcome>>.internal(
  filteredOutcomes,
  name: r'filteredOutcomesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredOutcomesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredOutcomesRef = AutoDisposeFutureProviderRef<List<Outcome>>;
String _$outcomeDetailHash() => r'b2697881a3eb51d3032175fe0d02fa7e70bfb74f';

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

/// Outcome detail with key results
///
/// Copied from [outcomeDetail].
@ProviderFor(outcomeDetail)
const outcomeDetailProvider = OutcomeDetailFamily();

/// Outcome detail with key results
///
/// Copied from [outcomeDetail].
class OutcomeDetailFamily extends Family<AsyncValue<Outcome>> {
  /// Outcome detail with key results
  ///
  /// Copied from [outcomeDetail].
  const OutcomeDetailFamily();

  /// Outcome detail with key results
  ///
  /// Copied from [outcomeDetail].
  OutcomeDetailProvider call(
    String id,
  ) {
    return OutcomeDetailProvider(
      id,
    );
  }

  @override
  OutcomeDetailProvider getProviderOverride(
    covariant OutcomeDetailProvider provider,
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
  String? get name => r'outcomeDetailProvider';
}

/// Outcome detail with key results
///
/// Copied from [outcomeDetail].
class OutcomeDetailProvider extends AutoDisposeFutureProvider<Outcome> {
  /// Outcome detail with key results
  ///
  /// Copied from [outcomeDetail].
  OutcomeDetailProvider(
    String id,
  ) : this._internal(
          (ref) => outcomeDetail(
            ref as OutcomeDetailRef,
            id,
          ),
          from: outcomeDetailProvider,
          name: r'outcomeDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$outcomeDetailHash,
          dependencies: OutcomeDetailFamily._dependencies,
          allTransitiveDependencies:
              OutcomeDetailFamily._allTransitiveDependencies,
          id: id,
        );

  OutcomeDetailProvider._internal(
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
    FutureOr<Outcome> Function(OutcomeDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OutcomeDetailProvider._internal(
        (ref) => create(ref as OutcomeDetailRef),
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
  AutoDisposeFutureProviderElement<Outcome> createElement() {
    return _OutcomeDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OutcomeDetailProvider && other.id == id;
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
mixin OutcomeDetailRef on AutoDisposeFutureProviderRef<Outcome> {
  /// The parameter `id` of this provider.
  String get id;
}

class _OutcomeDetailProviderElement
    extends AutoDisposeFutureProviderElement<Outcome> with OutcomeDetailRef {
  _OutcomeDetailProviderElement(super.provider);

  @override
  String get id => (origin as OutcomeDetailProvider).id;
}

String _$outcomeHypothesesHash() => r'5dad68c1219cf2144b4b291e7364a45b947dc757';

/// Hypotheses for an outcome
///
/// Copied from [outcomeHypotheses].
@ProviderFor(outcomeHypotheses)
const outcomeHypothesesProvider = OutcomeHypothesesFamily();

/// Hypotheses for an outcome
///
/// Copied from [outcomeHypotheses].
class OutcomeHypothesesFamily extends Family<AsyncValue<List<Hypothesis>>> {
  /// Hypotheses for an outcome
  ///
  /// Copied from [outcomeHypotheses].
  const OutcomeHypothesesFamily();

  /// Hypotheses for an outcome
  ///
  /// Copied from [outcomeHypotheses].
  OutcomeHypothesesProvider call(
    String outcomeId,
  ) {
    return OutcomeHypothesesProvider(
      outcomeId,
    );
  }

  @override
  OutcomeHypothesesProvider getProviderOverride(
    covariant OutcomeHypothesesProvider provider,
  ) {
    return call(
      provider.outcomeId,
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
  String? get name => r'outcomeHypothesesProvider';
}

/// Hypotheses for an outcome
///
/// Copied from [outcomeHypotheses].
class OutcomeHypothesesProvider
    extends AutoDisposeFutureProvider<List<Hypothesis>> {
  /// Hypotheses for an outcome
  ///
  /// Copied from [outcomeHypotheses].
  OutcomeHypothesesProvider(
    String outcomeId,
  ) : this._internal(
          (ref) => outcomeHypotheses(
            ref as OutcomeHypothesesRef,
            outcomeId,
          ),
          from: outcomeHypothesesProvider,
          name: r'outcomeHypothesesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$outcomeHypothesesHash,
          dependencies: OutcomeHypothesesFamily._dependencies,
          allTransitiveDependencies:
              OutcomeHypothesesFamily._allTransitiveDependencies,
          outcomeId: outcomeId,
        );

  OutcomeHypothesesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.outcomeId,
  }) : super.internal();

  final String outcomeId;

  @override
  Override overrideWith(
    FutureOr<List<Hypothesis>> Function(OutcomeHypothesesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OutcomeHypothesesProvider._internal(
        (ref) => create(ref as OutcomeHypothesesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        outcomeId: outcomeId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Hypothesis>> createElement() {
    return _OutcomeHypothesesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OutcomeHypothesesProvider && other.outcomeId == outcomeId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, outcomeId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin OutcomeHypothesesRef on AutoDisposeFutureProviderRef<List<Hypothesis>> {
  /// The parameter `outcomeId` of this provider.
  String get outcomeId;
}

class _OutcomeHypothesesProviderElement
    extends AutoDisposeFutureProviderElement<List<Hypothesis>>
    with OutcomeHypothesesRef {
  _OutcomeHypothesesProviderElement(super.provider);

  @override
  String get outcomeId => (origin as OutcomeHypothesesProvider).outcomeId;
}

String _$outcomeFiltersHash() => r'212ab0eea4290449e6597f839b24c96e7491adcf';

/// Filter state for outcomes
///
/// Copied from [OutcomeFilters].
@ProviderFor(OutcomeFilters)
final outcomeFiltersProvider =
    AutoDisposeNotifierProvider<OutcomeFilters, OutcomeFilterState>.internal(
  OutcomeFilters.new,
  name: r'outcomeFiltersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$outcomeFiltersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OutcomeFilters = AutoDisposeNotifier<OutcomeFilterState>;
String _$createOutcomeHash() => r'a46ea53930d122d87b10cc45dc45a58e89006bd0';

/// Create outcome action
///
/// Copied from [CreateOutcome].
@ProviderFor(CreateOutcome)
final createOutcomeProvider =
    AutoDisposeAsyncNotifierProvider<CreateOutcome, void>.internal(
  CreateOutcome.new,
  name: r'createOutcomeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createOutcomeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CreateOutcome = AutoDisposeAsyncNotifier<void>;
String _$updateOutcomeStatusHash() =>
    r'3c3b4545153fe37ae5ff96433a84d6389291f78a';

/// Update outcome status
///
/// Copied from [UpdateOutcomeStatus].
@ProviderFor(UpdateOutcomeStatus)
final updateOutcomeStatusProvider =
    AutoDisposeAsyncNotifierProvider<UpdateOutcomeStatus, void>.internal(
  UpdateOutcomeStatus.new,
  name: r'updateOutcomeStatusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateOutcomeStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UpdateOutcomeStatus = AutoDisposeAsyncNotifier<void>;
String _$updateKeyResultProgressHash() =>
    r'67eedd3163f2f6093f9e0df14571214de61f27dc';

/// Update key result progress
///
/// Copied from [UpdateKeyResultProgress].
@ProviderFor(UpdateKeyResultProgress)
final updateKeyResultProgressProvider =
    AutoDisposeAsyncNotifierProvider<UpdateKeyResultProgress, void>.internal(
  UpdateKeyResultProgress.new,
  name: r'updateKeyResultProgressProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateKeyResultProgressHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UpdateKeyResultProgress = AutoDisposeAsyncNotifier<void>;
String _$addKeyResultHash() => r'75c09739980d6da23293eb57249885e531ed7545';

/// Add key result to an outcome
///
/// Copied from [AddKeyResult].
@ProviderFor(AddKeyResult)
final addKeyResultProvider =
    AutoDisposeAsyncNotifierProvider<AddKeyResult, void>.internal(
  AddKeyResult.new,
  name: r'addKeyResultProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$addKeyResultHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AddKeyResult = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
