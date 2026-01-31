// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teams_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$teamsListHash() => r'a72c3b5e785f558438cc0b8ef44dab8b62c6b6ee';

/// All teams the user can see
///
/// Copied from [teamsList].
@ProviderFor(teamsList)
final teamsListProvider = AutoDisposeFutureProvider<List<Team>>.internal(
  teamsList,
  name: r'teamsListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$teamsListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TeamsListRef = AutoDisposeFutureProviderRef<List<Team>>;
String _$teamDetailHash() => r'3031a5acf1b351fcfa434c62dd80699fd23ce408';

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

/// Team detail with members
///
/// Copied from [teamDetail].
@ProviderFor(teamDetail)
const teamDetailProvider = TeamDetailFamily();

/// Team detail with members
///
/// Copied from [teamDetail].
class TeamDetailFamily extends Family<AsyncValue<Team>> {
  /// Team detail with members
  ///
  /// Copied from [teamDetail].
  const TeamDetailFamily();

  /// Team detail with members
  ///
  /// Copied from [teamDetail].
  TeamDetailProvider call(
    String id,
  ) {
    return TeamDetailProvider(
      id,
    );
  }

  @override
  TeamDetailProvider getProviderOverride(
    covariant TeamDetailProvider provider,
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
  String? get name => r'teamDetailProvider';
}

/// Team detail with members
///
/// Copied from [teamDetail].
class TeamDetailProvider extends AutoDisposeFutureProvider<Team> {
  /// Team detail with members
  ///
  /// Copied from [teamDetail].
  TeamDetailProvider(
    String id,
  ) : this._internal(
          (ref) => teamDetail(
            ref as TeamDetailRef,
            id,
          ),
          from: teamDetailProvider,
          name: r'teamDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$teamDetailHash,
          dependencies: TeamDetailFamily._dependencies,
          allTransitiveDependencies:
              TeamDetailFamily._allTransitiveDependencies,
          id: id,
        );

  TeamDetailProvider._internal(
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
    FutureOr<Team> Function(TeamDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TeamDetailProvider._internal(
        (ref) => create(ref as TeamDetailRef),
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
  AutoDisposeFutureProviderElement<Team> createElement() {
    return _TeamDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TeamDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TeamDetailRef on AutoDisposeFutureProviderRef<Team> {
  /// The parameter `id` of this provider.
  String get id;
}

class _TeamDetailProviderElement extends AutoDisposeFutureProviderElement<Team>
    with TeamDetailRef {
  _TeamDetailProviderElement(super.provider);

  @override
  String get id => (origin as TeamDetailProvider).id;
}

String _$addTeamMemberHash() => r'e9b59e0554ffc9440b259e1074ae5cbe4dccb14b';

/// Add team member
///
/// Copied from [AddTeamMember].
@ProviderFor(AddTeamMember)
final addTeamMemberProvider =
    AutoDisposeAsyncNotifierProvider<AddTeamMember, void>.internal(
  AddTeamMember.new,
  name: r'addTeamMemberProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$addTeamMemberHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AddTeamMember = AutoDisposeAsyncNotifier<void>;
String _$updateMemberRoleHash() => r'e467b3e54c9163f768967c356f32c140b7e6fdc4';

/// Update member role
///
/// Copied from [UpdateMemberRole].
@ProviderFor(UpdateMemberRole)
final updateMemberRoleProvider =
    AutoDisposeAsyncNotifierProvider<UpdateMemberRole, void>.internal(
  UpdateMemberRole.new,
  name: r'updateMemberRoleProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateMemberRoleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UpdateMemberRole = AutoDisposeAsyncNotifier<void>;
String _$removeTeamMemberHash() => r'983a6d5a013ce95e1722b162e2cdfc2c724c2ebf';

/// Remove team member
///
/// Copied from [RemoveTeamMember].
@ProviderFor(RemoveTeamMember)
final removeTeamMemberProvider =
    AutoDisposeAsyncNotifierProvider<RemoveTeamMember, void>.internal(
  RemoveTeamMember.new,
  name: r'removeTeamMemberProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$removeTeamMemberHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RemoveTeamMember = AutoDisposeAsyncNotifier<void>;
String _$createTeamHash() => r'0f917c783b24cf10f56d42dbaa28cbf8bac9cff9';

/// Create team
///
/// Copied from [CreateTeam].
@ProviderFor(CreateTeam)
final createTeamProvider =
    AutoDisposeAsyncNotifierProvider<CreateTeam, void>.internal(
  CreateTeam.new,
  name: r'createTeamProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$createTeamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CreateTeam = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
