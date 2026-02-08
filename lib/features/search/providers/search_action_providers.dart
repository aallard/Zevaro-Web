import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

part 'search_action_providers.g.dart';

/// Debounced search query state.
@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void set(String query) => state = query;
  void clear() => state = '';
}

/// Selected entity type filter.
@riverpod
class SearchTypeFilter extends _$SearchTypeFilter {
  @override
  String? build() => null;

  void set(String? type) => state = type;
  void clear() => state = null;
}

/// Filtered search results based on query and type filter.
@riverpod
Future<List<SearchResult>> filteredSearchResults(
  FilteredSearchResultsRef ref,
) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) return [];

  final service = ref.watch(searchServiceProvider);
  final typeFilter = ref.watch(searchTypeFilterProvider);

  return service.search(query, type: typeFilter);
}
