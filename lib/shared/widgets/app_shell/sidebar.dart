import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../providers/shell_providers.dart';
import '../common/avatar.dart';

class Sidebar extends ConsumerWidget {
  final String currentRoute;

  const Sidebar({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCollapsed = ref.watch(sidebarCollapsedProvider);
    final selectedProgramId = ref.watch(selectedProgramIdProvider);
    final selectedProgram = ref.watch(selectedProgramProvider);
    final currentUser = ref.watch(currentUserProvider);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isCollapsed
          ? AppSpacing.sidebarCollapsedWidth
          : AppSpacing.sidebarWidth,
      decoration: BoxDecoration(
        color: AppColors.sidebarBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(2, 0),
          ),
        ],
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
                    color: AppColors.sidebarAccent,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.sidebarAccent.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Z',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ),
                if (!isCollapsed) ...[
                  const SizedBox(width: AppSpacing.sm),
                  const Text(
                    'Zevaro',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),

          Container(height: 1, color: AppColors.sidebarDivider),

          // Program selector with accent bar
          if (!isCollapsed) ...[
            _ProgramSelector(
              selectedProgram: selectedProgram.valueOrNull,
              onTap: () => context.go(Routes.programs),
            ),
            Container(height: 1, color: AppColors.sidebarDivider),
          ],

          // Navigation items
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.xs,
                horizontal: AppSpacing.xs,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SidebarNavItem(
                    icon: Icons.business_center_outlined,
                    label: 'Portfolios',
                    isSelected: currentRoute == Routes.portfolios ||
                        currentRoute.startsWith('/portfolios'),
                    isCollapsed: isCollapsed,
                    onTap: () => context.go(Routes.portfolios),
                  ),
                  _SidebarNavItem(
                    icon: Icons.folder_outlined,
                    label: 'Programs',
                    isSelected: currentRoute == Routes.programs ||
                        currentRoute.startsWith('/programs'),
                    isCollapsed: isCollapsed,
                    onTap: () => context.go(Routes.programs),
                  ),

                  const SizedBox(height: AppSpacing.xs),
                  if (!isCollapsed && selectedProgramId != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: AppSpacing.sm,
                        top: AppSpacing.xs,
                        bottom: AppSpacing.xxs,
                      ),
                      child: Text(
                        (selectedProgram.valueOrNull?.name ?? 'PROGRAM')
                            .toUpperCase(),
                        style: TextStyle(
                          color: AppColors.sidebarText.withOpacity(0.5),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  _SidebarNavItem(
                    icon: Icons.bolt_outlined,
                    label: 'Decision Queue',
                    isSelected: currentRoute.startsWith('/decisions'),
                    isCollapsed: isCollapsed,
                    onTap: () => context.go(Routes.decisions),
                  ),
                  _SidebarNavItem(
                    icon: Icons.flag_outlined,
                    label: 'Outcomes',
                    isSelected: currentRoute.startsWith('/outcomes'),
                    isCollapsed: isCollapsed,
                    onTap: () => context.go(Routes.outcomes),
                  ),
                  _SidebarNavItem(
                    icon: Icons.lightbulb_outlined,
                    label: 'Hypotheses',
                    isSelected: currentRoute.startsWith('/hypotheses'),
                    isCollapsed: isCollapsed,
                    onTap: () => context.go(Routes.hypotheses),
                  ),
                  _SidebarNavItem(
                    icon: Icons.science_outlined,
                    label: 'Experiments',
                    isSelected: currentRoute.startsWith('/experiments'),
                    isCollapsed: isCollapsed,
                    onTap: () => context.go(Routes.experiments),
                  ),
                  _SidebarNavItem(
                    icon: Icons.people_outlined,
                    label: 'Team',
                    isSelected: currentRoute.startsWith('/teams'),
                    isCollapsed: isCollapsed,
                    onTap: () => context.go(Routes.teams),
                  ),
                ],
              ),
            ),
          ),

          Container(height: 1, color: AppColors.sidebarDivider),

          // Bottom: Settings + User
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xs),
            child: Column(
              children: [
                _SidebarNavItem(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  isSelected: currentRoute.startsWith('/settings'),
                  isCollapsed: isCollapsed,
                  onTap: () => context.go(Routes.settings),
                ),
                const SizedBox(height: 4),
                // User avatar at bottom
                _UserProfile(
                  user: currentUser.valueOrNull,
                  isCollapsed: isCollapsed,
                  onTap: () => context.go(Routes.profile),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// User avatar + name at the bottom of sidebar
class _UserProfile extends StatefulWidget {
  final User? user;
  final bool isCollapsed;
  final VoidCallback onTap;

  const _UserProfile({
    required this.user,
    required this.isCollapsed,
    required this.onTap,
  });

  @override
  State<_UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<_UserProfile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final name = widget.user != null
        ? '${widget.user!.firstName} ${widget.user!.lastName}'
        : 'User';
    final avatarUrl = widget.user?.avatarUrl;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: widget.isCollapsed ? AppSpacing.sm : AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: _isHovered
                ? AppColors.sidebarBgHover
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Row(
            mainAxisAlignment: widget.isCollapsed
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              ZAvatar(
                name: name,
                imageUrl: avatarUrl,
                size: 28,
              ),
              if (!widget.isCollapsed) ...[
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: AppColors.sidebarText,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgramSelector extends StatelessWidget {
  final Program? selectedProgram;
  final VoidCallback onTap;

  const _ProgramSelector({
    required this.selectedProgram,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            if (selectedProgram != null) ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _programColor(selectedProgram!.color),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            Expanded(
              child: Text(
                selectedProgram?.name ?? 'Select a program...',
                style: TextStyle(
                  color: selectedProgram != null
                      ? AppColors.sidebarTextActive
                      : AppColors.sidebarText.withOpacity(0.7),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.unfold_more,
              size: 16,
              color: AppColors.sidebarText.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }

  Color _programColor(String? hex) {
    if (hex != null) {
      try {
        return Color(
            int.parse('FF${hex.replaceFirst('#', '')}', radix: 16));
      } catch (_) {}
    }
    return AppColors.sidebarAccent;
  }
}

class _SidebarNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isCollapsed;
  final VoidCallback onTap;
  final int? badgeCount;

  const _SidebarNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.isCollapsed,
    required this.onTap,
    this.badgeCount,
  });

  @override
  State<_SidebarNavItem> createState() => _SidebarNavItemState();
}

class _SidebarNavItemState extends State<_SidebarNavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 1),
          padding: EdgeInsets.symmetric(
            horizontal: widget.isCollapsed ? AppSpacing.sm : AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColors.sidebarAccent.withOpacity(0.15)
                : _isHovered
                    ? AppColors.sidebarBgHover
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Row(
            mainAxisAlignment: widget.isCollapsed
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Icon(
                widget.icon,
                size: 20,
                color: widget.isSelected
                    ? AppColors.sidebarAccent
                    : AppColors.sidebarText,
              ),
              if (!widget.isCollapsed) ...[
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      color: widget.isSelected
                          ? AppColors.sidebarTextActive
                          : AppColors.sidebarText,
                      fontSize: 14,
                      fontWeight: widget.isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
                if (widget.badgeCount != null && widget.badgeCount! > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                    child: Text(
                      '${widget.badgeCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
