import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/loading_indicator.dart';
import '../../../shared/widgets/common/error_view.dart';
import '../widgets/metric_card.dart';
import '../widgets/decision_queue_panel.dart';
import '../widgets/decision_velocity_chart.dart';
import '../widgets/outcomes_progress_panel.dart';
import '../widgets/activity_feed_panel.dart';
import '../providers/dashboard_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedProjectId = ref.watch(selectedProjectIdProvider);

    if (selectedProjectId == null) {
      return _NoProjectSelected();
    }

    final dashboardAsync = ref.watch(projectDashboardProvider(selectedProjectId));

    return dashboardAsync.when(
      data: (dashboard) => _DashboardContent(dashboard: dashboard),
      loading: () => const LoadingIndicator(message: 'Loading dashboard...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () =>
            ref.invalidate(projectDashboardProvider(selectedProjectId)),
      ),
    );
  }
}

class _NoProjectSelected extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.dashboard_outlined, size: 64, color: AppColors.textTertiary),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Select a project',
            style: AppTypography.h3.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Choose a project from the sidebar to view its dashboard.',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }
}

class _DashboardContent extends ConsumerWidget {
  final ProjectDashboard dashboard;

  const _DashboardContent({required this.dashboard});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedProject = ref.watch(selectedProjectProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.pagePaddingHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb
          selectedProject.when(
            data: (project) {
              if (project != null) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Row(
                    children: [
                      Text(
                        'Projects',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                        child: Icon(
                          Icons.chevron_right,
                          size: 16,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      Text(
                        project.name,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                        child: Icon(
                          Icons.chevron_right,
                          size: 16,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      Text(
                        'Dashboard',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // Row 1: Metric cards
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = (constraints.maxWidth - AppSpacing.md * 3) / 4;
              return Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children: [
                  SizedBox(
                    width: cardWidth.clamp(160, 300),
                    child: MetricCard(
                      title: 'Pending Decisions',
                      value: '${dashboard.pendingDecisionCount}',
                      icon: Icons.warning_amber,
                      color: dashboard.slaBreachedDecisionCount > 0
                          ? AppColors.error
                          : AppColors.warning,
                      subtitle: dashboard.slaBreachedDecisionCount > 0
                          ? '${dashboard.slaBreachedDecisionCount} SLA breached'
                          : null,
                      subtitleColor: AppColors.error,
                    ),
                  ),
                  SizedBox(
                    width: cardWidth.clamp(160, 300),
                    child: MetricCard(
                      title: 'Active Outcomes',
                      value: '${dashboard.activeOutcomeCount}',
                      icon: Icons.check_circle_outline,
                      color: AppColors.success,
                      subtitle:
                          '${dashboard.outcomeValidationPercentage.toStringAsFixed(0)}% validated',
                    ),
                  ),
                  SizedBox(
                    width: cardWidth.clamp(160, 300),
                    child: MetricCard(
                      title: 'Running Experiments',
                      value: '${dashboard.runningExperimentCount}',
                      icon: Icons.science_outlined,
                      color: AppColors.secondary,
                    ),
                  ),
                  SizedBox(
                    width: cardWidth.clamp(160, 300),
                    child: MetricCard(
                      title: 'Avg Decision Time',
                      value: '${dashboard.avgDecisionTimeHours.toStringAsFixed(1)}h',
                      icon: Icons.schedule_outlined,
                      color: AppColors.secondary,
                      subtitle: dashboard.avgDecisionTimeTrend < 0
                          ? 'Improving'
                          : dashboard.avgDecisionTimeTrend > 0
                              ? 'Slowing down'
                              : null,
                      subtitleColor: dashboard.avgDecisionTimeTrend < 0
                          ? AppColors.success
                          : AppColors.error,
                      trendIcon: dashboard.avgDecisionTimeTrend < 0
                          ? Icons.trending_down
                          : dashboard.avgDecisionTimeTrend > 0
                              ? Icons.trending_up
                              : null,
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: AppSpacing.lg),

          // Row 2: Decision Queue + Velocity Chart
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 900) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: DecisionQueuePanel(
                        decisions: dashboard.decisionQueue,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      flex: 2,
                      child: DecisionVelocityChart(
                        metrics: dashboard.decisionVelocity,
                      ),
                    ),
                  ],
                );
              }
              return Column(
                children: [
                  DecisionQueuePanel(decisions: dashboard.decisionQueue),
                  const SizedBox(height: AppSpacing.md),
                  DecisionVelocityChart(metrics: dashboard.decisionVelocity),
                ],
              );
            },
          ),

          const SizedBox(height: AppSpacing.lg),

          // Row 3: Outcomes Progress + Activity Feed
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 900) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: OutcomesProgressPanel(
                        outcomes: dashboard.outcomeProgress,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: ActivityFeedPanel(
                        activities: dashboard.activityFeed,
                      ),
                    ),
                  ],
                );
              }
              return Column(
                children: [
                  OutcomesProgressPanel(outcomes: dashboard.outcomeProgress),
                  const SizedBox(height: AppSpacing.md),
                  ActivityFeedPanel(activities: dashboard.activityFeed),
                ],
              );
            },
          ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
