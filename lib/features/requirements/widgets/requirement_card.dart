import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import 'requirement_status_badge.dart';
import 'requirement_priority_badge.dart';

class RequirementCard extends StatelessWidget {
  final Requirement requirement;

  const RequirementCard({super.key, required this.requirement});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () =>
            context.go(Routes.requirementById(requirement.id)),
        child: Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.xs),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              // Identifier
              SizedBox(
                width: 80,
                child: Text(
                  requirement.identifier,
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Title
              Expanded(
                flex: 3,
                child: Text(
                  requirement.title,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(width: AppSpacing.sm),

              // Type
              SizedBox(
                width: 100,
                child: Text(
                  _typeLabel(requirement.type),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

              // Priority
              RequirementPriorityBadge(priority: requirement.priority),

              const SizedBox(width: AppSpacing.sm),

              // Status
              RequirementStatusBadge(status: requirement.status),

              // Dependencies indicator
              if ((requirement.dependencies?.isNotEmpty ?? false) ||
                  (requirement.dependedOnBy?.isNotEmpty ?? false)) ...[
                const SizedBox(width: AppSpacing.sm),
                Icon(Icons.link, size: 16, color: AppColors.textTertiary),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _typeLabel(RequirementType type) {
    switch (type) {
      case RequirementType.FUNCTIONAL:
        return 'Functional';
      case RequirementType.NON_FUNCTIONAL:
        return 'Non-Func';
      case RequirementType.CONSTRAINT:
        return 'Constraint';
      case RequirementType.INTERFACE:
        return 'Interface';
    }
  }
}
