import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/avatar.dart';
import '../../../shared/widgets/common/loading_indicator.dart';
import '../../../shared/widgets/common/error_view.dart';
import '../providers/teams_providers.dart';

class StakeholderScorecard extends ConsumerWidget {
  const StakeholderScorecard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stakeholdersAsync = ref.watch(teamStakeholdersProvider);

    return stakeholdersAsync.when(
      data: (stakeholders) {
        if (stakeholders.isEmpty) {
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

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pagePaddingHorizontal),
          child: Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.lg,
            children: stakeholders
                .map((stakeholder) => _ScorecardCard(stakeholder: stakeholder))
                .toList(),
          ),
        );
      },
      loading: () =>
          const LoadingIndicator(message: 'Loading stakeholders...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () => ref.invalidate(teamStakeholdersProvider),
      ),
    );
  }
}

class _ScorecardCard extends StatelessWidget {
  final Stakeholder stakeholder;

  const _ScorecardCard({required this.stakeholder});

  Color _getResponseTimeColor(double? avgResponseTimeMinutes) {
    if (avgResponseTimeMinutes == null) return AppColors.textSecondary;

    // Green: <= 4 hours (240 minutes)
    if (avgResponseTimeMinutes <= 240) return AppColors.success;
    // Amber: <= 12 hours (720 minutes)
    if (avgResponseTimeMinutes <= 720) return AppColors.warning;
    // Red: > 12 hours
    return AppColors.error;
  }

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
            // Avatar + name + email
            Row(
              children: [
                ZAvatar(
                  name: stakeholder.fullName,
                  imageUrl: stakeholder.avatarUrl,
                  size: 40,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stakeholder.fullName,
                        style: AppTypography.labelLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (stakeholder.email.isNotEmpty)
                        Text(
                          stakeholder.email,
                          style: AppTypography.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Department tag
            if (stakeholder.department != null &&
                stakeholder.department!.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
                child: Text(
                  stakeholder.department!,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.warning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],

            // Response time
            Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 16,
                  color: _getResponseTimeColor(
                    stakeholder.stats?.avgResponseTimeMinutes,
                  ),
                ),
                const SizedBox(width: AppSpacing.xxs),
                Text(
                  'Response: ',
                  style: AppTypography.bodySmall,
                ),
                Text(
                  stakeholder.stats?.avgResponseTimeDisplay ?? 'N/A',
                  style: AppTypography.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _getResponseTimeColor(
                      stakeholder.stats?.avgResponseTimeMinutes,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),

            // Pending decisions count
            Text(
              '${stakeholder.pendingDecisionCount} decisions pending',
              style: AppTypography.bodySmall,
            ),
            const SizedBox(height: AppSpacing.xs),

            // SLA Compliance
            Row(
              children: [
                Text(
                  'SLA: ',
                  style: AppTypography.bodySmall,
                ),
                Text(
                  stakeholder.stats?.slaComplianceDisplay ?? 'N/A',
                  style: AppTypography.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: stakeholder.stats != null
                        ? Color(int.parse(stakeholder.stats!.performanceColor.replaceFirst('#', '0xFF')))
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
