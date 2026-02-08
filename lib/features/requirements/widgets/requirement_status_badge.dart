import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class RequirementStatusBadge extends StatelessWidget {
  final RequirementStatus status;

  const RequirementStatusBadge({super.key, required this.status});

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
      case RequirementStatus.DRAFT:
        return 'Draft';
      case RequirementStatus.APPROVED:
        return 'Approved';
      case RequirementStatus.IN_PROGRESS:
        return 'In Progress';
      case RequirementStatus.IMPLEMENTED:
        return 'Implemented';
      case RequirementStatus.VERIFIED:
        return 'Verified';
    }
  }

  Color get _backgroundColor {
    switch (status) {
      case RequirementStatus.DRAFT:
        return AppColors.textTertiary.withOpacity(0.1);
      case RequirementStatus.APPROVED:
        return AppColors.primary.withOpacity(0.1);
      case RequirementStatus.IN_PROGRESS:
        return AppColors.secondary.withOpacity(0.1);
      case RequirementStatus.IMPLEMENTED:
        return AppColors.success.withOpacity(0.1);
      case RequirementStatus.VERIFIED:
        return AppColors.success.withOpacity(0.15);
    }
  }

  Color get _textColor {
    switch (status) {
      case RequirementStatus.DRAFT:
        return AppColors.textTertiary;
      case RequirementStatus.APPROVED:
        return AppColors.primary;
      case RequirementStatus.IN_PROGRESS:
        return AppColors.secondary;
      case RequirementStatus.IMPLEMENTED:
        return AppColors.success;
      case RequirementStatus.VERIFIED:
        return AppColors.success;
    }
  }
}
