// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_action_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredActivityFeedHash() =>
    r'b8b20342d4c06b7e3264e48c256acdd05b9fe5ab';

/// Filtered activity feed.
///
/// Copied from [filteredActivityFeed].
@ProviderFor(filteredActivityFeed)
final filteredActivityFeedProvider =
    AutoDisposeFutureProvider<List<ActivityEvent>>.internal(
  filteredActivityFeed,
  name: r'filteredActivityFeedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredActivityFeedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredActivityFeedRef
    = AutoDisposeFutureProviderRef<List<ActivityEvent>>;
String _$activityEntityFilterHash() =>
    r'e7b7a4979649bd3d4b933928b90154a563b5d61d';

/// Selected entity type filter for activity feed.
///
/// Copied from [ActivityEntityFilter].
@ProviderFor(ActivityEntityFilter)
final activityEntityFilterProvider =
    AutoDisposeNotifierProvider<ActivityEntityFilter, String?>.internal(
  ActivityEntityFilter.new,
  name: r'activityEntityFilterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activityEntityFilterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ActivityEntityFilter = AutoDisposeNotifier<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
