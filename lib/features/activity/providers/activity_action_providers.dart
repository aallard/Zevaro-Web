import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

part 'activity_action_providers.g.dart';

/// Selected entity type filter for activity feed.
@riverpod
class ActivityEntityFilter extends _$ActivityEntityFilter {
  @override
  String? build() => null;

  void set(String? type) => state = type;
  void clear() => state = null;
}

/// Filtered activity feed.
@riverpod
Future<List<ActivityEvent>> filteredActivityFeed(
  FilteredActivityFeedRef ref,
) async {
  final service = ref.watch(activityServiceProvider);
  final typeFilter = ref.watch(activityEntityFilterProvider);

  return service.getActivity(entityType: typeFilter, size: 50);
}
