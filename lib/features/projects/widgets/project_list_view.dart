import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/avatar.dart';

class ProjectListView extends StatefulWidget {
  final List<Project> projects;

  const ProjectListView({super.key, required this.projects});

  @override
  State<ProjectListView> createState() => _ProjectListViewState();
}

class _ProjectListViewState extends State<ProjectListView> {
  // Local state for checkboxes
  late Map<String, bool> _selectedProjects;

  @override
  void initState() {
    super.initState();
    _selectedProjects = {
      for (var project in widget.projects) project.id: false
    };
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.pagePaddingHorizontal),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                // Table header with sortable columns
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
                      // Checkbox column
                      SizedBox(
                        width: 40,
                        child: Checkbox(
                          value: false,
                          onChanged: (_) {},
                        ),
                      ),
                      // Project column
                      Expanded(
                        flex: 3,
                        child: _SortableHeader(label: 'Project'),
                      ),
                      // Status column
                      SizedBox(
                        width: 100,
                        child: _SortableHeader(label: 'Status'),
                      ),
                      // Decisions column
                      SizedBox(
                        width: 100,
                        child: _SortableHeader(label: 'Decisions', align: TextAlign.center),
                      ),
                      // Outcomes column
                      SizedBox(
                        width: 90,
                        child: _SortableHeader(label: 'Outcomes', align: TextAlign.center),
                      ),
                      // Hypotheses column
                      SizedBox(
                        width: 100,
                        child: _SortableHeader(label: 'Hypotheses', align: TextAlign.center),
                      ),
                      // Team column
                      SizedBox(
                        width: 100,
                        child: _SortableHeader(label: 'Team'),
                      ),
                      // Last Updated column
                      SizedBox(
                        width: 120,
                        child: _SortableHeader(label: 'Last Updated'),
                      ),
                      // Menu column
                      const SizedBox(width: 50),
                    ],
                  ),
                ),
                // Table rows
                ...widget.projects.map((project) => _ProjectRow(
                  project: project,
                  isSelected: _selectedProjects[project.id] ?? false,
                  onSelectionChanged: (selected) {
                    setState(() {
                      _selectedProjects[project.id] = selected;
                    });
                  },
                )),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Pagination footer
          _PaginationFooter(totalCount: widget.projects.length),
        ],
      ),
    );
  }
}

class _ProjectRow extends StatelessWidget {
  final Project project;
  final bool isSelected;
  final Function(bool) onSelectionChanged;

  const _ProjectRow({
    required this.project,
    required this.isSelected,
    required this.onSelectionChanged,
  });

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
            // Checkbox
            SizedBox(
              width: 40,
              child: Checkbox(
                value: isSelected,
                onChanged: (value) {
                  onSelectionChanged(value ?? false);
                },
              ),
            ),
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
                          style: AppTypography.labelLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (project.description != null)
                          Text(
                            project.description!,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
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
            // Decisions count with SLA badge
            SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${project.decisionCount}',
                    style: AppTypography.bodyMedium,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  if (project.decisionCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0891B2).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                      child: Text(
                        '8h',
                        style: AppTypography.labelSmall.copyWith(
                          color: const Color(0xFF0891B2),
                          fontSize: 10,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Outcomes count
            SizedBox(
              width: 90,
              child: Text(
                '${project.outcomeCount}',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            // Hypotheses count
            SizedBox(
              width: 100,
              child: Text(
                '${project.hypothesisCount}',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            // Team avatars
            SizedBox(
              width: 100,
              child: _TeamAvatarsRow(project: project),
            ),
            // Last updated (relative time)
            SizedBox(
              width: 120,
              child: Text(
                _relativeTime(project.updatedAt),
                style: AppTypography.bodySmall,
              ),
            ),
            // Menu
            SizedBox(
              width: 50,
              child: PopupMenuButton<String>(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 16),
                        SizedBox(width: AppSpacing.xs),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'archive',
                    child: Row(
                      children: [
                        Icon(Icons.archive, size: 16),
                        SizedBox(width: AppSpacing.xs),
                        Text('Archive'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 16, color: AppColors.error),
                        SizedBox(width: AppSpacing.xs),
                        Text('Delete', style: TextStyle(color: AppColors.error)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  // Handle menu actions
                },
                icon: const Icon(Icons.more_vert, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _relativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      if (difference.inDays == 1) {
        return 'Yesterday';
      }
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    }
  }
}

class _StatusChip extends StatelessWidget {
  final ProjectStatus status;

  const _StatusChip({required this.status});

  Color get _backgroundColor {
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

  Color get _textColor {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Text(
        status.displayName,
        style: AppTypography.labelSmall.copyWith(
          color: _textColor,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _TeamAvatarsRow extends StatelessWidget {
  final Project project;

  const _TeamAvatarsRow({required this.project});

  @override
  Widget build(BuildContext context) {
    final maxAvatars = 4;
    final totalMembers = (project.memberCount > 0 ? project.memberCount : 1);

    return SizedBox(
      height: 32,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Owner avatar (first)
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
          // Additional member placeholders
          ...List.generate(
            (totalMembers - 1).clamp(0, maxAvatars - 1),
            (index) {
              final offset = (index + 1) * 12.0;
              if (index < maxAvatars - 2) {
                // Regular placeholder
                return Positioned(
                  left: offset,
                  top: 0,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.surface,
                        width: 1,
                      ),
                    ),
                  ),
                );
              } else {
                // "+N more" indicator
                return Positioned(
                  left: offset,
                  top: 0,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.surface,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '+${totalMembers - index}',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.primary,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _SortableHeader extends StatelessWidget {
  final String label;
  final TextAlign? align;

  const _SortableHeader({
    required this.label,
    this.align,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Handle sorting
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: AppTypography.labelMedium),
          const SizedBox(width: AppSpacing.xs),
          Icon(
            Icons.unfold_more,
            size: 14,
            color: AppColors.textTertiary,
          ),
        ],
      ),
    );
  }
}

class _PaginationFooter extends StatefulWidget {
  final int totalCount;

  const _PaginationFooter({required this.totalCount});

  @override
  State<_PaginationFooter> createState() => _PaginationFooterState();
}

class _PaginationFooterState extends State<_PaginationFooter> {
  int currentPage = 1;
  final int itemsPerPage = 10;

  int get totalPages => (widget.totalCount / itemsPerPage).ceil().clamp(1, double.infinity).toInt();
  int get displayedCount => ((currentPage - 1) * itemsPerPage + itemsPerPage).clamp(0, widget.totalCount);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Showing ${((currentPage - 1) * itemsPerPage) + 1} to $displayedCount of ${widget.totalCount} projects',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: currentPage > 1
                  ? () => setState(() => currentPage--)
                  : null,
              iconSize: 18,
            ),
            ...List.generate(
              totalPages.clamp(0, 5),
              (index) {
                final pageNum = index + 1;
                final isActive = pageNum == currentPage;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.primary : Colors.transparent,
                      border: isActive
                          ? null
                          : Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => setState(() => currentPage = pageNum),
                        child: Center(
                          child: Text(
                            '$pageNum',
                            style: AppTypography.labelSmall.copyWith(
                              color: isActive ? Colors.white : AppColors.textSecondary,
                              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: currentPage < totalPages
                  ? () => setState(() => currentPage++)
                  : null,
              iconSize: 18,
            ),
          ],
        ),
      ],
    );
  }
}
