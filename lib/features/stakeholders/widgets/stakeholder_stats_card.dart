import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class StakeholderStatsCard extends StatelessWidget {
  final Stakeholder stakeholder;

  const StakeholderStatsCard({super.key, required this.stakeholder});

  @override
  Widget build(BuildContext context) {
    final stats = stakeholder.stats;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Response Statistics', style: AppTypography.h4),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _StatBox(
                    icon: Icons.timer_outlined,
                    label: 'Avg Response',
                    value: stats?.avgResponseTimeDisplay ?? '—',
                    color: _getResponseTimeColor(stats?.avgResponseTimeMinutes),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _StatBox(
                    icon: Icons.check_circle_outline,
                    label: 'SLA Compliance',
                    value: stats?.slaComplianceDisplay ?? '—',
                    color: _getSlaColor(stats?.slaComplianceRate),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _StatBox(
                    icon: Icons.trending_up,
                    label: 'Total Responses',
                    value: '${stats?.respondedDecisions ?? 0}',
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _StatBox(
                    icon: _getTrendIcon(stats),
                    label: 'Trend',
                    value: _getTrendLabel(stats),
                    color: _getTrendColor(stats),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getResponseTimeColor(double? minutes) {
    if (minutes == null) return AppColors.textSecondary;
    if (minutes <= 30) return AppColors.success;
    if (minutes <= 120) return AppColors.warning;
    return AppColors.error;
  }

  Color _getSlaColor(double? rate) {
    if (rate == null) return AppColors.textSecondary;
    if (rate >= 0.9) return AppColors.success;
    if (rate >= 0.7) return AppColors.warning;
    return AppColors.error;
  }

  IconData _getTrendIcon(StakeholderStats? stats) {
    if (stats == null) return Icons.trending_flat;
    if (stats.isImproving) return Icons.trending_up;
    if (stats.isDeclining) return Icons.trending_down;
    return Icons.trending_flat;
  }

  String _getTrendLabel(StakeholderStats? stats) {
    if (stats == null) return '—';
    if (stats.isImproving) return 'Improving';
    if (stats.isDeclining) return 'Declining';
    return 'Stable';
  }

  Color _getTrendColor(StakeholderStats? stats) {
    if (stats == null) return AppColors.textSecondary;
    if (stats.isImproving) return AppColors.success;
    if (stats.isDeclining) return AppColors.error;
    return AppColors.textSecondary;
  }
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatBox({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTypography.h3.copyWith(color: color),
          ),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
