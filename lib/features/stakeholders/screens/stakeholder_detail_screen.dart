import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/common/avatar.dart';
import '../../../shared/widgets/common/loading_indicator.dart';
import '../../../shared/widgets/common/error_view.dart';
import '../providers/stakeholders_providers.dart';
import '../widgets/stakeholder_stats_card.dart';
import '../widgets/pending_responses_card.dart';
import '../widgets/response_history_card.dart';

class StakeholderDetailScreen extends ConsumerWidget {
  final String id;

  const StakeholderDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stakeholderAsync = ref.watch(stakeholderDetailProvider(id));
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > AppConstants.tabletBreakpoint;

    return stakeholderAsync.when(
      data: (stakeholder) => SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            TextButton.icon(
              onPressed: () => context.go(Routes.stakeholders),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('Back to Stakeholders'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                padding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Header card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    ZAvatar(
                      name: stakeholder.fullName,
                      imageUrl: stakeholder.avatarUrl,
                      size: 72,
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(stakeholder.fullName, style: AppTypography.h2),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            stakeholder.email,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          if (stakeholder.department != null ||
                              stakeholder.role != null) ...[
                            const SizedBox(height: AppSpacing.sm),
                            Row(
                              children: [
                                if (stakeholder.department != null)
                                  _buildBadge(
                                    icon: Icons.business_outlined,
                                    label: stakeholder.department!,
                                  ),
                                if (stakeholder.department != null &&
                                    stakeholder.role != null)
                                  const SizedBox(width: AppSpacing.sm),
                                if (stakeholder.role != null)
                                  _buildBadge(
                                    icon: Icons.work_outline,
                                    label: stakeholder.role!,
                                  ),
                              ],
                            ),
                          ],
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            children: [
                              _buildStatusBadge(
                                icon: Icons.pending_actions,
                                label: '${stakeholder.pendingDecisionCount} pending',
                                color: stakeholder.pendingDecisionCount > 0
                                    ? AppColors.warning
                                    : AppColors.success,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              if (stakeholder.overdueDecisionCount > 0)
                                _buildStatusBadge(
                                  icon: Icons.warning_amber,
                                  label: '${stakeholder.overdueDecisionCount} overdue',
                                  color: AppColors.error,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (stakeholder.stats?.isImproving ?? false)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusFull),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.trending_up,
                                size: 16, color: AppColors.success),
                            const SizedBox(width: 4),
                            Text(
                              'Improving',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Content
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        StakeholderStatsCard(stakeholder: stakeholder),
                        const SizedBox(height: AppSpacing.lg),
                        PendingResponsesCard(stakeholderId: stakeholder.id),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    flex: 1,
                    child: ResponseHistoryCard(stakeholderId: stakeholder.id),
                  ),
                ],
              )
            else ...[
              StakeholderStatsCard(stakeholder: stakeholder),
              const SizedBox(height: AppSpacing.lg),
              PendingResponsesCard(stakeholderId: stakeholder.id),
              const SizedBox(height: AppSpacing.lg),
              ResponseHistoryCard(stakeholderId: stakeholder.id),
            ],
          ],
        ),
      ),
      loading: () => const LoadingIndicator(message: 'Loading stakeholder...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () => ref.invalidate(stakeholderDetailProvider(id)),
      ),
    );
  }

  Widget _buildBadge({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.labelSmall,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
