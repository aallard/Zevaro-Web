import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../providers/programs_providers.dart';

class ProgramFiltersBar extends ConsumerWidget {
  const ProgramFiltersBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(programFiltersProvider);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Status filter chips
        _FilterChip(
          label: 'All',
          isSelected: filters.status == null,
          onTap: () =>
              ref.read(programFiltersProvider.notifier).setStatus(null),
        ),
        const SizedBox(width: AppSpacing.xxs),
        _FilterChip(
          label: 'Active',
          isSelected: filters.status == ProgramStatus.ACTIVE,
          color: AppColors.success,
          onTap: () => ref
              .read(programFiltersProvider.notifier)
              .setStatus(ProgramStatus.ACTIVE),
        ),
        const SizedBox(width: AppSpacing.xxs),
        _FilterChip(
          label: 'Planning',
          isSelected: filters.status == ProgramStatus.PLANNING,
          color: AppColors.warning,
          onTap: () => ref
              .read(programFiltersProvider.notifier)
              .setStatus(ProgramStatus.PLANNING),
        ),
        const SizedBox(width: AppSpacing.xxs),
        _FilterChip(
          label: 'Completed',
          isSelected: filters.status == ProgramStatus.COMPLETED,
          color: AppColors.primary,
          onTap: () => ref
              .read(programFiltersProvider.notifier)
              .setStatus(ProgramStatus.COMPLETED),
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
    // "All" uses primary color (indigo)
    final chipColor = label == 'All' ? AppColors.sidebarAccent : (color ?? AppColors.textSecondary);

    if (label == 'All') {
      // "All" - filled indigo when active, outlined when inactive
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.sidebarAccent : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            border: Border.all(
              color: isSelected ? AppColors.sidebarAccent : AppColors.border,
            ),
          ),
          child: Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      );
    } else {
      // Status chips - outlined when inactive, filled with status color when active
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: isSelected ? chipColor.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            border: Border.all(
              color: isSelected ? chipColor : AppColors.border,
            ),
          ),
          child: Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: isSelected ? chipColor : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      );
    }
  }
}
