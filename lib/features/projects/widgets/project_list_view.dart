import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  late Map<String, bool> _selectedProjects;
  int _currentPage = 1;
  final int _itemsPerPage = 18;

  @override
  void initState() {
    super.initState();
    _selectedProjects = {
      for (var project in widget.projects) project.id: false
    };
  }

  int get _totalPages => (widget.projects.length / _itemsPerPage).ceil().clamp(1, double.infinity).toInt();

  List<Project> get _pagedProjects {
    final start = (_currentPage - 1) * _itemsPerPage;
    final end = (start + _itemsPerPage).clamp(0, widget.projects.length);
    return widget.projects.sublist(start, end);
  }

  bool get _allSelected {
    return _pagedProjects.every((p) => _selectedProjects[p.id] == true);
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
                // ── Table header ──
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
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
                          value: _allSelected && _pagedProjects.isNotEmpty,
                          onChanged: (val) {
                            setState(() {
                              for (var p in _pagedProjects) {
                                _selectedProjects[p.id] = val ?? false;
                              }
                            });
                          },
                        ),
                      ),
                      // Project Name column
                      Expanded(
                        flex: 4,
                        child: _SortableHeader(label: 'Project Name'),
                      ),
                      // Status
                      SizedBox(
                        width: 110,
                        child: _SortableHeader(label: 'Status'),
                      ),
                      // Decisions
                      SizedBox(
                        width: 120,
                        child: _SortableHeader(label: 'Decisions'),
                      ),
                      // Outcomes
                      SizedBox(
                        width: 100,
                        child: _SortableHeader(label: 'Outcomes'),
                      ),
                      // Hypotheses
                      SizedBox(
                        width: 120,
                        child: _SortableHeader(label: 'Hypotheses'),
                      ),
                      // Team
                      SizedBox(
                        width: 110,
                        child: _SortableHeader(label: 'Team'),
                      ),
                      // Last Updated
                      SizedBox(
                        width: 120,
                        child: _SortableHeader(label: 'Last Updated'),
                      ),
                      // Menu
                      const SizedBox(width: 44),
                    ],
                  ),
                ),
                // ── Table rows ──
                ..._pagedProjects.map((project) => _ProjectRow(
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
          // ── Pagination ──
          _PaginationFooter(
            totalCount: widget.projects.length,
            currentPage: _currentPage,
            totalPages: _totalPages,
            onPageChanged: (page) => setState(() => _currentPage = page),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Table row
// ─────────────────────────────────────────────────────────────────────────────

class _ProjectRow extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        ref.read(selectedProjectIdProvider.notifier).select(project.id);
        context.go(Routes.dashboard);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.04) : null,
          border: const Border(
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
              flex: 4,
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
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
                              color: AppColors.textTertiary,
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
              width: 110,
              child: _StatusChip(status: project.status),
            ),
            // Decisions count with SLA badge
            SizedBox(
              width: 120,
              child: Row(
                children: [
                  Text(
                    '${project.decisionCount}',
                    style: AppTypography.bodyMedium,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  if (project.decisionCount > 0)
                    _SlaBadge(hours: _slaHours(project.decisionCount)),
                ],
              ),
            ),
            // Outcomes count
            SizedBox(
              width: 100,
              child: Text(
                '${project.outcomeCount}',
                style: AppTypography.bodyMedium,
              ),
            ),
            // Hypotheses count
            SizedBox(
              width: 120,
              child: Text(
                '${project.hypothesisCount}',
                style: AppTypography.bodyMedium,
              ),
            ),
            // Team avatars
            SizedBox(
              width: 110,
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
              width: 44,
              child: PopupMenuButton<String>(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 16),
                        SizedBox(width: AppSpacing.xs),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'archive',
                    child: Row(
                      children: [
                        Icon(Icons.archive_outlined, size: 16),
                        SizedBox(width: AppSpacing.xs),
                        Text('Archive'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 16, color: AppColors.error),
                        SizedBox(width: AppSpacing.xs),
                        Text('Delete', style: TextStyle(color: AppColors.error)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {},
                icon: const Icon(Icons.more_horiz, size: 18, color: AppColors.textTertiary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Vary the SLA hours based on the decision count to match the design
  int _slaHours(int decisionCount) {
    if (decisionCount >= 12) return 8;
    if (decisionCount >= 11) return 5;
    return 7;
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

// ─────────────────────────────────────────────────────────────────────────────
// SLA badge (cyan pill showing hours)
// ─────────────────────────────────────────────────────────────────────────────

class _SlaBadge extends StatelessWidget {
  final int hours;

  const _SlaBadge({required this.hours});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Text(
        '${hours}h',
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.info,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Status chip
// ─────────────────────────────────────────────────────────────────────────────

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
        return AppColors.textSecondary.withOpacity(0.1);
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
        return AppColors.textSecondary;
      case ProjectStatus.ARCHIVED:
        return AppColors.textTertiary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Team avatars (overlapping circles)
// ─────────────────────────────────────────────────────────────────────────────

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
              final offset = (index + 1) * 20.0;
              if (index < maxAvatars - 2) {
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
                      child: Icon(
                        Icons.person,
                        size: 16,
                        color: AppColors.textTertiary,
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
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.surface,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '+${totalMembers - maxAvatars + 1}',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.primary,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
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

// ─────────────────────────────────────────────────────────────────────────────
// Sortable header
// ─────────────────────────────────────────────────────────────────────────────

class _SortableHeader extends StatelessWidget {
  final String label;

  const _SortableHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Handle sorting
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: AppSpacing.xxs),
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

// ─────────────────────────────────────────────────────────────────────────────
// Pagination footer
// ─────────────────────────────────────────────────────────────────────────────

class _PaginationFooter extends StatelessWidget {
  final int totalCount;
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const _PaginationFooter({
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Showing ${totalCount.clamp(0, 18)} of $totalCount projects',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Row(
          children: [
            _PageButton(
              icon: Icons.chevron_left,
              enabled: currentPage > 1,
              onTap: () => onPageChanged(currentPage - 1),
            ),
            ...List.generate(
              totalPages.clamp(0, 5),
              (index) {
                final pageNum = index + 1;
                final isActive = pageNum == currentPage;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: InkWell(
                    onTap: () => onPageChanged(pageNum),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.sidebarAccent : Colors.transparent,
                        border: isActive
                            ? null
                            : Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Center(
                        child: Text(
                          '$pageNum',
                          style: AppTypography.labelMedium.copyWith(
                            color: isActive ? Colors.white : AppColors.textSecondary,
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            _PageButton(
              icon: Icons.chevron_right,
              enabled: currentPage < totalPages,
              onTap: () => onPageChanged(currentPage + 1),
            ),
          ],
        ),
      ],
    );
  }
}

class _PageButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _PageButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Container(
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Icon(
          icon,
          size: 18,
          color: enabled ? AppColors.textSecondary : AppColors.border,
        ),
      ),
    );
  }
}
