import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart' hide DecisionList;
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
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
    final filters = ref.watch(decisionFiltersProvider);

    return Column(
      children: [
        // Toolbar with filter pills, search, and controls
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(
              bottom: BorderSide(color: AppColors.border),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.sm,
            children: [
              // Top row: Filter pills and View toggle
              Row(
                children: [
                  // Filter pills
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          // "All Types" pill (filled indigo when active)
                          _FilterPill(
                            label: 'All Types',
                            isActive: filters.type == null,
                            onTap: () =>
                                ref.read(decisionFiltersProvider.notifier).setType(null),
                          ),
                          const SizedBox(width: AppSpacing.sm),

                          // "My Decisions" pill
                          _FilterPill(
                            label: 'My Decisions',
                            isActive: false,
                            onTap: () {
                              // TODO: Implement "My Decisions" filter
                            },
                          ),
                          const SizedBox(width: AppSpacing.sm),

                          // "Blocking" pill
                          _FilterPill(
                            label: 'Blocking',
                            isActive: filters.urgency?.displayName == 'Blocking',
                            onTap: () {
                              ref
                                  .read(decisionFiltersProvider.notifier)
                                  .setUrgency(DecisionUrgency.BLOCKING);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: AppSpacing.md),

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

              // Second row: Search bar and Sort dropdown
              Row(
                children: [
                  // Search bar
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search decisions...',
                        prefixIcon: const Icon(Icons.search, size: 18),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.sm,
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusSm),
                          borderSide:
                              const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusSm),
                          borderSide:
                              const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusSm),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        ref
                            .read(decisionFiltersProvider.notifier)
                            .setSearch(value.isEmpty ? null : value);
                      },
                    ),
                  ),

                  const SizedBox(width: AppSpacing.md),

                  // Sort dropdown
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      // TODO: Implement sorting
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem<String>(
                        value: 'priority',
                        child: Text('Priority'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'created',
                        child: Text('Created'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'updated',
                        child: Text('Updated'),
                      ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Sort: Priority',
                            style: AppTypography.labelSmall,
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_drop_down, size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
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

/// Reusable filter pill widget
class _FilterPill extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          ),
          child: Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: isActive ? AppColors.textOnPrimary : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
