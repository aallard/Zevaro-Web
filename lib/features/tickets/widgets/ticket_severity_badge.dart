import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class TicketSeverityBadge extends StatelessWidget {
  final TicketSeverity severity;

  const TicketSeverityBadge({super.key, required this.severity});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Text(
        _label,
        style: AppTypography.labelSmall.copyWith(
          color: _textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String get _label {
    switch (severity) {
      case TicketSeverity.CRITICAL:
        return 'Critical';
      case TicketSeverity.HIGH:
        return 'High';
      case TicketSeverity.MEDIUM:
        return 'Medium';
      case TicketSeverity.LOW:
        return 'Low';
    }
  }

  Color get _backgroundColor {
    switch (severity) {
      case TicketSeverity.CRITICAL:
        return AppColors.error.withOpacity(0.15);
      case TicketSeverity.HIGH:
        return AppColors.warning.withOpacity(0.1);
      case TicketSeverity.MEDIUM:
        return AppColors.warning.withOpacity(0.08);
      case TicketSeverity.LOW:
        return AppColors.textTertiary.withOpacity(0.1);
    }
  }

  Color get _textColor {
    switch (severity) {
      case TicketSeverity.CRITICAL:
        return AppColors.error;
      case TicketSeverity.HIGH:
        return AppColors.warning;
      case TicketSeverity.MEDIUM:
        return AppColors.warning;
      case TicketSeverity.LOW:
        return AppColors.textTertiary;
    }
  }
}
