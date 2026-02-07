import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/loading_indicator.dart';
import '../../../shared/widgets/common/error_view.dart';
import '../widgets/hypothesis_kanban.dart';

class HypothesesScreen extends ConsumerWidget {
  const HypothesesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedProjectId = ref.watch(selectedProjectIdProvider);
    final hypothesesAsync = ref.watch(
      hypothesisListProvider(projectId: selectedProjectId),
    );

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
              // View toggle (board view selected)
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'board',
                    icon: Icon(Icons.view_kanban, size: 18),
                    label: Text('Board'),
                  ),
                  ButtonSegment(
                    value: 'list',
                    icon: Icon(Icons.view_list, size: 18),
                    label: Text('List'),
                  ),
                ],
                selected: const {'board'},
                onSelectionChanged: (_) {},
                style: const ButtonStyle(
                  visualDensity: VisualDensity.compact,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Status filter pills
              _FilterPill(label: 'All', isSelected: true, onTap: () {}),
              const SizedBox(width: AppSpacing.xxs),
              _FilterPill(label: 'My Hypotheses', isSelected: false, onTap: () {}),
              const Spacer(),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New Hypothesis'),
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
                hypothesisListProvider(projectId: selectedProjectId),
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
