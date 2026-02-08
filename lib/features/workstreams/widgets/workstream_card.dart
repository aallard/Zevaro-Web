import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import 'workstream_status_badge.dart';
import 'workstream_mode_badge.dart';

class WorkstreamCard extends StatelessWidget {
  final Workstream workstream;

  const WorkstreamCard({super.key, required this.workstream});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go(Routes.workstreamById(workstream.id)),
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
                        workstream.name,
                        style: AppTypography.h4.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    WorkstreamStatusBadge(status: workstream.status),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),

                // Description
                if (workstream.description != null)
                  Text(
                    workstream.description!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                const Spacer(),

                // Mode + child count
                Row(
                  children: [
                    WorkstreamModeBadge(mode: workstream.mode),
                    const SizedBox(width: AppSpacing.sm),
                    Icon(Icons.description_outlined,
                        size: 16, color: AppColors.textTertiary),
                    const SizedBox(width: AppSpacing.xxs),
                    Text(
                      '${workstream.childEntityCount ?? 0} Specs',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                    if (workstream.ownerName != null) ...[
                      const SizedBox(width: AppSpacing.md),
                      Icon(Icons.person_outline,
                          size: 16, color: AppColors.textTertiary),
                      const SizedBox(width: AppSpacing.xxs),
                      Expanded(
                        child: Text(
                          workstream.ownerName!,
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
