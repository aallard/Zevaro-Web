import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../providers/shell_providers.dart';
import 'sidebar_item.dart';
import 'sidebar_section.dart';

class Sidebar extends ConsumerWidget {
  final String currentRoute;

  const Sidebar({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCollapsed = ref.watch(sidebarCollapsedProvider);
    final pendingDecisions = ref.watch(decisionQueueProvider());
    final myPendingResponses = ref.watch(myPendingResponsesProvider);

    final pendingCount = pendingDecisions.valueOrNull?.length ?? 0;
    final myPendingCount = myPendingResponses.valueOrNull?.length ?? 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isCollapsed
          ? AppSpacing.sidebarCollapsedWidth
          : AppSpacing.sidebarWidth,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          right: BorderSide(color: AppColors.border),
        ),
      ),
      child: Column(
        children: [
          // Logo
          Container(
            height: AppSpacing.headerHeight,
            padding: EdgeInsets.symmetric(
              horizontal: isCollapsed ? AppSpacing.sm : AppSpacing.md,
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: const Center(
                    child: Text(
                      'Z',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (!isCollapsed) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Zevaro',
                    style: AppTypography.h4.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const Divider(height: 1),

          // Navigation items
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                children: [
                  // Main section
                  SidebarSection(
                    isCollapsed: isCollapsed,
                    children: [
                      SidebarItem(
                        icon: Icons.dashboard_outlined,
                        label: 'Dashboard',
                        isSelected: currentRoute == Routes.dashboard,
                        isCollapsed: isCollapsed,
                        onTap: () => context.go(Routes.dashboard),
                      ),
                    ],
                  ),

                  // Core section
                  SidebarSection(
                    title: 'Core',
                    isCollapsed: isCollapsed,
                    children: [
                      SidebarItem(
                        icon: Icons.how_to_vote_outlined,
                        label: 'Decisions',
                        isSelected: currentRoute.startsWith('/decisions'),
                        isCollapsed: isCollapsed,
                        badgeCount: pendingCount,
                        badgeColor: AppColors.error,
                        onTap: () => context.go(Routes.decisions),
                      ),
                      SidebarItem(
                        icon: Icons.flag_outlined,
                        label: 'Outcomes',
                        isSelected: currentRoute.startsWith('/outcomes'),
                        isCollapsed: isCollapsed,
                        onTap: () => context.go(Routes.outcomes),
                      ),
                      SidebarItem(
                        icon: Icons.science_outlined,
                        label: 'Hypotheses',
                        isSelected: currentRoute.startsWith('/hypotheses'),
                        isCollapsed: isCollapsed,
                        onTap: () => context.go(Routes.hypotheses),
                      ),
                    ],
                  ),

                  // Organization section
                  SidebarSection(
                    title: 'Organization',
                    isCollapsed: isCollapsed,
                    children: [
                      SidebarItem(
                        icon: Icons.groups_outlined,
                        label: 'Teams',
                        isSelected: currentRoute.startsWith('/teams'),
                        isCollapsed: isCollapsed,
                        onTap: () => context.go(Routes.teams),
                      ),
                      SidebarItem(
                        icon: Icons.person_search_outlined,
                        label: 'Stakeholders',
                        isSelected: currentRoute.startsWith('/stakeholders'),
                        isCollapsed: isCollapsed,
                        badgeCount: myPendingCount,
                        badgeColor: AppColors.warning,
                        onTap: () => context.go(Routes.stakeholders),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const Divider(height: 1),

          // Collapse toggle
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: SidebarItem(
              icon: isCollapsed ? Icons.chevron_right : Icons.chevron_left,
              label: 'Collapse',
              isSelected: false,
              isCollapsed: isCollapsed,
              onTap: () => ref.read(sidebarCollapsedProvider.notifier).toggle(),
            ),
          ),
        ],
      ),
    );
  }
}
