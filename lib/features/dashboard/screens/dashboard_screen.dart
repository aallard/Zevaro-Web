import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/common/loading_indicator.dart';
import '../../../shared/widgets/common/error_view.dart';
import '../providers/dashboard_providers.dart';
import '../widgets/stat_card.dart';
import '../widgets/decision_queue_preview.dart';
import '../widgets/my_pending_responses.dart';
import '../widgets/quick_actions.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= AppConstants.desktopBreakpoint;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: statsAsync.when(
        data: (stats) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Urgent alert banner
            if (stats.hasUrgentItems) _buildUrgentBanner(context, stats),

            // Stats grid
            _buildStatsGrid(context, stats, isWide),
            const SizedBox(height: AppSpacing.lg),

            // Main content
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        DecisionQueuePreview(),
                        SizedBox(height: AppSpacing.lg),
                        MyPendingResponses(),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  const Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        QuickActions(),
                      ],
                    ),
                  ),
                ],
              )
            else ...[
              const QuickActions(),
              const SizedBox(height: AppSpacing.lg),
              const DecisionQueuePreview(),
              const SizedBox(height: AppSpacing.lg),
              const MyPendingResponses(),
            ],
          ],
        ),
        loading: () => const Center(
            child: LoadingIndicator(message: 'Loading dashboard...')),
        error: (e, _) => ErrorView(
          message: e.toString(),
          onRetry: () => ref.invalidate(dashboardStatsProvider),
        ),
      ),
    );
  }

  Widget _buildUrgentBanner(BuildContext context, DashboardStats stats) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.error),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              _getUrgentMessage(stats),
              style: const TextStyle(color: AppColors.error),
            ),
          ),
          TextButton(
            onPressed: () => context.go(Routes.decisions),
            child: const Text(
              'View',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  String _getUrgentMessage(DashboardStats stats) {
    final parts = <String>[];
    if (stats.blockingDecisions > 0) {
      parts.add(
          '${stats.blockingDecisions} blocking decision${stats.blockingDecisions > 1 ? 's' : ''}');
    }
    if (stats.myPendingResponses > 0) {
      parts.add(
          '${stats.myPendingResponses} response${stats.myPendingResponses > 1 ? 's' : ''} needed from you');
    }
    return parts.join(' • ');
  }

  Widget _buildStatsGrid(
      BuildContext context, DashboardStats stats, bool isWide) {
    final cards = [
      StatCard(
        title: 'Pending Decisions',
        value: stats.pendingDecisions.toString(),
        icon: Icons.how_to_vote_outlined,
        color: AppColors.primary,
        subtitle: '${stats.blockingDecisions} blocking',
        isUrgent: stats.blockingDecisions > 0,
        onTap: () => context.go(Routes.decisions),
      ),
      StatCard(
        title: 'My Pending Responses',
        value: stats.myPendingResponses.toString(),
        icon: Icons.pending_actions,
        color: AppColors.warning,
        subtitle: 'Awaiting your input',
        isUrgent: stats.myPendingResponses > 0,
        onTap: () => context.go(Routes.stakeholders),
      ),
      StatCard(
        title: 'Active Outcomes',
        value: stats.activeOutcomes.toString(),
        icon: Icons.flag_outlined,
        color: AppColors.success,
        onTap: () => context.go(Routes.outcomes),
      ),
      StatCard(
        title: 'Active Hypotheses',
        value: stats.activeHypotheses.toString(),
        icon: Icons.science_outlined,
        color: AppColors.secondary,
        subtitle: '${stats.blockedHypotheses} blocked',
        onTap: () => context.go(Routes.hypotheses),
      ),
    ];

    if (isWide) {
      return Row(
        children: cards
            .map((card) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.md),
                    child: card,
                  ),
                ))
            .toList(),
      );
    }

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppSpacing.md,
      mainAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.3,
      children: cards,
    );
  }
}
