import 'package:flutter/material.dart';
import 'package:zevaro_web/core/theme/app_colors.dart';
import 'package:zevaro_web/core/theme/app_spacing.dart';
import 'package:zevaro_web/core/theme/app_typography.dart';

/// A consistent section header used across detail screens
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.trailing,
    this.icon,
    this.padding,
  });

  final String title;
  final Widget? trailing;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            title,
            style: AppTypography.h4.copyWith(color: AppColors.textPrimary),
          ),
          if (trailing != null) ...[
            const Spacer(),
            trailing!,
          ],
        ],
      ),
    );
  }
}
