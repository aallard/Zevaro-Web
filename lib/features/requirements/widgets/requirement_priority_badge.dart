import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class RequirementPriorityBadge extends StatelessWidget {
  final RequirementPriority priority;

  const RequirementPriorityBadge({super.key, required this.priority});

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
    switch (priority) {
      case RequirementPriority.MUST_HAVE:
        return 'Must Have';
      case RequirementPriority.SHOULD_HAVE:
        return 'Should Have';
      case RequirementPriority.COULD_HAVE:
        return 'Could Have';
      case RequirementPriority.WONT_HAVE:
        return "Won't Have";
    }
  }

  Color get _backgroundColor {
    switch (priority) {
      case RequirementPriority.MUST_HAVE:
        return AppColors.error.withOpacity(0.1);
      case RequirementPriority.SHOULD_HAVE:
        return AppColors.warning.withOpacity(0.1);
      case RequirementPriority.COULD_HAVE:
        return AppColors.primary.withOpacity(0.1);
      case RequirementPriority.WONT_HAVE:
        return AppColors.textTertiary.withOpacity(0.1);
    }
  }

  Color get _textColor {
    switch (priority) {
      case RequirementPriority.MUST_HAVE:
        return AppColors.error;
      case RequirementPriority.SHOULD_HAVE:
        return AppColors.warning;
      case RequirementPriority.COULD_HAVE:
        return AppColors.primary;
      case RequirementPriority.WONT_HAVE:
        return AppColors.textTertiary;
    }
  }
}
