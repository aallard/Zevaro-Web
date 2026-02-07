import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import 'hypothesis_card_enhanced.dart';

class HypothesisKanban extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final grouped = _grouped;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _KanbanColumn(
            title: 'Draft',
            icon: Icons.edit_note,
            color: AppColors.hypothesisDraft,
            hypotheses: grouped['Draft']!,
          ),
          const SizedBox(width: AppSpacing.sm),
          _KanbanColumn(
            title: 'Ready',
            icon: Icons.check_circle_outline,
            color: AppColors.hypothesisReady,
            hypotheses: grouped['Ready']!,
          ),
          const SizedBox(width: AppSpacing.sm),
          _KanbanColumn(
            title: 'Building',
            icon: Icons.construction,
            color: AppColors.hypothesisBuilding,
            hypotheses: grouped['Building']!,
          ),
          const SizedBox(width: AppSpacing.sm),
          _KanbanColumn(
            title: 'Measuring',
            icon: Icons.science,
            color: AppColors.hypothesisMeasuring,
            hypotheses: grouped['Measuring']!,
          ),
          const SizedBox(width: AppSpacing.sm),
          _KanbanColumn(
            title: 'Concluded',
            icon: Icons.verified,
            color: AppColors.hypothesisValidated,
            hypotheses: grouped['Concluded']!,
          ),
        ],
      ),
    );
  }
}

class _KanbanColumn extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<Hypothesis> hypotheses;

  const _KanbanColumn({
    required this.title,
    required this.icon,
    required this.color,
    required this.hypotheses,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Row(
                children: [
                  Icon(icon, size: 16, color: color),
                  const SizedBox(width: AppSpacing.xxs),
                  Text(
                    title,
                    style: AppTypography.labelMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                    child: Text(
                      '${hypotheses.length}',
                      style: AppTypography.labelSmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Cards
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: AppSpacing.xxs,
                ),
                itemCount: hypotheses.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: HypothesisCardEnhanced(
                    hypothesis: hypotheses[index],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
