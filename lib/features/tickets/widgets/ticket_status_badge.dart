import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class TicketStatusBadge extends StatelessWidget {
  final TicketStatus status;

  const TicketStatusBadge({super.key, required this.status});

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
    switch (status) {
      case TicketStatus.NEW:
        return 'New';
      case TicketStatus.TRIAGED:
        return 'Triaged';
      case TicketStatus.IN_PROGRESS:
        return 'In Progress';
      case TicketStatus.IN_REVIEW:
        return 'In Review';
      case TicketStatus.RESOLVED:
        return 'Resolved';
      case TicketStatus.CLOSED:
        return 'Closed';
      case TicketStatus.WONT_FIX:
        return "Won't Fix";
    }
  }

  Color get _backgroundColor {
    switch (status) {
      case TicketStatus.NEW:
        return AppColors.primary.withOpacity(0.1);
      case TicketStatus.TRIAGED:
        return AppColors.secondary.withOpacity(0.1);
      case TicketStatus.IN_PROGRESS:
        return AppColors.warning.withOpacity(0.1);
      case TicketStatus.IN_REVIEW:
        return AppColors.secondary.withOpacity(0.1);
      case TicketStatus.RESOLVED:
        return AppColors.success.withOpacity(0.1);
      case TicketStatus.CLOSED:
        return AppColors.textTertiary.withOpacity(0.1);
      case TicketStatus.WONT_FIX:
        return AppColors.textTertiary.withOpacity(0.1);
    }
  }

  Color get _textColor {
    switch (status) {
      case TicketStatus.NEW:
        return AppColors.primary;
      case TicketStatus.TRIAGED:
        return AppColors.secondary;
      case TicketStatus.IN_PROGRESS:
        return AppColors.warning;
      case TicketStatus.IN_REVIEW:
        return AppColors.secondary;
      case TicketStatus.RESOLVED:
        return AppColors.success;
      case TicketStatus.CLOSED:
        return AppColors.textTertiary;
      case TicketStatus.WONT_FIX:
        return AppColors.textTertiary;
    }
  }
}
