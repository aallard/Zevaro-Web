import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class SlaIndicator extends StatelessWidget {
  final Decision decision;
  final bool showIcon;
  final bool compact;

  const SlaIndicator({
    super.key,
    required this.decision,
    this.showIcon = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final breached = decision.isSlaBreached;

    if (compact) {
      // Compact version for cards
      final color = breached ? AppColors.error : AppColors.success;
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            breached ? Icons.local_fire_department : Icons.check_circle,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 2),
          Text(
            breached ? 'SLA Breached' : 'Within SLA',
            style: AppTypography.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    // Full version for details screen
    if (breached) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.local_fire_department,
                size: 12, color: AppColors.error),
            const SizedBox(width: 2),
            Text(
              'SLA Breached',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, size: 12, color: AppColors.success),
          const SizedBox(width: 2),
          Text(
            'Within SLA',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
