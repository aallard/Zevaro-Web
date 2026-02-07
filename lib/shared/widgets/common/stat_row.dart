import 'package:flutter/material.dart';
import 'package:zevaro_web/core/theme/app_colors.dart';
import 'package:zevaro_web/core/theme/app_typography.dart';

/// A dot-separated row of stats, e.g. "12 Decisions · 8 Outcomes · 23 Hypotheses"
class StatRow extends StatelessWidget {
  const StatRow({
    super.key,
    required this.stats,
    this.style,
    this.separator = ' · ',
  });

  final List<String> stats;
  final TextStyle? style;
  final String separator;

  @override
  Widget build(BuildContext context) {
    final textStyle = style ??
        AppTypography.bodySmall.copyWith(color: AppColors.textTertiary);

    return Text(
      stats.where((s) => s.isNotEmpty).join(separator),
      style: textStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// A single labeled stat with an optional icon
class StatChip extends StatelessWidget {
  const StatChip({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.color,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppColors.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: chipColor),
            const SizedBox(width: 4),
          ],
          Text(
            '$value $label',
            style: AppTypography.labelSmall.copyWith(color: chipColor),
          ),
        ],
      ),
    );
  }
}
