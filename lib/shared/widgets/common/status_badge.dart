import 'package:flutter/material.dart';
import 'package:zevaro_web/core/theme/app_colors.dart';
import 'package:zevaro_web/core/theme/app_spacing.dart';
import 'package:zevaro_web/core/theme/app_typography.dart';

/// A generic status badge that works with any enum that provides
/// [displayName] and [color] (hex string) properties.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.compact = false,
    this.icon,
  });

  /// Create from any status enum that has .displayName and .color extensions
  factory StatusBadge.fromStatus({
    Key? key,
    required String displayName,
    required String hexColor,
    bool compact = false,
    IconData? icon,
  }) {
    return StatusBadge(
      key: key,
      label: displayName,
      color: _parseHex(hexColor),
      compact: compact,
      icon: icon,
    );
  }

  final String label;
  final Color color;
  final bool compact;
  final IconData? icon;

  static Color _parseHex(String hex) {
    final cleaned = hex.replaceFirst('#', '');
    return Color(int.parse('0xFF$cleaned'));
  }

  @override
  Widget build(BuildContext context) {
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
          if (icon != null && !compact) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: (compact ? AppTypography.labelSmall : AppTypography.labelMedium).copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Priority badge specifically for urgency levels
class PriorityBadge extends StatelessWidget {
  const PriorityBadge({
    super.key,
    required this.label,
    this.compact = false,
  });

  final String label;
  final bool compact;

  Color get _color {
    switch (label.toUpperCase()) {
      case 'BLOCKING':
        return AppColors.urgencyBlocking;
      case 'HIGH':
        return AppColors.urgencyHigh;
      case 'NORMAL':
        return AppColors.urgencyNormal;
      case 'LOW':
      default:
        return AppColors.urgencyLow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatusBadge(
      label: label,
      color: _color,
      compact: compact,
      icon: label.toUpperCase() == 'BLOCKING' ? Icons.block : null,
    );
  }
}
