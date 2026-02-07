import 'package:flutter/material.dart';
import 'package:zevaro_web/core/theme/app_colors.dart';
import 'package:zevaro_web/core/theme/app_spacing.dart';
import 'package:zevaro_web/core/theme/app_typography.dart';

/// A filter item representing a selectable filter option
class FilterItem {
  const FilterItem({
    required this.label,
    required this.value,
    this.count,
  });

  final String label;
  final String value;
  final int? count;
}

/// Reusable filter bar with pill-style chips and optional search
class FilterBar extends StatelessWidget {
  const FilterBar({
    super.key,
    required this.filters,
    required this.selectedValue,
    required this.onFilterChanged,
    this.searchQuery,
    this.onSearchChanged,
    this.searchHint = 'Search...',
    this.trailing,
  });

  final List<FilterItem> filters;
  final String selectedValue;
  final ValueChanged<String> onFilterChanged;
  final String? searchQuery;
  final ValueChanged<String>? onSearchChanged;
  final String searchHint;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (onSearchChanged != null)
          SizedBox(
            width: 240,
            height: 36,
            child: TextField(
              onChanged: onSearchChanged,
              style: AppTypography.bodySmall,
              decoration: InputDecoration(
                hintText: searchHint,
                hintStyle: AppTypography.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
                prefixIcon: const Icon(Icons.search, size: 18),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide: BorderSide(color: AppColors.primary, width: 1.5),
                ),
                filled: true,
                fillColor: AppColors.surface,
              ),
            ),
          ),
        ...filters.map((filter) => _FilterPill(
              label: filter.label,
              count: filter.count,
              isSelected: filter.value == selectedValue,
              onTap: () => onFilterChanged(filter.value),
            )),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    this.count,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final int? count;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.2)
                      : AppColors.textTertiary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
                child: Text(
                  '$count',
                  style: AppTypography.labelSmall.copyWith(
                    color: isSelected ? Colors.white : AppColors.textTertiary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
