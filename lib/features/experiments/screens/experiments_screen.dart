import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/loading_indicator.dart';
import '../../../shared/widgets/common/error_view.dart';
import '../providers/experiments_providers.dart';
import '../widgets/experiment_card.dart';

class ExperimentsScreen extends ConsumerWidget {
  const ExperimentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterTab = ref.watch(experimentFilterNotifierProvider);
    final experimentsAsync = ref.watch(filteredExperimentsProvider);
    final allExperimentsAsync = ref.watch(allExperimentsProvider);

    return Column(
      children: [
        // Toolbar
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pagePaddingHorizontal,
            vertical: AppSpacing.sm,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              _Tab(
                label: 'Running',
                icon: Icons.science,
                isSelected: filterTab == ExperimentFilterTab.running,
                onTap: () => ref
                    .read(experimentFilterNotifierProvider.notifier)
                    .setTab(ExperimentFilterTab.running),
              ),
              const SizedBox(width: AppSpacing.xxs),
              _Tab(
                label: 'Completed',
                icon: Icons.check_circle,
                isSelected: filterTab == ExperimentFilterTab.completed,
                onTap: () => ref
                    .read(experimentFilterNotifierProvider.notifier)
                    .setTab(ExperimentFilterTab.completed),
              ),
              const SizedBox(width: AppSpacing.xxs),
              _Tab(
                label: 'Draft',
                icon: Icons.description,
                isSelected: filterTab == ExperimentFilterTab.draft,
                onTap: () => ref
                    .read(experimentFilterNotifierProvider.notifier)
                    .setTab(ExperimentFilterTab.draft),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New Experiment'),
              ),
            ],
          ),
        ),

        // Content
        Expanded(
          child: experimentsAsync.when(
            data: (experiments) {
              if (experiments.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.biotech_outlined,
                          size: 64, color: AppColors.textTertiary),
                      const SizedBox(height: AppSpacing.md),
                      Text('No experiments found',
                          style: AppTypography.h3
                              .copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                );
              }
              return Column(
                children: [
                  // Summary stats line
                  allExperimentsAsync.when(
                    data: (allExperiments) {
                      final runningCount = allExperiments
                          .where((e) => e.status == ExperimentStatus.RUNNING)
                          .length;
                      final completedCount = allExperiments
                          .where((e) => e.status == ExperimentStatus.CONCLUDED)
                          .length;
                      final winRate = _calculateWinRate(allExperiments);

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.pagePaddingHorizontal,
                          vertical: AppSpacing.md,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant.withOpacity(0.3),
                          border: const Border(
                            bottom: BorderSide(color: AppColors.border),
                          ),
                        ),
                        child: Text(
                          '$runningCount Running · $completedCount Completed This Month · Win Rate: ${winRate.toStringAsFixed(0)}%',
                          style: AppTypography.labelMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(
                          AppSpacing.pagePaddingHorizontal),
                      itemCount: experiments.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: ExperimentCard(
                            experiment: experiments[index]),
                      ),
                    ),
                  ),
                ],
              );
            },
            loading: () => const LoadingIndicator(
                message: 'Loading experiments...'),
            error: (e, _) => ErrorView(
              message: e.toString(),
              onRetry: () =>
                  ref.invalidate(filteredExperimentsProvider),
            ),
          ),
        ),
      ],
    );
  }

  double _calculateWinRate(List<Experiment> experiments) {
    if (experiments.isEmpty) return 0;
    final completed = experiments
        .where((e) => e.status == ExperimentStatus.CONCLUDED)
        .toList();
    if (completed.isEmpty) return 0;
    final winners = completed.where((e) => e.isVariantWinning).length;
    return (winners / completed.length) * 100;
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _Tab({
    required this.label,
    this.icon,
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.xxs),
            ],
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textSecondary,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
