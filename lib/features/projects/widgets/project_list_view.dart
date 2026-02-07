import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import 'package:intl/intl.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class ProjectListView extends StatelessWidget {
  final List<Project> projects;

  const ProjectListView({super.key, required this.projects});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.pagePaddingHorizontal),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            // Table header
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.cardPadding,
                vertical: AppSpacing.sm,
              ),
              decoration: const BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppSpacing.radiusLg),
                  topRight: Radius.circular(AppSpacing.radiusLg),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text('Project', style: AppTypography.labelMedium),
                  ),
                  SizedBox(
                    width: 100,
                    child: Text('Status', style: AppTypography.labelMedium),
                  ),
                  SizedBox(
                    width: 80,
                    child: Text('Decisions',
                        style: AppTypography.labelMedium,
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(
                    width: 80,
                    child: Text('Outcomes',
                        style: AppTypography.labelMedium,
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(
                    width: 90,
                    child: Text('Hypotheses',
                        style: AppTypography.labelMedium,
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(
                    width: 100,
                    child: Text('Experiments',
                        style: AppTypography.labelMedium,
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(
                    width: 120,
                    child: Text('Updated', style: AppTypography.labelMedium),
                  ),
                ],
              ),
            ),
            // Table rows
            ...projects.map((project) => _ProjectRow(project: project)),
          ],
        ),
      ),
    );
  }
}

class _ProjectRow extends StatelessWidget {
  final Project project;

  const _ProjectRow({required this.project});

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
    return InkWell(
      onTap: () => context.go(Routes.projectById(project.id)),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardPadding,
          vertical: AppSpacing.sm,
        ),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.borderLight),
          ),
        ),
        child: Row(
          children: [
            // Project name with color dot
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.name,
                          style: AppTypography.labelLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (project.description != null)
                          Text(
                            project.description!,
                            style: AppTypography.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Status badge
            SizedBox(
              width: 100,
              child: _StatusChip(status: project.status),
            ),
            // Stat counts
            SizedBox(
              width: 80,
              child: Text(
                '${project.decisionCount}',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 80,
              child: Text(
                '${project.outcomeCount}',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 90,
              child: Text(
                '${project.hypothesisCount}',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 100,
              child: Text(
                '${project.experimentCount}',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            // Updated date
            SizedBox(
              width: 120,
              child: Text(
                DateFormat.yMMMd().format(project.updatedAt),
                style: AppTypography.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final ProjectStatus status;

  const _StatusChip({required this.status});

  Color get _color {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Text(
        status.displayName,
        style: AppTypography.labelSmall.copyWith(color: _color),
        textAlign: TextAlign.center,
      ),
    );
  }
}
