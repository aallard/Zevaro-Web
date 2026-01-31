import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class HypothesisBlockingAlert extends StatelessWidget {
  final Hypothesis hypothesis;

  const HypothesisBlockingAlert({super.key, required this.hypothesis});

  @override
  Widget build(BuildContext context) {
    if (hypothesis.status != HypothesisStatus.BLOCKED) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.block, color: AppColors.error),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Blocked by Decision',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.error,
                  ),
                ),
                Text(
                  'This hypothesis cannot proceed until a decision is made.',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
