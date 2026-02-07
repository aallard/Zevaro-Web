import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/avatar.dart';

class ProjectCard extends StatelessWidget {
  final Project project;

  const ProjectCard({super.key, required this.project});

  Color get _accentColor {
    if (project.color != null) {
      try {
        final hex = project.color!.replaceFirst('#', '');
        return Color(int.parse('FF$hex', radix: 16));
      } catch (_) {}
    }
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go(Routes.projectById(project.id)),
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
          child: Row(
            children: [
              // Color accent bar
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: _accentColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppSpacing.radiusLg),
                    bottomLeft: Radius.circular(AppSpacing.radiusLg),
                  ),
                ),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and status
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              project.name,
                              style: AppTypography.h4,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _StatusBadge(status: project.status),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),

                      // Description
                      if (project.description != null)
                        Text(
                          project.description!,
                          style: AppTypography.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                      const Spacer(),

                      // Stats row
                      Row(
                        children: [
                          _MiniStat(
                            count: project.decisionCount,
                            label: 'Decisions',
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          const Text('·',
                              style: TextStyle(color: AppColors.textTertiary)),
                          const SizedBox(width: AppSpacing.sm),
                          _MiniStat(
                            count: project.outcomeCount,
                            label: 'Outcomes',
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          const Text('·',
                              style: TextStyle(color: AppColors.textTertiary)),
                          const SizedBox(width: AppSpacing.sm),
                          _MiniStat(
                            count: project.hypothesisCount,
                            label: 'Hypotheses',
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.sm),

                      // Owner avatar row
                      if (project.ownerName != null)
                        Row(
                          children: [
                            ZAvatar(
                              name: project.ownerName!,
                              imageUrl: project.ownerAvatarUrl,
                              size: 24,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              project.ownerName!,
                              style: AppTypography.labelSmall,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final ProjectStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status.displayName,
        style: AppTypography.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color get _statusColor {
    switch (status) {
      case ProjectStatus.ACTIVE:
        return AppColors.success;
      case ProjectStatus.PLANNING:
        return AppColors.warning;
      case ProjectStatus.COMPLETED:
        return AppColors.primary;
      case ProjectStatus.ARCHIVED:
        return AppColors.textTertiary;
    }
  }
}

class _MiniStat extends StatelessWidget {
  final int count;
  final String label;

  const _MiniStat({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$count $label',
      style: AppTypography.labelSmall,
    );
  }
}
