import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../common/badge.dart';

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isCollapsed;
  final int? badgeCount;
  final Color? badgeColor;
  final VoidCallback onTap;

  const SidebarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.isCollapsed,
    this.badgeCount,
    this.badgeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: isCollapsed ? label : '',
      preferBelow: false,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isCollapsed ? AppSpacing.sm : AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Row(
            mainAxisAlignment:
                isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    icon,
                    size: 22,
                    color:
                        isSelected ? AppColors.primary : AppColors.textSecondary,
                  ),
                  if (badgeCount != null && badgeCount! > 0 && isCollapsed)
                    Positioned(
                      right: -8,
                      top: -4,
                      child: ZBadge(count: badgeCount!, color: badgeColor),
                    ),
                ],
              ),
              if (!isCollapsed) ...[
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    label,
                    style: AppTypography.labelLarge.copyWith(
                      color:
                          isSelected ? AppColors.primary : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
                if (badgeCount != null && badgeCount! > 0)
                  ZBadge(count: badgeCount!, color: badgeColor),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
