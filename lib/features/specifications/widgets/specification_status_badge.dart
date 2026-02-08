import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class SpecificationStatusBadge extends StatelessWidget {
  final SpecificationStatus status;

  const SpecificationStatusBadge({super.key, required this.status});

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
      case SpecificationStatus.DRAFT:
        return 'Draft';
      case SpecificationStatus.IN_REVIEW:
        return 'In Review';
      case SpecificationStatus.APPROVED:
        return 'Approved';
      case SpecificationStatus.IN_PROGRESS:
        return 'In Progress';
      case SpecificationStatus.DELIVERED:
        return 'Delivered';
      case SpecificationStatus.ACCEPTED:
        return 'Accepted';
    }
  }

  Color get _backgroundColor {
    switch (status) {
      case SpecificationStatus.DRAFT:
        return AppColors.textTertiary.withOpacity(0.1);
      case SpecificationStatus.IN_REVIEW:
        return AppColors.warning.withOpacity(0.1);
      case SpecificationStatus.APPROVED:
        return AppColors.primary.withOpacity(0.1);
      case SpecificationStatus.IN_PROGRESS:
        return AppColors.secondary.withOpacity(0.1);
      case SpecificationStatus.DELIVERED:
        return AppColors.success.withOpacity(0.1);
      case SpecificationStatus.ACCEPTED:
        return AppColors.success.withOpacity(0.15);
    }
  }

  Color get _textColor {
    switch (status) {
      case SpecificationStatus.DRAFT:
        return AppColors.textTertiary;
      case SpecificationStatus.IN_REVIEW:
        return AppColors.warning;
      case SpecificationStatus.APPROVED:
        return AppColors.primary;
      case SpecificationStatus.IN_PROGRESS:
        return AppColors.secondary;
      case SpecificationStatus.DELIVERED:
        return AppColors.success;
      case SpecificationStatus.ACCEPTED:
        return AppColors.success;
    }
  }
}
