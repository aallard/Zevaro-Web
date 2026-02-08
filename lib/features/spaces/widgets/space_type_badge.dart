import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class SpaceTypeBadge extends StatelessWidget {
  final SpaceType type;

  const SpaceTypeBadge({super.key, required this.type});

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
    switch (type) {
      case SpaceType.PROGRAM:
        return 'Program';
      case SpaceType.TEAM:
        return 'Team';
      case SpaceType.PERSONAL:
        return 'Personal';
      case SpaceType.GLOBAL:
        return 'Global';
    }
  }

  Color get _backgroundColor {
    switch (type) {
      case SpaceType.PROGRAM:
        return AppColors.primary.withOpacity(0.1);
      case SpaceType.TEAM:
        return AppColors.success.withOpacity(0.1);
      case SpaceType.PERSONAL:
        return AppColors.secondary.withOpacity(0.1);
      case SpaceType.GLOBAL:
        return AppColors.warning.withOpacity(0.1);
    }
  }

  Color get _textColor {
    switch (type) {
      case SpaceType.PROGRAM:
        return AppColors.primary;
      case SpaceType.TEAM:
        return AppColors.success;
      case SpaceType.PERSONAL:
        return AppColors.secondary;
      case SpaceType.GLOBAL:
        return AppColors.warning;
    }
  }
}
