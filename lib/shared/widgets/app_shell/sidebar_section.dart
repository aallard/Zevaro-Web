import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class SidebarSection extends StatelessWidget {
  final String? title;
  final bool isCollapsed;
  final List<Widget> children;

  const SidebarSection({
    super.key,
    this.title,
    required this.isCollapsed,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null && !isCollapsed)
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.md,
              bottom: AppSpacing.xs,
              top: AppSpacing.md,
            ),
            child: Text(
              title!.toUpperCase(),
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textTertiary,
                letterSpacing: 1,
              ),
            ),
          ),
        ...children,
      ],
    );
  }
}
