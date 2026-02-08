// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_action_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredSearchResultsHash() =>
    r'60858df96e1cae85d7dabcb869b00900fae0af6c';

/// Filtered search results based on query and type filter.
///
/// Copied from [filteredSearchResults].
@ProviderFor(filteredSearchResults)
final filteredSearchResultsProvider =
    AutoDisposeFutureProvider<List<SearchResult>>.internal(
  filteredSearchResults,
  name: r'filteredSearchResultsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredSearchResultsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredSearchResultsRef
    = AutoDisposeFutureProviderRef<List<SearchResult>>;
String _$searchQueryHash() => r'a74fdf04dbf795b3f9090a7307b574a8bff68199';

/// Debounced search query state.
///
/// Copied from [SearchQuery].
@ProviderFor(SearchQuery)
final searchQueryProvider =
    AutoDisposeNotifierProvider<SearchQuery, String>.internal(
  SearchQuery.new,
  name: r'searchQueryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$searchQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchQuery = AutoDisposeNotifier<String>;
String _$searchTypeFilterHash() => r'e351e6a9ebc69f7e691c4e9137e9e65ebca604f4';

/// Selected entity type filter.
///
/// Copied from [SearchTypeFilter].
@ProviderFor(SearchTypeFilter)
final searchTypeFilterProvider =
    AutoDisposeNotifierProvider<SearchTypeFilter, String?>.internal(
  SearchTypeFilter.new,
  name: r'searchTypeFilterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$searchTypeFilterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchTypeFilter = AutoDisposeNotifier<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
