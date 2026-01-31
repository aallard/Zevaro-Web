import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import 'key_result_progress.dart';

class KeyResultCard extends StatelessWidget {
  final KeyResult keyResult;
  final VoidCallback? onUpdateProgress;

  const KeyResultCard({
    super.key,
    required this.keyResult,
    this.onUpdateProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: keyResult.isAchieved
            ? Border.all(color: AppColors.success.withOpacity(0.3))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (keyResult.isAchieved)
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xs),
                  child: Icon(
                    Icons.check_circle,
                    size: 16,
                    color: AppColors.success,
                  ),
                ),
              Expanded(
                child: Text(
                  keyResult.description,
                  style: AppTypography.labelMedium.copyWith(
                    decoration:
                        keyResult.isAchieved ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              if (onUpdateProgress != null && !keyResult.isAchieved)
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  onPressed: onUpdateProgress,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: AppColors.textSecondary,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          KeyResultProgress(keyResult: keyResult),
          if (keyResult.isOverdue && !keyResult.isAchieved) ...[
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Icon(Icons.warning_amber, size: 14, color: AppColors.error),
                const SizedBox(width: AppSpacing.xxs),
                Text(
                  'Overdue',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
