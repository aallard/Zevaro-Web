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
import '../widgets/portfolio_status_badge.dart';
import '../../programs/widgets/program_card.dart';

class PortfolioDetailScreen extends ConsumerStatefulWidget {
  final String id;

  const PortfolioDetailScreen({super.key, required this.id});

  @override
  ConsumerState<PortfolioDetailScreen> createState() =>
      _PortfolioDetailScreenState();
}

class _PortfolioDetailScreenState
    extends ConsumerState<PortfolioDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final portfolioAsync = ref.watch(portfolioProvider(widget.id));

    return portfolioAsync.when(
      data: (portfolio) => _DetailContent(
        portfolio: portfolio,
        tabController: _tabController,
      ),
      loading: () =>
          const LoadingIndicator(message: 'Loading portfolio...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () => ref.invalidate(portfolioProvider(widget.id)),
      ),
    );
  }
}

class _DetailContent extends ConsumerWidget {
  final Portfolio portfolio;
  final TabController tabController;

  const _DetailContent({
    required this.portfolio,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(AppSpacing.pagePaddingHorizontal),
          decoration: const BoxDecoration(
            color: AppColors.surface,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumb
              Row(
                children: [
                  InkWell(
                    onTap: () => context.go(Routes.portfolios),
                    child: Text(
                      'Portfolios',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                    child: Icon(Icons.chevron_right,
                        size: 16, color: AppColors.textTertiary),
                  ),
                  Text(
                    portfolio.name,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Title + status + actions
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(portfolio.name, style: AppTypography.h2),
                            const SizedBox(width: AppSpacing.sm),
                            PortfolioStatusBadge(status: portfolio.status),
                          ],
                        ),
                        if (portfolio.description != null) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            portfolio.description!,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 16),
                            SizedBox(width: AppSpacing.xs),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'archive',
                        child: Row(
                          children: [
                            Icon(Icons.archive_outlined, size: 16),
                            SizedBox(width: AppSpacing.xs),
                            Text('Archive'),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {},
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Tabs
        Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(
              bottom: BorderSide(color: AppColors.border),
            ),
          ),
          child: TabBar(
            controller: tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            tabs: const [
              Tab(text: 'Programs'),
              Tab(text: 'Dashboard'),
            ],
          ),
        ),

        // Tab content
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              _ProgramsTab(portfolioId: portfolio.id),
              _DashboardTab(portfolioId: portfolio.id),
            ],
          ),
        ),
      ],
    );
  }
}

/// Programs tab — list of programs in this portfolio
class _ProgramsTab extends ConsumerWidget {
  final String portfolioId;

  const _ProgramsTab({required this.portfolioId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programsAsync = ref.watch(portfolioProgramsProvider(portfolioId));

    return programsAsync.when(
      data: (programs) {
        if (programs.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.folder_outlined,
                    size: 48, color: AppColors.textTertiary),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'No programs in this portfolio',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 1200
                ? 3
                : constraints.maxWidth > 800
                    ? 2
                    : 1;

            return GridView.builder(
              padding: const EdgeInsets.all(AppSpacing.pagePaddingHorizontal),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                childAspectRatio: 1.6,
              ),
              itemCount: programs.length,
              itemBuilder: (context, index) =>
                  ProgramCard(program: programs[index]),
            );
          },
        );
      },
      loading: () =>
          const LoadingIndicator(message: 'Loading programs...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () =>
            ref.invalidate(portfolioProgramsProvider(portfolioId)),
      ),
    );
  }
}

/// Dashboard tab — program health grid
class _DashboardTab extends ConsumerWidget {
  final String portfolioId;

  const _DashboardTab({required this.portfolioId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync =
        ref.watch(portfolioDashboardProvider(portfolioId));

    return dashboardAsync.when(
      data: (dashboard) => SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pagePaddingHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary metrics
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                _MetricTile(
                  label: 'Total Programs',
                  value: '${dashboard.totalPrograms}',
                  color: AppColors.primary,
                ),
                _MetricTile(
                  label: 'Active Programs',
                  value: '${dashboard.activePrograms}',
                  color: AppColors.success,
                ),
                _MetricTile(
                  label: 'Pending Decisions',
                  value: '${dashboard.totalDecisionsPending}',
                  color: AppColors.warning,
                ),
                _MetricTile(
                  label: 'Breached SLA',
                  value: '${dashboard.totalDecisionsBreached}',
                  color: dashboard.totalDecisionsBreached > 0
                      ? AppColors.error
                      : AppColors.textTertiary,
                ),
                if (dashboard.avgDecisionCycleTimeHours != null)
                  _MetricTile(
                    label: 'Avg Decision Time',
                    value:
                        '${dashboard.avgDecisionCycleTimeHours!.toStringAsFixed(1)}h',
                    color: AppColors.secondary,
                  ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // Program health grid
            Text('Program Health', style: AppTypography.h3),
            const SizedBox(height: AppSpacing.md),

            if (dashboard.programs.isEmpty)
              Text(
                'No programs to display.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              )
            else
              ...dashboard.programs.map(
                (summary) => _ProgramHealthRow(summary: summary),
              ),

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
      loading: () =>
          const LoadingIndicator(message: 'Loading dashboard...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () =>
            ref.invalidate(portfolioDashboardProvider(portfolioId)),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricTile({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: AppTypography.h2.copyWith(color: color),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgramHealthRow extends StatelessWidget {
  final ProgramHealthSummary summary;

  const _ProgramHealthRow({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Health indicator dot
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: _healthColor(summary.healthIndicator),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Program name
          Expanded(
            flex: 3,
            child: Text(
              summary.programName,
              style: AppTypography.labelLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Status
          SizedBox(
            width: 100,
            child: Text(
              summary.status.displayName,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),

          // Pending decisions
          SizedBox(
            width: 120,
            child: Row(
              children: [
                Text(
                  '${summary.pendingDecisions}',
                  style: AppTypography.bodyMedium,
                ),
                const SizedBox(width: AppSpacing.xxs),
                Text(
                  'pending',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),

          // Breached decisions
          SizedBox(
            width: 120,
            child: Row(
              children: [
                Text(
                  '${summary.breachedDecisions}',
                  style: AppTypography.bodyMedium.copyWith(
                    color: summary.breachedDecisions > 0
                        ? AppColors.error
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: AppSpacing.xxs),
                Text(
                  'breached',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _healthColor(String indicator) {
    switch (indicator.toUpperCase()) {
      case 'GREEN':
        return AppColors.success;
      case 'YELLOW':
        return AppColors.warning;
      case 'RED':
        return AppColors.error;
      default:
        return AppColors.textTertiary;
    }
  }
}
