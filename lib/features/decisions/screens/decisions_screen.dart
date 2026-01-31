import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../providers/decisions_providers.dart';
import '../widgets/create_decision_dialog.dart';
import '../widgets/decision_board.dart';
import '../widgets/decision_list.dart';
import '../widgets/decision_filters.dart';

class DecisionsScreen extends ConsumerWidget {
  const DecisionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewMode = ref.watch(decisionViewModeProvider);

    return Column(
      children: [
        // Toolbar
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(
              bottom: BorderSide(color: AppColors.border),
            ),
          ),
          child: Row(
            children: [
              // Filters
              const Expanded(child: DecisionFiltersBar()),

              // View toggle
              SegmentedButton<ViewMode>(
                segments: const [
                  ButtonSegment(
                    value: ViewMode.board,
                    icon: Icon(Icons.view_kanban, size: 18),
                  ),
                  ButtonSegment(
                    value: ViewMode.list,
                    icon: Icon(Icons.view_list, size: 18),
                  ),
                ],
                selected: {viewMode},
                onSelectionChanged: (selected) {
                  if (selected.first == ViewMode.board) {
                    ref.read(decisionViewModeProvider.notifier).setBoard();
                  } else {
                    ref.read(decisionViewModeProvider.notifier).setList();
                  }
                },
              ),

              const SizedBox(width: AppSpacing.md),

              // Add decision button
              FilledButton.icon(
                onPressed: () => showCreateDecisionDialog(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New Decision'),
              ),
            ],
          ),
        ),

        // Content
        Expanded(
          child: viewMode == ViewMode.board
              ? const DecisionBoard()
              : const DecisionList(),
        ),
      ],
    );
  }
}
