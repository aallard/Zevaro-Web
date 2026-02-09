// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decisions_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$v2FilteredDecisionsHash() =>
    r'79127f35dff0bb672971832b71b7710c3e81af4d';

/// V2 filtered decisions using server-side filtering
///
/// Copied from [v2FilteredDecisions].
@ProviderFor(v2FilteredDecisions)
final v2FilteredDecisionsProvider =
    AutoDisposeFutureProvider<List<Decision>>.internal(
  v2FilteredDecisions,
  name: r'v2FilteredDecisionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$v2FilteredDecisionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef V2FilteredDecisionsRef = AutoDisposeFutureProviderRef<List<Decision>>;
String _$decisionsByStatusHash() => r'1d8d4db2f16cc025805c2fa923b48d7a74190459';

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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DecisionsByStatusRef
    = AutoDisposeFutureProviderRef<Map<DecisionStatus, List<Decision>>>;
String _$queueSummaryStatsHash() => r'3074b3dd71c7e0db6ffa16d1ad26493d2c423d83';

/// Queue summary stats
///
/// Copied from [queueSummaryStats].
@ProviderFor(queueSummaryStats)
final queueSummaryStatsProvider =
    AutoDisposeFutureProvider<QueueSummaryStats>.internal(
  queueSummaryStats,
  name: r'queueSummaryStatsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$queueSummaryStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef QueueSummaryStatsRef = AutoDisposeFutureProviderRef<QueueSummaryStats>;
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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
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
String _$decisionFiltersHash() => r'290f59a3e0b25d834a0e7f29acdd8fb752fa63b2';

/// V2 filter state with cascading filters
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
String _$createDecisionHash() => r'e2c3177fcdcff4d4cc67fe557534cefa948a4b5d';

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
    r'837ca72d265c402a8ae541b041b297c809f7c01f';

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
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
