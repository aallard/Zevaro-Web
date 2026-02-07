import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/loading_indicator.dart';
import '../../../shared/widgets/common/error_view.dart';
import '../../../shared/widgets/common/avatar.dart';
import '../providers/outcomes_providers.dart';
import '../widgets/outcome_card_enhanced.dart';
import '../widgets/create_outcome_dialog.dart';

class OutcomesScreen extends ConsumerWidget {
  const OutcomesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outcomesAsync = ref.watch(filteredOutcomesProvider);
    final filterState = ref.watch(outcomeFiltersProvider);
    final searchController = TextEditingController();

    return Column(
      children: [
        // Toolbar
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter tabs
              Row(
                children: [
                  _FilterTab(
                    label: 'All',
                    isSelected: filterState.status == null,
                    onTap: () => ref.read(outcomeFiltersProvider.notifier).setStatus(null),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  _FilterTab(
                    label: 'Active',
                    isSelected: filterState.status == OutcomeStatus.IN_PROGRESS,
                    onTap: () => ref.read(outcomeFiltersProvider.notifier).setStatus(OutcomeStatus.IN_PROGRESS),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  _FilterTab(
                    label: 'Validated',
                    isSelected: filterState.status == OutcomeStatus.VALIDATED,
                    onTap: () => ref.read(outcomeFiltersProvider.notifier).setStatus(OutcomeStatus.VALIDATED),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  _FilterTab(
                    label: 'Invalidated',
                    isSelected: filterState.status == OutcomeStatus.INVALIDATED,
                    onTap: () => ref.read(outcomeFiltersProvider.notifier).setStatus(OutcomeStatus.INVALIDATED),
                  ),
                  const Spacer(),
                  // Search
                  SizedBox(
                    width: 220,
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) => ref.read(outcomeFiltersProvider.notifier).setSearch(value),
                      decoration: InputDecoration(
                        hintText: 'Search outcomes...',
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
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          borderSide: const BorderSide(color: AppColors.primary),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  FilledButton.icon(
                    onPressed: () => showCreateOutcomeDialog(context).then((_) {
                      ref.invalidate(filteredOutcomesProvider);
                    }),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('New Outcome'),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Content
        Expanded(
          child: outcomesAsync.when(
            data: (outcomes) {
              if (outcomes.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.flag_outlined, size: 64,
                          color: AppColors.textTertiary),
                      const SizedBox(height: AppSpacing.md),
                      Text('No outcomes yet',
                          style: AppTypography.h3
                              .copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                );
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(AppSpacing.pagePaddingHorizontal),
                      itemCount: outcomes.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: OutcomeCardEnhanced(
                          outcome: outcomes[index],
                          onTap: () => context.go(
                              Routes.outcomeById(outcomes[index].id)),
                        ),
                      ),
                    ),
                  ),
                  // Footer with summary stats
                  _FooterStats(outcomes: outcomes),
                ],
              );
            },
            loading: () =>
                const LoadingIndicator(message: 'Loading outcomes...'),
            error: (e, _) => ErrorView(
              message: e.toString(),
              onRetry: () => ref.invalidate(filteredOutcomesProvider),
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterTab({
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
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: isSelected ? AppColors.textOnPrimary : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _FooterStats extends StatelessWidget {
  final List<Outcome> outcomes;

  const _FooterStats({required this.outcomes});

  @override
  Widget build(BuildContext context) {
    final total = outcomes.length;
    final validated = outcomes.where((o) => o.status == OutcomeStatus.VALIDATED).length;
    final inProgress = outcomes.where((o) => o.status == OutcomeStatus.IN_PROGRESS).length;
    final abandoned = outcomes.where((o) => o.status == OutcomeStatus.ABANDONED).length;
    final validationPercent = total > 0 ? ((validated / total) * 100).toStringAsFixed(0) : '0';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$total Total Outcomes  •  $validated Validated ($validationPercent%)  •  $inProgress In Progress  •  $abandoned Abandoned',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
