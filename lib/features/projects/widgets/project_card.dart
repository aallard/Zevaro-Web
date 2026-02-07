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
          child: Column(
            children: [
              // Content area with accent bar on left
              Expanded(
                child: Row(
                  children: [
                    // Left accent bar (4px)
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
                    // Main content
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.cardPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title row with completion checkmark
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    project.name,
                                    style: AppTypography.h4.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                // Completion checkmark for COMPLETED projects
                                if (project.status == ProjectStatus.COMPLETED)
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      color: AppColors.success,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.xs),

                            // Description (1-2 lines with ellipsis)
                            if (project.description != null)
                              Text(
                                project.description!,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),

                            const SizedBox(height: AppSpacing.sm),

                            // Member avatars
                            _MemberAvatarsRow(project: project),

                            const SizedBox(height: AppSpacing.md),

                            // Stats row
                            Text(
                              '${project.decisionCount} Decisions · ${project.outcomeCount} Outcomes · ${project.hypothesisCount} Hypotheses',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.textTertiary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const Spacer(),

                            // Status badge at bottom-left
                            _StatusBadge(status: project.status),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Progress bar at very bottom
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(AppSpacing.radiusLg),
                    bottomRight: Radius.circular(AppSpacing.radiusLg),
                  ),
                ),
                child: Stack(
                  children: [
                    // Background (full width, border color)
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(AppSpacing.radiusLg),
                          bottomRight: Radius.circular(AppSpacing.radiusLg),
                        ),
                      ),
                    ),
                    // Progress indicator
                    FractionallySizedBox(
                      widthFactor: _getProgressFraction(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _getProgressColor(),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(AppSpacing.radiusLg),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _getProgressFraction() {
    switch (project.status) {
      case ProjectStatus.COMPLETED:
        return 1.0;
      case ProjectStatus.ACTIVE:
        return 0.5;
      case ProjectStatus.PLANNING:
        return 0.2;
      case ProjectStatus.ARCHIVED:
        return 0.0;
    }
  }

  Color _getProgressColor() {
    switch (project.status) {
      case ProjectStatus.COMPLETED:
        return AppColors.success;
      case ProjectStatus.ACTIVE:
        return _accentColor;
      case ProjectStatus.PLANNING:
        return _accentColor;
      case ProjectStatus.ARCHIVED:
        return AppColors.textTertiary;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final ProjectStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _getBackgroundColor();
    final textColor = _getTextColor();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            status.displayName,
            style: AppTypography.labelSmall.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (status == ProjectStatus.COMPLETED) ...[
            const SizedBox(width: AppSpacing.xs),
            Icon(
              Icons.check,
              size: 12,
              color: textColor,
            ),
          ],
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (status) {
      case ProjectStatus.ACTIVE:
        return AppColors.success.withOpacity(0.1);
      case ProjectStatus.PLANNING:
        return AppColors.warning.withOpacity(0.1);
      case ProjectStatus.COMPLETED:
        return AppColors.success.withOpacity(0.1);
      case ProjectStatus.ARCHIVED:
        return AppColors.textTertiary.withOpacity(0.1);
    }
  }

  Color _getTextColor() {
    switch (status) {
      case ProjectStatus.ACTIVE:
        return AppColors.success;
      case ProjectStatus.PLANNING:
        return AppColors.warning;
      case ProjectStatus.COMPLETED:
        return AppColors.success;
      case ProjectStatus.ARCHIVED:
        return AppColors.textTertiary;
    }
  }
}

class _MemberAvatarsRow extends StatelessWidget {
  final Project project;

  const _MemberAvatarsRow({required this.project});

  @override
  Widget build(BuildContext context) {
    // Calculate number of avatars to show
    final totalMembers = (project.memberCount > 0 ? project.memberCount : 1);

    return SizedBox(
      height: 32,
      child: Stack(
        children: [
          // Owner avatar (first position)
          if (project.ownerName != null)
            Positioned(
              left: 0,
              top: 0,
              child: ZAvatar(
                name: project.ownerName!,
                imageUrl: project.ownerAvatarUrl,
                size: 32,
              ),
            ),
          // Placeholder circles for remaining members
          ...List.generate(
            (totalMembers - 1).clamp(0, 3), // Max 3 more placeholders
            (index) {
              final offset = (index + 1) * 16.0; // 16px overlap each
              return Positioned(
                left: offset,
                top: 0,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.surface,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '+${totalMembers - 1 - index}',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
