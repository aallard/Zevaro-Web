import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/loading_indicator.dart';
import '../../../shared/widgets/common/error_view.dart';
import '../../../shared/widgets/common/draggable_kanban.dart';
import '../providers/decisions_providers.dart';
import 'decision_card.dart';

class DecisionBoard extends ConsumerWidget {
  const DecisionBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decisionsAsync = ref.watch(decisionsByStatusProvider);

    return decisionsAsync.when(
      data: (decisionsByStatus) {
        final columns = <KanbanColumn<Decision>>[
          KanbanColumn(
            id: DecisionStatus.NEEDS_INPUT.name,
            title: 'Needs Input',
            items: decisionsByStatus[DecisionStatus.NEEDS_INPUT] ?? [],
            headerColor: AppColors.error,
            backgroundColor: AppColors.error.withOpacity(0.03),
            icon: Icons.inbox_outlined,
          ),
          KanbanColumn(
            id: DecisionStatus.UNDER_DISCUSSION.name,
            title: 'Under Discussion',
            items: decisionsByStatus[DecisionStatus.UNDER_DISCUSSION] ?? [],
            headerColor: AppColors.warning,
            backgroundColor: AppColors.warning.withOpacity(0.03),
            icon: Icons.forum_outlined,
          ),
          KanbanColumn(
            id: DecisionStatus.DECIDED.name,
            title: 'Decided',
            items: decisionsByStatus[DecisionStatus.DECIDED] ?? [],
            headerColor: AppColors.success,
            backgroundColor: AppColors.success.withOpacity(0.03),
            icon: Icons.check_circle_outline,
          ),
          KanbanColumn(
            id: DecisionStatus.IMPLEMENTED.name,
            title: 'Implemented',
            items: decisionsByStatus[DecisionStatus.IMPLEMENTED] ?? [],
            headerColor: AppColors.primary,
            backgroundColor: AppColors.primary.withOpacity(0.03),
            icon: Icons.rocket_launch_outlined,
          ),
        ];

        // Calculate total decisions
        final totalDecisions = columns.fold<int>(
          0,
          (sum, column) => sum + column.items.length,
        );

        return Column(
          children: [
            // Board
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: DraggableKanban<Decision>(
                  columns: columns,
                  cardBuilder: (decision, isDragging) => DecisionCard(
                    decision: decision,
                  ),
                  onCardMoved: (decision, fromColumnId, toColumnId) {
                    _handleCardMoved(context, ref, decision, fromColumnId, toColumnId);
                  },
                  idExtractor: (decision) => decision.id,
                  columnMinWidth: 320,
                  cardSpacing: 8,
                  emptyColumnBuilder: (columnId) => _buildEmptyState(columnId),
                ),
              ),
            ),

            // Pagination footer
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  top: BorderSide(color: AppColors.border),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Showing $totalDecisions decision${totalDecisions != 1 ? 's' : ''}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      loading: () => const LoadingIndicator(message: 'Loading decisions...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () => ref.invalidate(decisionsByStatusProvider),
      ),
    );
  }

  void _handleCardMoved(
    BuildContext context,
    WidgetRef ref,
    Decision decision,
    String fromColumnId,
    String toColumnId,
  ) {
    if (fromColumnId == toColumnId) return;

    // Map column ID to decision status
    final statusMap = {
      DecisionStatus.NEEDS_INPUT.name: DecisionStatus.NEEDS_INPUT,
      DecisionStatus.UNDER_DISCUSSION.name: DecisionStatus.UNDER_DISCUSSION,
      DecisionStatus.DECIDED.name: DecisionStatus.DECIDED,
      DecisionStatus.IMPLEMENTED.name: DecisionStatus.IMPLEMENTED,
    };

    final newStatus = statusMap[toColumnId];
    if (newStatus == null) return;

    // TODO: SDK doesn't yet support arbitrary status transitions via drag.
    // For now, just refresh the board. Wire up resolveDecision / escalate when ready.
    debugPrint('Decision ${decision.id} dragged to $newStatus — status update not yet wired');
    ref.invalidate(decisionsByStatusProvider);
  }

  Widget _buildEmptyState(String columnId) {
    final iconMap = {
      DecisionStatus.NEEDS_INPUT.name: Icons.inbox_outlined,
      DecisionStatus.UNDER_DISCUSSION.name: Icons.forum_outlined,
      DecisionStatus.DECIDED.name: Icons.check_circle_outline,
      DecisionStatus.IMPLEMENTED.name: Icons.rocket_launch_outlined,
    };

    final messageMap = {
      DecisionStatus.NEEDS_INPUT.name: 'No decisions waiting for input',
      DecisionStatus.UNDER_DISCUSSION.name: 'No active discussions',
      DecisionStatus.DECIDED.name: 'No recent decisions',
      DecisionStatus.IMPLEMENTED.name: 'No implemented decisions',
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconMap[columnId] ?? Icons.inbox_outlined,
              size: 32,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              messageMap[columnId] ?? 'No items',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

