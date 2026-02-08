import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class DocumentStatusBadge extends StatelessWidget {
  final DocumentStatus status;

  const DocumentStatusBadge({super.key, required this.status});

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
      case DocumentStatus.DRAFT:
        return 'Draft';
      case DocumentStatus.PUBLISHED:
        return 'Published';
      case DocumentStatus.ARCHIVED:
        return 'Archived';
    }
  }

  Color get _backgroundColor {
    switch (status) {
      case DocumentStatus.DRAFT:
        return AppColors.textTertiary.withOpacity(0.1);
      case DocumentStatus.PUBLISHED:
        return AppColors.success.withOpacity(0.1);
      case DocumentStatus.ARCHIVED:
        return AppColors.textTertiary.withOpacity(0.1);
    }
  }

  Color get _textColor {
    switch (status) {
      case DocumentStatus.DRAFT:
        return AppColors.textTertiary;
      case DocumentStatus.PUBLISHED:
        return AppColors.success;
      case DocumentStatus.ARCHIVED:
        return AppColors.textTertiary;
    }
  }
}
