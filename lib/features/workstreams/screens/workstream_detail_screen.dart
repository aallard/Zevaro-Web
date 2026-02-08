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
import '../widgets/workstream_status_badge.dart';
import '../widgets/workstream_mode_badge.dart';
import '../../specifications/widgets/specification_card.dart';
import '../../specifications/widgets/create_specification_dialog.dart';
import '../../tickets/widgets/ticket_card.dart';
import '../../tickets/widgets/create_ticket_dialog.dart';

class WorkstreamDetailScreen extends ConsumerStatefulWidget {
  final String id;

  const WorkstreamDetailScreen({super.key, required this.id});

  @override
  ConsumerState<WorkstreamDetailScreen> createState() =>
      _WorkstreamDetailScreenState();
}

class _WorkstreamDetailScreenState
    extends ConsumerState<WorkstreamDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workstreamAsync = ref.watch(workstreamProvider(widget.id));

    return workstreamAsync.when(
      data: (workstream) => _DetailContent(
        workstream: workstream,
        tabController: _tabController,
      ),
      loading: () =>
          const LoadingIndicator(message: 'Loading workstream...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () => ref.invalidate(workstreamProvider(widget.id)),
      ),
    );
  }
}

class _DetailContent extends ConsumerWidget {
  final Workstream workstream;
  final TabController tabController;

  const _DetailContent({
    required this.workstream,
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
                    onTap: () => context.go(Routes.workstreams),
                    child: Text(
                      'Workstreams',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs),
                    child: Icon(Icons.chevron_right,
                        size: 16, color: AppColors.textTertiary),
                  ),
                  Text(
                    workstream.name,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Title + status + mode + actions
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(workstream.name,
                                  style: AppTypography.h2),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            WorkstreamStatusBadge(
                                status: workstream.status),
                            const SizedBox(width: AppSpacing.xs),
                            WorkstreamModeBadge(mode: workstream.mode),
                          ],
                        ),
                        if (workstream.description != null) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            workstream.description!,
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
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outlined, size: 16),
                            SizedBox(width: AppSpacing.xs),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {},
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
              ),

              // Meta row
              if (workstream.ownerName != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Icon(Icons.person_outline,
                        size: 16, color: AppColors.textTertiary),
                    const SizedBox(width: AppSpacing.xxs),
                    Text(
                      workstream.ownerName!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
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
              Tab(text: 'Specifications'),
              Tab(text: 'Tickets'),
              Tab(text: 'Overview'),
            ],
          ),
        ),

        // Tab content
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              _SpecificationsTab(workstreamId: workstream.id),
              _TicketsTab(workstreamId: workstream.id),
              _OverviewTab(workstream: workstream),
            ],
          ),
        ),
      ],
    );
  }
}

/// Specifications tab — list of specs in this workstream
class _SpecificationsTab extends ConsumerWidget {
  final String workstreamId;

  const _SpecificationsTab({required this.workstreamId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final specsAsync =
        ref.watch(workstreamSpecificationsProvider(workstreamId));

    return specsAsync.when(
      data: (specs) {
        if (specs.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.description_outlined,
                    size: 48, color: AppColors.textTertiary),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'No specifications yet',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                FilledButton.icon(
                  onPressed: () => _showCreateDialog(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Create Specification'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Action bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.pagePaddingHorizontal,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilledButton.icon(
                    onPressed: () => _showCreateDialog(context),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('New Specification'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.sidebarAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 1200
                      ? 3
                      : constraints.maxWidth > 800
                          ? 2
                          : 1;

                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.pagePaddingHorizontal,
                    ),
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: AppSpacing.md,
                      mainAxisSpacing: AppSpacing.md,
                      childAspectRatio: 2.0,
                    ),
                    itemCount: specs.length,
                    itemBuilder: (context, index) =>
                        SpecificationCard(specification: specs[index]),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () =>
          const LoadingIndicator(message: 'Loading specifications...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () => ref
            .invalidate(workstreamSpecificationsProvider(workstreamId)),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          CreateSpecificationDialog(workstreamId: workstreamId),
    );
  }
}

/// Tickets tab — list of tickets in this workstream
class _TicketsTab extends ConsumerWidget {
  final String workstreamId;

  const _TicketsTab({required this.workstreamId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketsAsync =
        ref.watch(workstreamTicketsProvider(workstreamId));

    return ticketsAsync.when(
      data: (tickets) {
        if (tickets.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bug_report_outlined,
                    size: 48, color: AppColors.textTertiary),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'No tickets yet',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                FilledButton.icon(
                  onPressed: () => _showCreateDialog(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Create Ticket'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Action bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.pagePaddingHorizontal,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilledButton.icon(
                    onPressed: () => _showCreateDialog(context),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('New Ticket'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.sidebarAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pagePaddingHorizontal,
                ),
                itemCount: tickets.length,
                itemBuilder: (context, index) =>
                    TicketCard(ticket: tickets[index]),
              ),
            ),
          ],
        );
      },
      loading: () =>
          const LoadingIndicator(message: 'Loading tickets...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () => ref
            .invalidate(workstreamTicketsProvider(workstreamId)),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          CreateTicketDialog(workstreamId: workstreamId),
    );
  }
}

/// Overview tab — workstream metadata
class _OverviewTab extends StatelessWidget {
  final Workstream workstream;

  const _OverviewTab({required this.workstream});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.pagePaddingHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Details', style: AppTypography.h3),
          const SizedBox(height: AppSpacing.md),
          _DetailRow(label: 'Mode', value: workstream.mode.name),
          _DetailRow(
              label: 'Execution Mode',
              value: workstream.executionMode.name),
          _DetailRow(label: 'Status', value: workstream.status.name),
          if (workstream.ownerName != null)
            _DetailRow(label: 'Owner', value: workstream.ownerName!),
          if (workstream.programName != null)
            _DetailRow(label: 'Program', value: workstream.programName!),
          if (workstream.tags != null && workstream.tags!.isNotEmpty)
            _DetailRow(
                label: 'Tags', value: workstream.tags!.join(', ')),
          if (workstream.createdAt != null)
            _DetailRow(
              label: 'Created',
              value: _formatDate(workstream.createdAt!),
            ),
          if (workstream.updatedAt != null)
            _DetailRow(
              label: 'Updated',
              value: _formatDate(workstream.updatedAt!),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
