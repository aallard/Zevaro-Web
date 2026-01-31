import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class SlaIndicator extends StatelessWidget {
  final Decision decision;
  final bool showIcon;

  const SlaIndicator({
    super.key,
    required this.decision,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final isBreach = decision.isSlaBreached;
    final color = isBreach ? AppColors.error : AppColors.textSecondary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showIcon) ...[
          Icon(
            isBreach ? Icons.timer_off : Icons.timer_outlined,
            size: 14,
            color: color,
          ),
          const SizedBox(width: AppSpacing.xxs),
        ],
        Text(
          decision.slaStatusDisplay,
          style: AppTypography.bodySmall.copyWith(
            color: color,
            fontWeight: isBreach ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
