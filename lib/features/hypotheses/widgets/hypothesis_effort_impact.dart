import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class HypothesisEffortImpact extends StatelessWidget {
  final Hypothesis hypothesis;
  final bool showLabels;

  const HypothesisEffortImpact({
    super.key,
    required this.hypothesis,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SizeChip(
          label: showLabels ? 'Effort' : null,
          size: hypothesis.effortDisplay,
          color: _getEffortColor(hypothesis.effort),
          icon: Icons.work_outline,
        ),
        const SizedBox(width: AppSpacing.md),
        _SizeChip(
          label: showLabels ? 'Impact' : null,
          size: hypothesis.impactDisplay,
          color: _getImpactColor(hypothesis.impact),
          icon: Icons.trending_up,
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xxs,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.score, size: 14, color: AppColors.primary),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                'Score: ${hypothesis.priorityScore}',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getEffortColor(String? effort) {
    switch (effort) {
      case 'XS':
      case 'S':
        return AppColors.success;
      case 'M':
        return AppColors.warning;
      case 'L':
      case 'XL':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  Color _getImpactColor(String? impact) {
    switch (impact) {
      case 'LOW':
        return AppColors.error;
      case 'MEDIUM':
        return AppColors.warning;
      case 'HIGH':
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }
}

class _SizeChip extends StatelessWidget {
  final String? label;
  final String size;
  final Color color;
  final IconData icon;

  const _SizeChip({
    this.label,
    required this.size,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Text(
            label!,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        if (label != null) const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xxs,
          ),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                size,
                style: AppTypography.labelMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
