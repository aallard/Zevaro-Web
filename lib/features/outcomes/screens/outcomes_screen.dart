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
              // Filter tabs
              _FilterTab(label: 'All', isSelected: true, onTap: () {}),
              const SizedBox(width: AppSpacing.xxs),
              _FilterTab(label: 'Active', isSelected: false, onTap: () {}),
              const SizedBox(width: AppSpacing.xxs),
              _FilterTab(label: 'Validated', isSelected: false, onTap: () {}),
              const SizedBox(width: AppSpacing.xxs),
              _FilterTab(label: 'Invalidated', isSelected: false, onTap: () {}),
              const Spacer(),
              // Search
              SizedBox(
                width: 200,
                child: TextField(
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
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              FilledButton.icon(
                onPressed: () => showCreateOutcomeDialog(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New Outcome'),
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
              return ListView.builder(
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
