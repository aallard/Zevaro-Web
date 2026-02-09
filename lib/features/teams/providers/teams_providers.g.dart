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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TeamsListRef = AutoDisposeFutureProviderRef<List<Team>>;
String _$teamDetailHash() => r'3fab750a2d905365de97a1c0ebe0c04dae894647';

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

/// Team detail
///
/// Copied from [teamDetail].
@ProviderFor(teamDetail)
const teamDetailProvider = TeamDetailFamily();

/// Team detail
///
/// Copied from [teamDetail].
class TeamDetailFamily extends Family<AsyncValue<Team>> {
  /// Team detail
  ///
  /// Copied from [teamDetail].
  const TeamDetailFamily();

  /// Team detail
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

/// Team detail
///
/// Copied from [teamDetail].
class TeamDetailProvider extends AutoDisposeFutureProvider<Team> {
  /// Team detail
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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
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

String _$availableUsersHash() => r'b2fc90c560bd6fb8f4bcecd4e77b3098fdbb1718';

/// Users available to invite (not already team members)
///
/// Copied from [availableUsers].
@ProviderFor(availableUsers)
const availableUsersProvider = AvailableUsersFamily();

/// Users available to invite (not already team members)
///
/// Copied from [availableUsers].
class AvailableUsersFamily extends Family<AsyncValue<List<User>>> {
  /// Users available to invite (not already team members)
  ///
  /// Copied from [availableUsers].
  const AvailableUsersFamily();

  /// Users available to invite (not already team members)
  ///
  /// Copied from [availableUsers].
  AvailableUsersProvider call(
    String teamId,
  ) {
    return AvailableUsersProvider(
      teamId,
    );
  }

  @override
  AvailableUsersProvider getProviderOverride(
    covariant AvailableUsersProvider provider,
  ) {
    return call(
      provider.teamId,
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
  String? get name => r'availableUsersProvider';
}

/// Users available to invite (not already team members)
///
/// Copied from [availableUsers].
class AvailableUsersProvider extends AutoDisposeFutureProvider<List<User>> {
  /// Users available to invite (not already team members)
  ///
  /// Copied from [availableUsers].
  AvailableUsersProvider(
    String teamId,
  ) : this._internal(
          (ref) => availableUsers(
            ref as AvailableUsersRef,
            teamId,
          ),
          from: availableUsersProvider,
          name: r'availableUsersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$availableUsersHash,
          dependencies: AvailableUsersFamily._dependencies,
          allTransitiveDependencies:
              AvailableUsersFamily._allTransitiveDependencies,
          teamId: teamId,
        );

  AvailableUsersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.teamId,
  }) : super.internal();

  final String teamId;

  @override
  Override overrideWith(
    FutureOr<List<User>> Function(AvailableUsersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AvailableUsersProvider._internal(
        (ref) => create(ref as AvailableUsersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        teamId: teamId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<User>> createElement() {
    return _AvailableUsersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AvailableUsersProvider && other.teamId == teamId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, teamId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AvailableUsersRef on AutoDisposeFutureProviderRef<List<User>> {
  /// The parameter `teamId` of this provider.
  String get teamId;
}

class _AvailableUsersProviderElement
    extends AutoDisposeFutureProviderElement<List<User>>
    with AvailableUsersRef {
  _AvailableUsersProviderElement(super.provider);

  @override
  String get teamId => (origin as AvailableUsersProvider).teamId;
}

String _$teamMembersWithStatsHash() =>
    r'366ca4e1ebe43c9957920510eb3720f40dfbf775';

/// Team members with their statistics (for Team & People screen)
///
/// Copied from [teamMembersWithStats].
@ProviderFor(teamMembersWithStats)
final teamMembersWithStatsProvider =
    AutoDisposeFutureProvider<List<TeamMember>>.internal(
  teamMembersWithStats,
  name: r'teamMembersWithStatsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$teamMembersWithStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TeamMembersWithStatsRef
    = AutoDisposeFutureProviderRef<List<TeamMember>>;
String _$teamStakeholdersHash() => r'6dde7a9233b1a19527707d9243d502ea5e997133';

/// Team stakeholders (for Team & People screen)
///
/// Copied from [teamStakeholders].
@ProviderFor(teamStakeholders)
final teamStakeholdersProvider =
    AutoDisposeFutureProvider<List<Stakeholder>>.internal(
  teamStakeholders,
  name: r'teamStakeholdersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$teamStakeholdersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TeamStakeholdersRef = AutoDisposeFutureProviderRef<List<Stakeholder>>;
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
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
