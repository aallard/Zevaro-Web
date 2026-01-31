import 'package:riverpod_annotation/riverpod_annotation.dart';

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
