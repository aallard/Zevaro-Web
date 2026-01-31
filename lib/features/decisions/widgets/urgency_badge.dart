import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class UrgencyBadge extends StatelessWidget {
  final DecisionUrgency urgency;
  final bool compact;

  const UrgencyBadge({
    super.key,
    required this.urgency,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        Color(int.parse(urgency.color.replaceFirst('#', '0xFF')));

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.xs : AppSpacing.sm,
        vertical: compact ? 2 : AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!compact) ...[
            Icon(
              _getIcon(),
              size: 14,
              color: color,
            ),
            const SizedBox(width: AppSpacing.xxs),
          ],
          Text(
            urgency.displayName,
            style: (compact ? AppTypography.labelSmall : AppTypography.labelMedium)
                .copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon() {
    switch (urgency) {
      case DecisionUrgency.BLOCKING:
        return Icons.block;
      case DecisionUrgency.HIGH:
        return Icons.priority_high;
      case DecisionUrgency.NORMAL:
        return Icons.schedule;
      case DecisionUrgency.LOW:
        return Icons.low_priority;
    }
  }
}
