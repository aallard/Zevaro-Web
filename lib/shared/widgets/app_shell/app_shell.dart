import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import 'sidebar.dart';
import 'header.dart';

class AppShell extends ConsumerWidget {
  final Widget child;
  final String title;
  final List<Widget>? actions;

  const AppShell({
    super.key,
    required this.child,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < AppConstants.tabletBreakpoint;
    final currentRoute = GoRouterState.of(context).matchedLocation;

    // Mobile layout with drawer
    if (isMobile) {
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: actions,
        ),
        drawer: Drawer(
          child: Sidebar(currentRoute: currentRoute),
        ),
        body: child,
      );
    }

    // Desktop layout with persistent sidebar
    return Scaffold(
      body: Row(
        children: [
          Sidebar(currentRoute: currentRoute),
          Expanded(
            child: Column(
              children: [
                AppHeader(title: title, actions: actions),
                Expanded(
                  child: Container(
                    color: AppColors.background,
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
