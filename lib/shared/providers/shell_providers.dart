import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

part 'shell_providers.g.dart';

/// Sidebar collapsed state
@riverpod
class SidebarCollapsed extends _$SidebarCollapsed {
  @override
  bool build() => false;

  void toggle() => state = !state;
  void collapse() => state = true;
  void expand() => state = false;
}

/// Current navigation index (for highlighting)
@riverpod
class CurrentNavIndex extends _$CurrentNavIndex {
  @override
  int build() => 0;

  void setIndex(int index) => state = index;
}

/// Selected project ID (from SDK)
@riverpod
String? selectedProjectId(Ref ref) {
  return ref.watch(selectedProjectIdProvider);
}

/// Selected project details (from SDK)
@riverpod
Future<Project?> selectedProject(Ref ref) async {
  final projectId = ref.watch(selectedProjectIdProvider);
  if (projectId == null) {
    return null;
  }
  // This would need to fetch the project from the SDK or a provider
  // For now, return null and let the SDK handle it
  return null;
}
