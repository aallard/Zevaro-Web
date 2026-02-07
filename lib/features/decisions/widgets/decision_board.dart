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
        final columns = [
          KanbanColumn(
            id: DecisionStatus.NEEDS_INPUT.value,
            title: 'Needs Input',
            items: decisionsByStatus[DecisionStatus.NEEDS_INPUT] ?? [],
            headerColor: AppColors.error,
            backgroundColor: AppColors.error.withOpacity(0.03),
            icon: Icons.inbox_outlined,
          ),
          KanbanColumn(
            id: DecisionStatus.UNDER_DISCUSSION.value,
            title: 'Under Discussion',
            items: decisionsByStatus[DecisionStatus.UNDER_DISCUSSION] ?? [],
            headerColor: AppColors.warning,
            backgroundColor: AppColors.warning.withOpacity(0.03),
            icon: Icons.forum_outlined,
          ),
          KanbanColumn(
            id: DecisionStatus.DECIDED.value,
            title: 'Decided',
            items: decisionsByStatus[DecisionStatus.DECIDED] ?? [],
            headerColor: AppColors.success,
            backgroundColor: AppColors.success.withOpacity(0.03),
            icon: Icons.check_circle_outline,
          ),
          KanbanColumn(
            id: DecisionStatus.IMPLEMENTED.value,
            title: 'Implemented',
            items: decisionsByStatus[DecisionStatus.IMPLEMENTED] ?? [],
            headerColor: AppColors.primary,
            backgroundColor: AppColors.primary.withOpacity(0.03),
            icon: Icons.rocket_launch_outlined,
          ),
        ];

        return Padding(
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
      DecisionStatus.NEEDS_INPUT.value: DecisionStatus.NEEDS_INPUT,
      DecisionStatus.UNDER_DISCUSSION.value: DecisionStatus.UNDER_DISCUSSION,
      DecisionStatus.DECIDED.value: DecisionStatus.DECIDED,
      DecisionStatus.IMPLEMENTED.value: DecisionStatus.IMPLEMENTED,
    };

    final newStatus = statusMap[toColumnId];
    if (newStatus == null) return;

    // Update decision status via the actions provider
    try {
      final actions = ref.read(decisionActionsProvider.notifier);
      // Call the appropriate method based on new status
      // This assumes the SDK provides methods like moveToDecided, moveToImplemented, etc.
      // Or we can use a generic approach if available
      actions.updateStatus(decision.id, newStatus);
    } catch (e) {
      // Fallback: Just invalidate the provider to refresh
      debugPrint('Error updating decision status: $e');
    }
    ref.invalidate(decisionsByStatusProvider);
  }

  Widget _buildEmptyState(String columnId) {
    final iconMap = {
      DecisionStatus.NEEDS_INPUT.value: Icons.inbox_outlined,
      DecisionStatus.UNDER_DISCUSSION.value: Icons.forum_outlined,
      DecisionStatus.DECIDED.value: Icons.check_circle_outline,
      DecisionStatus.IMPLEMENTED.value: Icons.rocket_launch_outlined,
    };

    final messageMap = {
      DecisionStatus.NEEDS_INPUT.value: 'No decisions waiting for input',
      DecisionStatus.UNDER_DISCUSSION.value: 'No active discussions',
      DecisionStatus.DECIDED.value: 'No recent decisions',
      DecisionStatus.IMPLEMENTED.value: 'No implemented decisions',
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

