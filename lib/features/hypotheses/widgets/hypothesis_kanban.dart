import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/draggable_kanban.dart';
import '../providers/hypotheses_providers.dart';
import 'hypothesis_card_enhanced.dart';

class HypothesisKanban extends ConsumerWidget {
  final List<Hypothesis> hypotheses;

  const HypothesisKanban({super.key, required this.hypotheses});

  Map<String, List<Hypothesis>> get _grouped {
    final groups = <String, List<Hypothesis>>{
      'Draft': [],
      'Ready': [],
      'Building': [],
      'Measuring': [],
      'Concluded': [],
    };

    for (final h in hypotheses) {
      final status = h.status;
      if (status == HypothesisStatus.DRAFT) {
        groups['Draft']!.add(h);
      } else if (status == HypothesisStatus.READY) {
        groups['Ready']!.add(h);
      } else if (status == HypothesisStatus.BUILDING ||
          status == HypothesisStatus.BLOCKED) {
        groups['Building']!.add(h);
      } else if (status == HypothesisStatus.DEPLOYED ||
          status == HypothesisStatus.MEASURING) {
        groups['Measuring']!.add(h);
      } else {
        groups['Concluded']!.add(h);
      }
    }
    return groups;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grouped = _grouped;

    final columns = [
      KanbanColumn(
        id: 'Draft',
        title: 'Draft',
        items: grouped['Draft']!,
        headerColor: AppColors.hypothesisDraft,
        backgroundColor: AppColors.hypothesisDraft.withOpacity(0.03),
        icon: Icons.edit_note,
      ),
      KanbanColumn(
        id: 'Ready',
        title: 'Ready',
        items: grouped['Ready']!,
        headerColor: AppColors.hypothesisReady,
        backgroundColor: AppColors.hypothesisReady.withOpacity(0.03),
        icon: Icons.check_circle_outline,
      ),
      KanbanColumn(
        id: 'Building',
        title: 'Building',
        items: grouped['Building']!,
        headerColor: AppColors.hypothesisBuilding,
        backgroundColor: AppColors.hypothesisBuilding.withOpacity(0.03),
        icon: Icons.construction,
      ),
      KanbanColumn(
        id: 'Measuring',
        title: 'Measuring',
        items: grouped['Measuring']!,
        headerColor: AppColors.hypothesisMeasuring,
        backgroundColor: AppColors.hypothesisMeasuring.withOpacity(0.03),
        icon: Icons.science,
      ),
      KanbanColumn(
        id: 'Concluded',
        title: 'Concluded',
        items: grouped['Concluded']!,
        headerColor: AppColors.hypothesisValidated,
        backgroundColor: AppColors.hypothesisValidated.withOpacity(0.03),
        icon: Icons.verified,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: DraggableKanban<Hypothesis>(
        columns: columns,
        cardBuilder: (hypothesis, isDragging) => HypothesisCardEnhanced(
          hypothesis: hypothesis,
        ),
        onCardMoved: (hypothesis, fromColumnId, toColumnId) {
          _handleCardMoved(context, ref, hypothesis, fromColumnId, toColumnId);
        },
        idExtractor: (hypothesis) => hypothesis.id,
        columnMinWidth: 280,
        cardSpacing: 8,
        emptyColumnBuilder: (columnId) => _buildEmptyState(columnId),
      ),
    );
  }

  void _handleCardMoved(
    BuildContext context,
    WidgetRef ref,
    Hypothesis hypothesis,
    String fromColumnId,
    String toColumnId,
  ) {
    if (fromColumnId == toColumnId) return;

    // Map column ID to hypothesis status
    final statusMap = {
      'Draft': HypothesisStatus.DRAFT,
      'Ready': HypothesisStatus.READY,
      'Building': HypothesisStatus.BUILDING,
      'Measuring': HypothesisStatus.MEASURING,
      'Concluded': HypothesisStatus.VALIDATED,
    };

    final newStatus = statusMap[toColumnId];
    if (newStatus == null) return;

    // Update hypothesis status via the transition action
    try {
      final actions = ref.read(transitionHypothesisStatusProvider.notifier);
      actions.transition(hypothesis.id, newStatus);
    } catch (e) {
      // Fallback: Print error and continue
      debugPrint('Error updating hypothesis status: $e');
    }
  }

  Widget _buildEmptyState(String columnId) {
    final iconMap = {
      'Draft': Icons.edit_note,
      'Ready': Icons.check_circle_outline,
      'Building': Icons.construction,
      'Measuring': Icons.science,
      'Concluded': Icons.verified,
    };

    final messageMap = {
      'Draft': 'No draft hypotheses',
      'Ready': 'No hypotheses ready to build',
      'Building': 'No hypotheses being built',
      'Measuring': 'No hypotheses being measured',
      'Concluded': 'No concluded hypotheses',
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
