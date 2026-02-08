import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart' hide hypothesisListProvider;

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/loading_indicator.dart';
import '../../../shared/widgets/common/error_view.dart';
import '../providers/hypotheses_providers.dart';
import '../widgets/hypothesis_kanban.dart';

class HypothesesScreen extends ConsumerWidget {
  const HypothesesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedProgramId = ref.watch(selectedProgramIdProvider);
    final hypothesesAsync = ref.watch(
      hypothesisListProvider(programId: selectedProgramId),
    );
    final filterState = ref.watch(hypothesisFiltersProvider);

    return Column(
      children: [
        // Toolbar with filters and actions
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pagePaddingHorizontal,
            vertical: AppSpacing.md,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Column(
            children: [
              // First row: Filter tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterPill(
                      label: 'All',
                      isSelected: filterState.status == null,
                      onTap: () =>
                          ref.read(hypothesisFiltersProvider.notifier).setStatus(null),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    _FilterPill(
                      label: 'Draft',
                      isSelected: filterState.status == HypothesisStatus.DRAFT,
                      onTap: () => ref
                          .read(hypothesisFiltersProvider.notifier)
                          .setStatus(HypothesisStatus.DRAFT),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    _FilterPill(
                      label: 'Ready',
                      isSelected: filterState.status == HypothesisStatus.READY,
                      onTap: () => ref
                          .read(hypothesisFiltersProvider.notifier)
                          .setStatus(HypothesisStatus.READY),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    _FilterPill(
                      label: 'Building',
                      isSelected: filterState.status == HypothesisStatus.BUILDING,
                      onTap: () => ref
                          .read(hypothesisFiltersProvider.notifier)
                          .setStatus(HypothesisStatus.BUILDING),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    _FilterPill(
                      label: 'Measuring',
                      isSelected: filterState.status == HypothesisStatus.MEASURING,
                      onTap: () => ref
                          .read(hypothesisFiltersProvider.notifier)
                          .setStatus(HypothesisStatus.MEASURING),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    _FilterPill(
                      label: 'Concluded',
                      isSelected: filterState.status == HypothesisStatus.VALIDATED ||
                          filterState.status == HypothesisStatus.INVALIDATED,
                      onTap: () => ref
                          .read(hypothesisFiltersProvider.notifier)
                          .setStatus(HypothesisStatus.VALIDATED),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              // Second row: Search, list toggle, and new button
              Row(
                children: [
                  // Search bar
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: TextField(
                        onChanged: (value) => ref
                            .read(hypothesisFiltersProvider.notifier)
                            .setSearch(value.isEmpty ? null : value),
                        decoration: InputDecoration(
                          hintText: 'Search hypotheses...',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            size: 18,
                            color: AppColors.textTertiary,
                          ),
                          hintStyle: AppTypography.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                        style: AppTypography.bodySmall,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  // List toggle icon
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.view_list, size: 20),
                    tooltip: 'Switch to list view',
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  // New Hypothesis button
                  FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('New Hypothesis'),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Content - Kanban Board
        Expanded(
          child: hypothesesAsync.when(
            data: (hypotheses) => HypothesisKanban(
              hypotheses: hypotheses,
            ),
            loading: () =>
                const LoadingIndicator(message: 'Loading hypotheses...'),
            error: (e, _) => ErrorView(
              message: e.toString(),
              onRetry: () => ref.invalidate(
                hypothesisListProvider(programId: selectedProgramId),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withOpacity(0.3)
                : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
