import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../providers/projects_providers.dart';

class ProjectFiltersBar extends ConsumerWidget {
  const ProjectFiltersBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(projectFiltersProvider);

    return Row(
      children: [
        // Search
        SizedBox(
          width: 240,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search projects...',
              hintStyle: AppTypography.bodySmall,
              prefixIcon: const Icon(Icons.search, size: 18),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
            onChanged: (value) {
              ref.read(projectFiltersProvider.notifier).setSearch(
                    value.isEmpty ? null : value,
                  );
            },
          ),
        ),

        const SizedBox(width: AppSpacing.sm),

        // Status filter chips
        _FilterChip(
          label: 'All',
          isSelected: filters.status == null,
          onTap: () =>
              ref.read(projectFiltersProvider.notifier).setStatus(null),
        ),
        const SizedBox(width: AppSpacing.xxs),
        _FilterChip(
          label: 'Active',
          isSelected: filters.status == ProjectStatus.ACTIVE,
          color: AppColors.success,
          onTap: () => ref
              .read(projectFiltersProvider.notifier)
              .setStatus(ProjectStatus.ACTIVE),
        ),
        const SizedBox(width: AppSpacing.xxs),
        _FilterChip(
          label: 'Planning',
          isSelected: filters.status == ProjectStatus.PLANNING,
          color: AppColors.warning,
          onTap: () => ref
              .read(projectFiltersProvider.notifier)
              .setStatus(ProjectStatus.PLANNING),
        ),
        const SizedBox(width: AppSpacing.xxs),
        _FilterChip(
          label: 'Completed',
          isSelected: filters.status == ProjectStatus.COMPLETED,
          color: AppColors.primary,
          onTap: () => ref
              .read(projectFiltersProvider.notifier)
              .setStatus(ProjectStatus.COMPLETED),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color? color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppColors.textSecondary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
        decoration: BoxDecoration(
          color: isSelected ? chipColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(
            color: isSelected ? chipColor.withOpacity(0.3) : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: isSelected ? chipColor : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
