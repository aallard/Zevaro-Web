import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import 'space_type_badge.dart';

class SpaceCard extends StatelessWidget {
  final Space space;

  const SpaceCard({super.key, required this.space});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go(Routes.spaceById(space.id)),
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
                // Icon + name + type
                Row(
                  children: [
                    if (space.icon != null) ...[
                      Text(space.icon!, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                    Expanded(
                      child: Text(
                        space.name,
                        style: AppTypography.h4.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SpaceTypeBadge(type: space.type),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),

                // Description
                if (space.description != null)
                  Text(
                    space.description!,
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
                    Icon(Icons.article_outlined,
                        size: 16, color: AppColors.textTertiary),
                    const SizedBox(width: AppSpacing.xxs),
                    Text(
                      '${space.documentCount ?? 0} Documents',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                    if (space.ownerName != null) ...[
                      const SizedBox(width: AppSpacing.md),
                      Icon(Icons.person_outline,
                          size: 16, color: AppColors.textTertiary),
                      const SizedBox(width: AppSpacing.xxs),
                      Expanded(
                        child: Text(
                          space.ownerName!,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    // Visibility indicator
                    const SizedBox(width: AppSpacing.sm),
                    Icon(
                      space.visibility == SpaceVisibility.PRIVATE
                          ? Icons.lock_outlined
                          : space.visibility == SpaceVisibility.RESTRICTED
                              ? Icons.shield_outlined
                              : Icons.public_outlined,
                      size: 14,
                      color: AppColors.textTertiary,
                    ),
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
