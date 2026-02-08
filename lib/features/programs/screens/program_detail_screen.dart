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
import '../../../shared/widgets/comments/comment_section.dart';
import '../../../shared/widgets/entity_links/entity_link_section.dart';

class ProgramDetailScreen extends ConsumerStatefulWidget {
  final String id;

  const ProgramDetailScreen({super.key, required this.id});

  @override
  ConsumerState<ProgramDetailScreen> createState() =>
      _ProgramDetailScreenState();
}

class _ProgramDetailScreenState extends ConsumerState<ProgramDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final programAsync = ref.watch(programProvider(widget.id));

    return programAsync.when(
      data: (program) => Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.pagePaddingHorizontal,
              vertical: AppSpacing.sm,
            ),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(
                bottom: BorderSide(color: AppColors.border),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Breadcrumb
                Row(
                  children: [
                    InkWell(
                      onTap: () => context.go(Routes.programs),
                      child: Text(
                        'Programs',
                        style: AppTypography.bodySmall
                            .copyWith(color: AppColors.primary),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs),
                      child: Icon(Icons.chevron_right,
                          size: 16, color: AppColors.textTertiary),
                    ),
                    Expanded(
                      child: Text(
                        program.name,
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                // Title row
                Row(
                  children: [
                    if (program.color != null) ...[
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _parseColor(program.color!),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                    ],
                    Expanded(
                      child: Text(program.name, style: AppTypography.h2),
                    ),
                    // Type badge
                    if (program.type != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xxs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                        child: Text(
                          program.type!.name,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    const SizedBox(width: AppSpacing.xs),
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xxs,
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor(program.status).withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Text(
                        program.status.displayName,
                        style: AppTypography.labelSmall.copyWith(
                          color: _statusColor(program.status),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                // Description
                if (program.description != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    program.description!,
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                // Meta row
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: AppSpacing.lg,
                  children: [
                    if (program.ownerName != null)
                      Text(
                        'Owner: ${program.ownerName}',
                        style: AppTypography.labelSmall
                            .copyWith(color: AppColors.textTertiary),
                      ),
                    if (program.startDate != null)
                      Text(
                        'Start: ${_formatDate(program.startDate!)}',
                        style: AppTypography.labelSmall
                            .copyWith(color: AppColors.textTertiary),
                      ),
                    if (program.targetDate != null)
                      Text(
                        'Target: ${_formatDate(program.targetDate!)}',
                        style: AppTypography.labelSmall
                            .copyWith(color: AppColors.textTertiary),
                      ),
                  ],
                ),

                // Tags
                if (program.tags != null && program.tags!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Wrap(
                    spacing: AppSpacing.xxs,
                    children: program.tags!
                        .map((tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceVariant,
                                borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusSm),
                              ),
                              child: Text(
                                tag,
                                style: AppTypography.labelSmall
                                    .copyWith(fontSize: 10),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),

          // Tabs
          Container(
            color: AppColors.surface,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Workstreams'),
                Tab(text: 'Comments'),
                Tab(text: 'Links'),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _OverviewTab(program: program),
                _WorkstreamsTab(programId: program.id),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(
                      AppSpacing.pagePaddingHorizontal),
                  child: CommentSection(
                    parentType: CommentParentType.PROGRAM,
                    parentId: program.id,
                  ),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(
                      AppSpacing.pagePaddingHorizontal),
                  child: EntityLinkSection(
                    entityType: EntityType.PROGRAM,
                    entityId: program.id,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      loading: () => const LoadingIndicator(message: 'Loading program...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () => ref.invalidate(programProvider(widget.id)),
      ),
    );
  }

  Color _parseColor(String hex) {
    try {
      return Color(
          int.parse('FF${hex.replaceFirst('#', '')}', radix: 16));
    } catch (_) {
      return AppColors.primary;
    }
  }

  Color _statusColor(ProgramStatus status) {
    if (status.isActive) return AppColors.success;
    if (status.isEditable) return AppColors.warning;
    if (status.isTerminal) return AppColors.textTertiary;
    return AppColors.primary;
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

class _OverviewTab extends ConsumerWidget {
  final Program program;

  const _OverviewTab({required this.program});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(programStatsProvider(program.id));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.pagePaddingHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats cards
          statsAsync.when(
            data: (stats) => Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                _StatCard(
                  label: 'Outcomes',
                  value: '${stats.activeOutcomes}/${stats.totalOutcomes}',
                  icon: Icons.flag_outlined,
                  color: AppColors.success,
                ),
                _StatCard(
                  label: 'Hypotheses',
                  value:
                      '${stats.activeHypotheses}/${stats.totalHypotheses}',
                  icon: Icons.lightbulb_outlined,
                  color: AppColors.warning,
                ),
                _StatCard(
                  label: 'Decisions',
                  value:
                      '${stats.pendingDecisions}/${stats.totalDecisions}',
                  icon: Icons.bolt_outlined,
                  color: AppColors.error,
                ),
                _StatCard(
                  label: 'Experiments',
                  value:
                      '${stats.runningExperiments}/${stats.totalExperiments}',
                  icon: Icons.science_outlined,
                  color: AppColors.secondary,
                ),
                _StatCard(
                  label: 'Members',
                  value: '${stats.totalMembers}',
                  icon: Icons.people_outlined,
                  color: AppColors.primary,
                ),
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const SizedBox.shrink(),
          ),

          if (program.portfolioId != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Text('Portfolio', style: AppTypography.h4),
            const SizedBox(height: AppSpacing.xs),
            InkWell(
              onTap: () => GoRouter.of(context)
                  .go(Routes.portfolioById(program.portfolioId!)),
              child: Text(
                'View Portfolio',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.primary),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTypography.h3.copyWith(color: color),
          ),
          Text(
            label,
            style: AppTypography.labelSmall
                .copyWith(color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }
}

class _WorkstreamsTab extends ConsumerWidget {
  final String programId;

  const _WorkstreamsTab({required this.programId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workstreamsAsync = ref.watch(programWorkstreamsProvider(programId));

    return workstreamsAsync.when(
      data: (workstreams) {
        if (workstreams.isEmpty) {
          return Center(
            child: Text(
              'No workstreams yet',
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.pagePaddingHorizontal),
          itemCount: workstreams.length,
          separatorBuilder: (_, __) =>
              const SizedBox(height: AppSpacing.xs),
          itemBuilder: (_, index) {
            final ws = workstreams[index];
            return Card(
              child: ListTile(
                leading: Icon(Icons.account_tree_outlined,
                    color: AppColors.primary),
                title: Text(ws.name, style: AppTypography.labelLarge),
                subtitle: ws.description != null
                    ? Text(
                        ws.description!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySmall,
                      )
                    : null,
                trailing: const Icon(Icons.chevron_right),
                onTap: () =>
                    context.go(Routes.workstreamById(ws.id)),
              ),
            );
          },
        );
      },
      loading: () =>
          const LoadingIndicator(message: 'Loading workstreams...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () =>
            ref.invalidate(programWorkstreamsProvider(programId)),
      ),
    );
  }
}
