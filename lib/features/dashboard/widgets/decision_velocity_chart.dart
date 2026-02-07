import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class DecisionVelocityChart extends StatelessWidget {
  final List<DashboardDailyMetric> metrics;

  const DecisionVelocityChart({super.key, required this.metrics});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Decision Velocity', style: AppTypography.h4),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Decisions resolved per day (30d)',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 200,
            child: metrics.isEmpty
                ? Center(
                    child: Text(
                      'No data yet',
                      style: AppTypography.bodySmall,
                    ),
                  )
                : _SimpleBarChart(metrics: metrics),
          ),
        ],
      ),
    );
  }
}

class _SimpleBarChart extends StatelessWidget {
  final List<DashboardDailyMetric> metrics;

  const _SimpleBarChart({required this.metrics});

  String _getWeekLabel(int index, int total) {
    final daysAgo = total - index - 1;
    if (daysAgo == 0) return 'Now';
    final weeksAgo = (daysAgo / 7).ceil();
    return '${weeksAgo}wk ago';
  }

  @override
  Widget build(BuildContext context) {
    final maxCount = metrics.fold<int>(
        1, (max, m) => m.count > max ? m.count : max);
    final total = metrics.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Bar chart
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: metrics.asMap().entries.map((entry) {
              final index = entry.key;
              final m = entry.value;
              final height = (m.count / maxCount * 140).clamp(4.0, 140.0);
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: Tooltip(
                    message: '${m.count} decisions',
                    child: Container(
                      height: height,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.8),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(2),
                          topRight: Radius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        // X-axis labels
        Row(
          children: metrics.asMap().entries.map((entry) {
            final index = entry.key;
            final label = _getWeekLabel(index, total);
            return Expanded(
              child: Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textTertiary,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
