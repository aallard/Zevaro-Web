import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class KeyResultProgress extends StatelessWidget {
  final KeyResult keyResult;
  final bool showLabel;

  const KeyResultProgress({
    super.key,
    required this.keyResult,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final progress = keyResult.progressPercent / 100;
    final color = _getColor();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel)
          Row(
            children: [
              Expanded(
                child: Text(
                  '${keyResult.currentValue.toStringAsFixed(0)} / ${keyResult.targetValue.toStringAsFixed(0)} ${keyResult.unit}',
                  style: AppTypography.bodySmall,
                ),
              ),
              Text(
                '${keyResult.progressPercent.toStringAsFixed(0)}%',
                style: AppTypography.labelMedium.copyWith(
                  color: color,
                ),
              ),
            ],
          ),
        if (showLabel) const SizedBox(height: AppSpacing.xxs),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Color _getColor() {
    if (keyResult.isAchieved) return AppColors.success;
    if (keyResult.isOverdue) return AppColors.error;
    if (keyResult.progressPercent >= 70) return AppColors.success;
    if (keyResult.progressPercent >= 40) return AppColors.warning;
    return AppColors.primary;
  }
}
