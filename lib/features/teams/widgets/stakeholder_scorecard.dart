import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/avatar.dart';
import '../../../shared/widgets/common/loading_indicator.dart';
import '../../../shared/widgets/common/error_view.dart';
import '../../stakeholders/providers/stakeholders_providers.dart';

class StakeholderScorecard extends ConsumerWidget {
  const StakeholderScorecard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // For now, we'll provide a placeholder list fetching
    // In a real implementation, this would call the stakeholder service
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person_search_outlined, size: 64,
              color: AppColors.textTertiary),
          const SizedBox(height: AppSpacing.md),
          Text('No stakeholders configured',
              style: AppTypography.h3
                  .copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.sm),
          Text('Stakeholders will appear here when configured',
              style: AppTypography.bodySmall),
        ],
      ),
    );
  }
}

class _ScorecardCard extends StatelessWidget {
  final Stakeholder stakeholder;

  const _ScorecardCard({required this.stakeholder});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar + name
            Row(
              children: [
                ZAvatar(
                  name: stakeholder.name,
                  size: 40,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(stakeholder.name,
                          style: AppTypography.h4),
                      if (stakeholder.email != null)
                        Text(stakeholder.email!,
                            style: AppTypography.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Domain tags
            if (stakeholder.domains != null &&
                stakeholder.domains!.isNotEmpty) ...[
              Wrap(
                spacing: AppSpacing.xxs,
                runSpacing: AppSpacing.xxs,
                children: stakeholder.domains!
                    .map((d) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                                AppSpacing.radiusFull),
                          ),
                          child: Text(
                            d,
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.warning,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: AppSpacing.md),
            ],

            // Response time
            Row(
              children: [
                Icon(Icons.timer_outlined,
                    size: 16, color: AppColors.textTertiary),
                const SizedBox(width: AppSpacing.xxs),
                Text(
                  'Avg Response: ',
                  style: AppTypography.bodySmall,
                ),
                Text(
                  'N/A',
                  style: AppTypography.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),

            // Decision stats
            Text(
              '0 pending · 0 completed',
              style: AppTypography.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
