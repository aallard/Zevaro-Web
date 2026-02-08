import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
import '../../activity/activity.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedProgramId = ref.watch(selectedProgramIdProvider);

    if (selectedProgramId == null) {
      return const _OverviewDashboard();
    }

    final dashboardAsync =
        ref.watch(programDashboardProvider(selectedProgramId));

    return dashboardAsync.when(
      data: (dashboard) => _ProgramDashboardContent(dashboard: dashboard),
      loading: () => const LoadingIndicator(message: 'Loading dashboard...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () =>
            ref.invalidate(programDashboardProvider(selectedProgramId)),
      ),
    );
  }
}

/// Overview dashboard shown when no program is selected
class _OverviewDashboard extends ConsumerWidget {
  const _OverviewDashboard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programsAsync = ref.watch(programsProvider());
    final portfoliosAsync = ref.watch(portfoliosProvider);
    final blockingAsync = ref.watch(blockingDecisionsProvider);
    final activityAsync = ref.watch(filteredActivityFeedProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.pagePaddingHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Overview', style: AppTypography.h2),
          const SizedBox(height: AppSpacing.md),

          // Quick stats row
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth =
                  (constraints.maxWidth - AppSpacing.md * 3) / 4;
              return Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children: [
                  SizedBox(
                    width: cardWidth.clamp(140, 280),
                    child: programsAsync.when(
                      data: (programs) {
                        final active = programs
                            .where((p) => p.status.isActive)
                            .length;
                        return MetricCard(
                          title: 'Active Programs',
                          value: '$active',
                          icon: Icons.folder_outlined,
                          color: AppColors.primary,
                          subtitle: '${programs.length} total',
                        );
                      },
                      loading: () => const MetricCard(
                        title: 'Active Programs',
                        value: '-',
                        icon: Icons.folder_outlined,
                        color: AppColors.primary,
                      ),
                      error: (_, __) => const MetricCard(
                        title: 'Active Programs',
                        value: '-',
                        icon: Icons.folder_outlined,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth.clamp(140, 280),
                    child: portfoliosAsync.when(
                      data: (portfolios) => MetricCard(
                        title: 'Portfolios',
                        value: '${portfolios.length}',
                        icon: Icons.business_center_outlined,
                        color: AppColors.secondary,
                      ),
                      loading: () => const MetricCard(
                        title: 'Portfolios',
                        value: '-',
                        icon: Icons.business_center_outlined,
                        color: AppColors.secondary,
                      ),
                      error: (_, __) => const MetricCard(
                        title: 'Portfolios',
                        value: '-',
                        icon: Icons.business_center_outlined,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth.clamp(140, 280),
                    child: blockingAsync.when(
                      data: (decisions) => MetricCard(
                        title: 'Blocking Decisions',
                        value: '${decisions.length}',
                        icon: Icons.warning_amber,
                        color: decisions.isNotEmpty
                            ? AppColors.error
                            : AppColors.success,
                      ),
                      loading: () => const MetricCard(
                        title: 'Blocking Decisions',
                        value: '-',
                        icon: Icons.warning_amber,
                        color: AppColors.warning,
                      ),
                      error: (_, __) => const MetricCard(
                        title: 'Blocking Decisions',
                        value: '-',
                        icon: Icons.warning_amber,
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth.clamp(140, 280),
                    child: blockingAsync.when(
                      data: (decisions) {
                        final breached =
                            decisions.where((d) => d.isSlaBreached).length;
                        return MetricCard(
                          title: 'SLA Breached',
                          value: '$breached',
                          icon: Icons.local_fire_department,
                          color: breached > 0
                              ? AppColors.error
                              : AppColors.success,
                        );
                      },
                      loading: () => const MetricCard(
                        title: 'SLA Breached',
                        value: '-',
                        icon: Icons.local_fire_department,
                        color: AppColors.warning,
                      ),
                      error: (_, __) => const MetricCard(
                        title: 'SLA Breached',
                        value: '-',
                        icon: Icons.local_fire_department,
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: AppSpacing.lg),

          // Portfolio overview + Decision queue summary
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 900) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _PortfolioOverview(),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      flex: 2,
                      child: _DecisionQueueSummary(),
                    ),
                  ],
                );
              }
              return Column(
                children: [
                  _PortfolioOverview(),
                  const SizedBox(height: AppSpacing.md),
                  _DecisionQueueSummary(),
                ],
              );
            },
          ),

          const SizedBox(height: AppSpacing.lg),

          // Program summary + Activity feed
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 900) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _ProgramSummary()),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _ActivityFeedSection(
                        activityAsync: activityAsync,
                      ),
                    ),
                  ],
                );
              }
              return Column(
                children: [
                  _ProgramSummary(),
                  const SizedBox(height: AppSpacing.md),
                  _ActivityFeedSection(activityAsync: activityAsync),
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

class _PortfolioOverview extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final portfoliosAsync = ref.watch(portfoliosProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Portfolios', style: AppTypography.h4),
              const Spacer(),
              TextButton(
                onPressed: () => context.go(Routes.portfolios),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          portfoliosAsync.when(
            data: (portfolios) {
              if (portfolios.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Center(
                    child: Text('No portfolios yet',
                        style: AppTypography.bodySmall),
                  ),
                );
              }
              return Column(
                children: portfolios.take(5).map((p) {
                  return InkWell(
                    onTap: () => context.go(Routes.portfolioById(p.id)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.xs),
                      child: Row(
                        children: [
                          Icon(Icons.business_center_outlined,
                              size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(p.name,
                                style: AppTypography.bodyMedium),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _portfolioStatusColor(p.status)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                  AppSpacing.radiusSm),
                            ),
                            child: Text(
                              p.status.name,
                              style: AppTypography.labelSmall.copyWith(
                                fontSize: 10,
                                color: _portfolioStatusColor(p.status),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            '${p.programCount ?? 0} programs',
                            style: AppTypography.labelSmall
                                .copyWith(color: AppColors.textTertiary),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          const Icon(Icons.chevron_right,
                              size: 14, color: AppColors.textTertiary),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Color _portfolioStatusColor(PortfolioStatus status) {
    switch (status) {
      case PortfolioStatus.ACTIVE:
        return AppColors.success;
      case PortfolioStatus.ON_HOLD:
        return AppColors.warning;
      case PortfolioStatus.COMPLETED:
        return AppColors.primary;
      case PortfolioStatus.ARCHIVED:
        return AppColors.textTertiary;
    }
  }
}

class _DecisionQueueSummary extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decisionsAsync = ref.watch(decisionQueueProvider());

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Decision Queue', style: AppTypography.h4),
              const Spacer(),
              TextButton(
                onPressed: () => context.go(Routes.decisions),
                child: const Text('View Queue'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          decisionsAsync.when(
            data: (decisions) {
              final breached =
                  decisions.where((d) => d.isSlaBreached).length;
              final atRisk = decisions
                  .where((d) =>
                      !d.isSlaBreached &&
                      d.timeToSla != null &&
                      d.timeToSla!.inHours < 2)
                  .length;
              final onTrack = decisions.length - breached - atRisk;

              return Column(
                children: [
                  // SLA summary row
                  Row(
                    children: [
                      _SlaStatPill(
                        label: 'Breached',
                        count: breached,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      _SlaStatPill(
                        label: 'At Risk',
                        count: atRisk,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      _SlaStatPill(
                        label: 'On Track',
                        count: onTrack,
                        color: AppColors.success,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  // Top 3 urgent
                  ...decisions.take(3).map((d) => Padding(
                        padding: const EdgeInsets.only(
                            bottom: AppSpacing.xs),
                        child: InkWell(
                          onTap: () =>
                              context.go(Routes.decisionById(d.id)),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: d.isSlaBreached
                                      ? AppColors.error
                                      : AppColors.success,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Text(
                                  d.title,
                                  style: AppTypography.bodySmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _SlaStatPill extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _SlaStatPill({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '$count $label',
            style: AppTypography.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgramSummary extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programsAsync = ref.watch(programsProvider());

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Programs', style: AppTypography.h4),
              const Spacer(),
              TextButton(
                onPressed: () => context.go(Routes.programs),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          programsAsync.when(
            data: (programs) {
              final active =
                  programs.where((p) => p.status.isActive).toList();
              if (active.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Center(
                    child: Text('No active programs',
                        style: AppTypography.bodySmall),
                  ),
                );
              }
              return Column(
                children: active.take(6).map((p) {
                  return InkWell(
                    onTap: () =>
                        context.go(Routes.programById(p.id)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.xs),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _parseColor(p.color),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(p.name,
                                style: AppTypography.bodyMedium),
                          ),
                          Text(
                            '${p.decisionCount ?? 0} decisions',
                            style: AppTypography.labelSmall
                                .copyWith(color: AppColors.textTertiary),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          const Icon(Icons.chevron_right,
                              size: 14, color: AppColors.textTertiary),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String? hex) {
    if (hex != null) {
      try {
        return Color(
            int.parse('FF${hex.replaceFirst('#', '')}', radix: 16));
      } catch (_) {}
    }
    return AppColors.primary;
  }
}

class _ActivityFeedSection extends StatelessWidget {
  final AsyncValue<List<ActivityEvent>> activityAsync;

  const _ActivityFeedSection({required this.activityAsync});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Recent Activity', style: AppTypography.h4),
              const Spacer(),
              TextButton(
                onPressed: () => GoRouter.of(context).go(Routes.activity),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          activityAsync.when(
            data: (events) {
              if (events.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Center(
                    child: Text('No recent activity',
                        style: AppTypography.bodySmall),
                  ),
                );
              }
              return Column(
                children: events.take(8).map((e) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.only(top: 6),
                          decoration: BoxDecoration(
                            color: _actionColor(e.action),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: AppTypography.bodySmall,
                              children: [
                                TextSpan(
                                  text: e.actorName ?? 'System',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                                TextSpan(
                                    text:
                                        ' ${e.action.toLowerCase().replaceAll('_', ' ')}'),
                                if (e.entityTitle != null)
                                  TextSpan(
                                    text: ' ${e.entityTitle}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Color _actionColor(String action) {
    switch (action.toUpperCase()) {
      case 'CREATED':
        return const Color(0xFF16A34A);
      case 'UPDATED':
        return AppColors.primary;
      case 'DELETED':
        return AppColors.error;
      case 'STATUS_CHANGED':
        return const Color(0xFFCA8A04);
      default:
        return AppColors.textTertiary;
    }
  }
}

/// Program-specific dashboard content (existing behavior)
class _ProgramDashboardContent extends ConsumerWidget {
  final ProgramDashboard dashboard;

  const _ProgramDashboardContent({required this.dashboard});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedProgram = ref.watch(selectedProgramProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.pagePaddingHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb
          selectedProgram.when(
            data: (program) {
              if (program != null) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Row(
                    children: [
                      Text(
                        'Programs',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs),
                        child: Icon(
                          Icons.chevron_right,
                          size: 16,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      Text(
                        program.name,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs),
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
              final cardWidth =
                  (constraints.maxWidth - AppSpacing.md * 3) / 4;
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
                      value:
                          '${dashboard.avgDecisionTimeHours.toStringAsFixed(1)}h',
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
                  DecisionVelocityChart(
                      metrics: dashboard.decisionVelocity),
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
                  OutcomesProgressPanel(
                      outcomes: dashboard.outcomeProgress),
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
