// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stakeholders_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$stakeholderDetailHash() => r'662eaa9b022119adff797e4925d43eb3fe1318b8';

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

/// Stakeholder detail with stats
///
/// Copied from [stakeholderDetail].
@ProviderFor(stakeholderDetail)
const stakeholderDetailProvider = StakeholderDetailFamily();

/// Stakeholder detail with stats
///
/// Copied from [stakeholderDetail].
class StakeholderDetailFamily extends Family<AsyncValue<Stakeholder>> {
  /// Stakeholder detail with stats
  ///
  /// Copied from [stakeholderDetail].
  const StakeholderDetailFamily();

  /// Stakeholder detail with stats
  ///
  /// Copied from [stakeholderDetail].
  StakeholderDetailProvider call(
    String id,
  ) {
    return StakeholderDetailProvider(
      id,
    );
  }

  @override
  StakeholderDetailProvider getProviderOverride(
    covariant StakeholderDetailProvider provider,
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
  String? get name => r'stakeholderDetailProvider';
}

/// Stakeholder detail with stats
///
/// Copied from [stakeholderDetail].
class StakeholderDetailProvider extends AutoDisposeFutureProvider<Stakeholder> {
  /// Stakeholder detail with stats
  ///
  /// Copied from [stakeholderDetail].
  StakeholderDetailProvider(
    String id,
  ) : this._internal(
          (ref) => stakeholderDetail(
            ref as StakeholderDetailRef,
            id,
          ),
          from: stakeholderDetailProvider,
          name: r'stakeholderDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$stakeholderDetailHash,
          dependencies: StakeholderDetailFamily._dependencies,
          allTransitiveDependencies:
              StakeholderDetailFamily._allTransitiveDependencies,
          id: id,
        );

  StakeholderDetailProvider._internal(
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
    FutureOr<Stakeholder> Function(StakeholderDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StakeholderDetailProvider._internal(
        (ref) => create(ref as StakeholderDetailRef),
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
  AutoDisposeFutureProviderElement<Stakeholder> createElement() {
    return _StakeholderDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StakeholderDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin StakeholderDetailRef on AutoDisposeFutureProviderRef<Stakeholder> {
  /// The parameter `id` of this provider.
  String get id;
}

class _StakeholderDetailProviderElement
    extends AutoDisposeFutureProviderElement<Stakeholder>
    with StakeholderDetailRef {
  _StakeholderDetailProviderElement(super.provider);

  @override
  String get id => (origin as StakeholderDetailProvider).id;
}

String _$myStakeholderProfileHash() =>
    r'452b7c2d3be2420499879674e1c715eff60445dd';

/// My stakeholder profile
///
/// Copied from [myStakeholderProfile].
@ProviderFor(myStakeholderProfile)
final myStakeholderProfileProvider =
    AutoDisposeFutureProvider<Stakeholder>.internal(
  myStakeholderProfile,
  name: r'myStakeholderProfileProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$myStakeholderProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MyStakeholderProfileRef = AutoDisposeFutureProviderRef<Stakeholder>;
String _$leaderboardPeriodHash() => r'c1fd36f7766a4025ad52f3c3455c67c7f9911039';

/// Leaderboard view mode
///
/// Copied from [LeaderboardPeriod].
@ProviderFor(LeaderboardPeriod)
final leaderboardPeriodProvider =
    AutoDisposeNotifierProvider<LeaderboardPeriod, String>.internal(
  LeaderboardPeriod.new,
  name: r'leaderboardPeriodProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$leaderboardPeriodHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LeaderboardPeriod = AutoDisposeNotifier<String>;
String _$sendReminderHash() => r'4a91c4b035c8d1d808117c0b07b076458f86cfb6';

/// Send reminder to stakeholder
///
/// Copied from [SendReminder].
@ProviderFor(SendReminder)
final sendReminderProvider =
    AutoDisposeAsyncNotifierProvider<SendReminder, void>.internal(
  SendReminder.new,
  name: r'sendReminderProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$sendReminderHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SendReminder = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
