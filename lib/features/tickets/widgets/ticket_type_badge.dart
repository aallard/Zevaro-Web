import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class TicketTypeBadge extends StatelessWidget {
  final TicketType type;

  const TicketTypeBadge({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 12, color: _textColor),
          const SizedBox(width: 4),
          Text(
            _label,
            style: AppTypography.labelSmall.copyWith(
              color: _textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String get _label {
    switch (type) {
      case TicketType.BUG:
        return 'Bug';
      case TicketType.ENHANCEMENT:
        return 'Enhancement';
      case TicketType.MAINTENANCE:
        return 'Maintenance';
      case TicketType.SECURITY:
        return 'Security';
      case TicketType.TECH_DEBT:
        return 'Tech Debt';
    }
  }

  IconData get _icon {
    switch (type) {
      case TicketType.BUG:
        return Icons.bug_report_outlined;
      case TicketType.ENHANCEMENT:
        return Icons.auto_awesome_outlined;
      case TicketType.MAINTENANCE:
        return Icons.build_outlined;
      case TicketType.SECURITY:
        return Icons.shield_outlined;
      case TicketType.TECH_DEBT:
        return Icons.code_outlined;
    }
  }

  Color get _backgroundColor {
    switch (type) {
      case TicketType.BUG:
        return AppColors.error.withOpacity(0.1);
      case TicketType.ENHANCEMENT:
        return AppColors.primary.withOpacity(0.1);
      case TicketType.MAINTENANCE:
        return AppColors.textTertiary.withOpacity(0.1);
      case TicketType.SECURITY:
        return AppColors.warning.withOpacity(0.1);
      case TicketType.TECH_DEBT:
        return AppColors.secondary.withOpacity(0.1);
    }
  }

  Color get _textColor {
    switch (type) {
      case TicketType.BUG:
        return AppColors.error;
      case TicketType.ENHANCEMENT:
        return AppColors.primary;
      case TicketType.MAINTENANCE:
        return AppColors.textTertiary;
      case TicketType.SECURITY:
        return AppColors.warning;
      case TicketType.TECH_DEBT:
        return AppColors.secondary;
    }
  }
}
