import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quick Actions', style: AppTypography.h4),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                _QuickActionButton(
                  icon: Icons.add_circle_outline,
                  label: 'New Decision',
                  color: AppColors.primary,
                  onTap: () {
                    // TODO: Open create decision modal
                    context.go(Routes.decisions);
                  },
                ),
                _QuickActionButton(
                  icon: Icons.flag_outlined,
                  label: 'New Outcome',
                  color: AppColors.success,
                  onTap: () {
                    // TODO: Open create outcome modal
                    context.go(Routes.outcomes);
                  },
                ),
                _QuickActionButton(
                  icon: Icons.science_outlined,
                  label: 'New Hypothesis',
                  color: AppColors.secondary,
                  onTap: () {
                    // TODO: Open create hypothesis modal
                    context.go(Routes.hypotheses);
                  },
                ),
                _QuickActionButton(
                  icon: Icons.groups_outlined,
                  label: 'Invite Team',
                  color: AppColors.info,
                  onTap: () {
                    // TODO: Open invite modal
                    context.go(Routes.teams);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
