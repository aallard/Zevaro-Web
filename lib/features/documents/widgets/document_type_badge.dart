import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class DocumentTypeBadge extends StatelessWidget {
  final DocumentType type;

  const DocumentTypeBadge({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 12, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            _label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String get _label {
    switch (type) {
      case DocumentType.PAGE:
        return 'Page';
      case DocumentType.SPECIFICATION:
        return 'Spec';
      case DocumentType.TEMPLATE:
        return 'Template';
      case DocumentType.MEETING_NOTES:
        return 'Meeting Notes';
      case DocumentType.DECISION_RECORD:
        return 'Decision Record';
      case DocumentType.RFC:
        return 'RFC';
      case DocumentType.RUNBOOK:
        return 'Runbook';
    }
  }

  IconData get _icon {
    switch (type) {
      case DocumentType.PAGE:
        return Icons.article_outlined;
      case DocumentType.SPECIFICATION:
        return Icons.description_outlined;
      case DocumentType.TEMPLATE:
        return Icons.copy_outlined;
      case DocumentType.MEETING_NOTES:
        return Icons.groups_outlined;
      case DocumentType.DECISION_RECORD:
        return Icons.gavel_outlined;
      case DocumentType.RFC:
        return Icons.request_page_outlined;
      case DocumentType.RUNBOOK:
        return Icons.menu_book_outlined;
    }
  }
}
