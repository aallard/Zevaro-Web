import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class PortfolioStatusBadge extends StatelessWidget {
  final PortfolioStatus status;

  const PortfolioStatusBadge({super.key, required this.status});

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
      case PortfolioStatus.ACTIVE:
        return 'Active';
      case PortfolioStatus.ON_HOLD:
        return 'On Hold';
      case PortfolioStatus.COMPLETED:
        return 'Completed';
      case PortfolioStatus.ARCHIVED:
        return 'Archived';
    }
  }

  Color get _backgroundColor {
    switch (status) {
      case PortfolioStatus.ACTIVE:
        return AppColors.success.withOpacity(0.1);
      case PortfolioStatus.ON_HOLD:
        return AppColors.warning.withOpacity(0.1);
      case PortfolioStatus.COMPLETED:
        return AppColors.primary.withOpacity(0.1);
      case PortfolioStatus.ARCHIVED:
        return AppColors.textTertiary.withOpacity(0.1);
    }
  }

  Color get _textColor {
    switch (status) {
      case PortfolioStatus.ACTIVE:
        return AppColors.success;
      case PortfolioStatus.ON_HOLD:
        return AppColors.warning;
      case PortfolioStatus.COMPLETED:
        return AppColors.primary;
      case PortfolioStatus.ARCHIVED:
        return AppColors.textTertiary;
    }
  }
}
