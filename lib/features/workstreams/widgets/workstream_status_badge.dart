import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class WorkstreamStatusBadge extends StatelessWidget {
  final WorkstreamStatus status;

  const WorkstreamStatusBadge({super.key, required this.status});

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
      case WorkstreamStatus.NOT_STARTED:
        return 'Not Started';
      case WorkstreamStatus.ACTIVE:
        return 'Active';
      case WorkstreamStatus.BLOCKED:
        return 'Blocked';
      case WorkstreamStatus.COMPLETED:
        return 'Completed';
      case WorkstreamStatus.CANCELLED:
        return 'Cancelled';
    }
  }

  Color get _backgroundColor {
    switch (status) {
      case WorkstreamStatus.NOT_STARTED:
        return AppColors.textTertiary.withOpacity(0.1);
      case WorkstreamStatus.ACTIVE:
        return AppColors.success.withOpacity(0.1);
      case WorkstreamStatus.BLOCKED:
        return AppColors.error.withOpacity(0.1);
      case WorkstreamStatus.COMPLETED:
        return AppColors.primary.withOpacity(0.1);
      case WorkstreamStatus.CANCELLED:
        return AppColors.textTertiary.withOpacity(0.1);
    }
  }

  Color get _textColor {
    switch (status) {
      case WorkstreamStatus.NOT_STARTED:
        return AppColors.textTertiary;
      case WorkstreamStatus.ACTIVE:
        return AppColors.success;
      case WorkstreamStatus.BLOCKED:
        return AppColors.error;
      case WorkstreamStatus.COMPLETED:
        return AppColors.primary;
      case WorkstreamStatus.CANCELLED:
        return AppColors.textTertiary;
    }
  }
}
