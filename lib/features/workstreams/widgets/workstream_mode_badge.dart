import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class WorkstreamModeBadge extends StatelessWidget {
  final WorkstreamMode mode;

  const WorkstreamModeBadge({super.key, required this.mode});

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
    switch (mode) {
      case WorkstreamMode.DISCOVERY:
        return 'Discovery';
      case WorkstreamMode.BUILD:
        return 'Build';
      case WorkstreamMode.OPS:
        return 'Ops';
    }
  }

  IconData get _icon {
    switch (mode) {
      case WorkstreamMode.DISCOVERY:
        return Icons.explore_outlined;
      case WorkstreamMode.BUILD:
        return Icons.construction_outlined;
      case WorkstreamMode.OPS:
        return Icons.settings_outlined;
    }
  }

  Color get _backgroundColor {
    switch (mode) {
      case WorkstreamMode.DISCOVERY:
        return AppColors.secondary.withOpacity(0.1);
      case WorkstreamMode.BUILD:
        return AppColors.primary.withOpacity(0.1);
      case WorkstreamMode.OPS:
        return AppColors.warning.withOpacity(0.1);
    }
  }

  Color get _textColor {
    switch (mode) {
      case WorkstreamMode.DISCOVERY:
        return AppColors.secondary;
      case WorkstreamMode.BUILD:
        return AppColors.primary;
      case WorkstreamMode.OPS:
        return AppColors.warning;
    }
  }
}
