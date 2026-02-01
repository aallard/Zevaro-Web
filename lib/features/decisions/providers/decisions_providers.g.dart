// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decisions_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$decisionsByStatusHash() => r'25eda2e8437a01357dfc1959dafe43b8c305ddfd';

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
String _$decisionDetailHash() => r'79e2b04f492ef3f82f3589ac399eefe2b461e9dd';

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

/// Selected decision for detail view
///
/// Copied from [decisionDetail].
@ProviderFor(decisionDetail)
const decisionDetailProvider = DecisionDetailFamily();

/// Selected decision for detail view
///
/// Copied from [decisionDetail].
class DecisionDetailFamily extends Family<AsyncValue<Decision>> {
  /// Selected decision for detail view
  ///
  /// Copied from [decisionDetail].
  const DecisionDetailFamily();

  /// Selected decision for detail view
  ///
  /// Copied from [decisionDetail].
  DecisionDetailProvider call(
    String id,
  ) {
    return DecisionDetailProvider(
      id,
    );
  }

  @override
  DecisionDetailProvider getProviderOverride(
    covariant DecisionDetailProvider provider,
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
  String? get name => r'decisionDetailProvider';
}

/// Selected decision for detail view
///
/// Copied from [decisionDetail].
class DecisionDetailProvider extends AutoDisposeFutureProvider<Decision> {
  /// Selected decision for detail view
  ///
  /// Copied from [decisionDetail].
  DecisionDetailProvider(
    String id,
  ) : this._internal(
          (ref) => decisionDetail(
            ref as DecisionDetailRef,
            id,
          ),
          from: decisionDetailProvider,
          name: r'decisionDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$decisionDetailHash,
          dependencies: DecisionDetailFamily._dependencies,
          allTransitiveDependencies:
              DecisionDetailFamily._allTransitiveDependencies,
          id: id,
        );

  DecisionDetailProvider._internal(
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
    FutureOr<Decision> Function(DecisionDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DecisionDetailProvider._internal(
        (ref) => create(ref as DecisionDetailRef),
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
  AutoDisposeFutureProviderElement<Decision> createElement() {
    return _DecisionDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DecisionDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DecisionDetailRef on AutoDisposeFutureProviderRef<Decision> {
  /// The parameter `id` of this provider.
  String get id;
}

class _DecisionDetailProviderElement
    extends AutoDisposeFutureProviderElement<Decision> with DecisionDetailRef {
  _DecisionDetailProviderElement(super.provider);

  @override
  String get id => (origin as DecisionDetailProvider).id;
}

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
String _$voteOnDecisionHash() => r'b9f464404172647def6dd79bd96435f54a741fc8';

/// Vote on a decision
///
/// Copied from [VoteOnDecision].
@ProviderFor(VoteOnDecision)
final voteOnDecisionProvider =
    AutoDisposeAsyncNotifierProvider<VoteOnDecision, void>.internal(
  VoteOnDecision.new,
  name: r'voteOnDecisionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$voteOnDecisionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$VoteOnDecision = AutoDisposeAsyncNotifier<void>;
String _$resolveDecisionActionHash() =>
    r'699cb0a61daadd51ed5bab592e22e9d9933dd68b';

/// Resolve a decision
///
/// Copied from [ResolveDecisionAction].
@ProviderFor(ResolveDecisionAction)
final resolveDecisionActionProvider =
    AutoDisposeAsyncNotifierProvider<ResolveDecisionAction, void>.internal(
  ResolveDecisionAction.new,
  name: r'resolveDecisionActionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$resolveDecisionActionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ResolveDecisionAction = AutoDisposeAsyncNotifier<void>;
String _$addDecisionCommentHash() =>
    r'ad6e4895404eba4d0811cbfedbd70bf4d51e57d5';

/// Add comment to a decision
///
/// Copied from [AddDecisionComment].
@ProviderFor(AddDecisionComment)
final addDecisionCommentProvider =
    AutoDisposeAsyncNotifierProvider<AddDecisionComment, void>.internal(
  AddDecisionComment.new,
  name: r'addDecisionCommentProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$addDecisionCommentHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AddDecisionComment = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
