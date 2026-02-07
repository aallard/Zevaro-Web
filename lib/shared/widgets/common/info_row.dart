import 'package:flutter/material.dart';
import 'package:zevaro_web/core/theme/app_colors.dart';
import 'package:zevaro_web/core/theme/app_spacing.dart';
import 'package:zevaro_web/core/theme/app_typography.dart';

/// A key-value row for sidebars and detail panels
class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.valueWidget,
    this.labelWidth = 100,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Widget? valueWidget;
  final double labelWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: labelWidth,
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 14, color: AppColors.textTertiary),
                  const SizedBox(width: 4),
                ],
                Text(
                  label,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: valueWidget ??
                Text(
                  value,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
