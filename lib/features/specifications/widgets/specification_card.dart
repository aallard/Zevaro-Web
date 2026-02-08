import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import 'specification_status_badge.dart';

class SpecificationCard extends StatelessWidget {
  final Specification specification;

  const SpecificationCard({super.key, required this.specification});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () =>
            context.go(Routes.specificationById(specification.id)),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + status
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        specification.name,
                        style: AppTypography.h4.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SpecificationStatusBadge(
                        status: specification.status),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),

                // Description
                if (specification.description != null)
                  Text(
                    specification.description!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                const Spacer(),

                // Stats row
                Row(
                  children: [
                    Icon(Icons.checklist_outlined,
                        size: 16, color: AppColors.textTertiary),
                    const SizedBox(width: AppSpacing.xxs),
                    Text(
                      '${specification.requirementCount ?? 0} Requirements',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                    if (specification.estimatedHours != null) ...[
                      const SizedBox(width: AppSpacing.md),
                      Icon(Icons.schedule_outlined,
                          size: 16, color: AppColors.textTertiary),
                      const SizedBox(width: AppSpacing.xxs),
                      Text(
                        '${specification.estimatedHours!.toStringAsFixed(0)}h est',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                    if (specification.authorName != null) ...[
                      const SizedBox(width: AppSpacing.md),
                      Icon(Icons.person_outline,
                          size: 16, color: AppColors.textTertiary),
                      const SizedBox(width: AppSpacing.xxs),
                      Expanded(
                        child: Text(
                          specification.authorName!,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
