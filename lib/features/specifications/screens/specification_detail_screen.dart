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
import '../widgets/specification_status_badge.dart';
import '../providers/specifications_providers.dart';
import '../../requirements/widgets/requirement_card.dart';
import '../../requirements/widgets/create_requirement_dialog.dart';

class SpecificationDetailScreen extends ConsumerStatefulWidget {
  final String id;

  const SpecificationDetailScreen({super.key, required this.id});

  @override
  ConsumerState<SpecificationDetailScreen> createState() =>
      _SpecificationDetailScreenState();
}

class _SpecificationDetailScreenState
    extends ConsumerState<SpecificationDetailScreen>
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
    final specAsync = ref.watch(specificationProvider(widget.id));

    return specAsync.when(
      data: (spec) => _DetailContent(
        specification: spec,
        tabController: _tabController,
      ),
      loading: () =>
          const LoadingIndicator(message: 'Loading specification...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () =>
            ref.invalidate(specificationProvider(widget.id)),
      ),
    );
  }
}

class _DetailContent extends ConsumerWidget {
  final Specification specification;
  final TabController tabController;

  const _DetailContent({
    required this.specification,
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
                    onTap: () => context.go(Routes.workstreamById(
                        specification.workstreamId)),
                    child: Text(
                      specification.workstreamName ?? 'Workstream',
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
                    specification.name,
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
                            Flexible(
                              child: Text(specification.name,
                                  style: AppTypography.h2),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            SpecificationStatusBadge(
                                status: specification.status),
                          ],
                        ),
                        if (specification.description != null) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            specification.description!,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Workflow actions
                  _WorkflowActions(specification: specification),
                ],
              ),

              // Meta row
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.lg,
                children: [
                  if (specification.authorName != null)
                    _MetaItem(
                      icon: Icons.edit_outlined,
                      label: 'Author: ${specification.authorName!}',
                    ),
                  if (specification.reviewerName != null)
                    _MetaItem(
                      icon: Icons.rate_review_outlined,
                      label: 'Reviewer: ${specification.reviewerName!}',
                    ),
                  _MetaItem(
                    icon: Icons.tag,
                    label: 'v${specification.version}',
                  ),
                  if (specification.estimatedHours != null)
                    _MetaItem(
                      icon: Icons.schedule_outlined,
                      label:
                          '${specification.estimatedHours!.toStringAsFixed(0)}h estimated',
                    ),
                  if (specification.actualHours != null)
                    _MetaItem(
                      icon: Icons.timer_outlined,
                      label:
                          '${specification.actualHours!.toStringAsFixed(0)}h actual',
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
              Tab(text: 'Requirements'),
              Tab(text: 'Overview'),
            ],
          ),
        ),

        // Tab content
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              _RequirementsTab(specificationId: specification.id),
              _OverviewTab(specification: specification),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textTertiary),
        const SizedBox(width: AppSpacing.xxs),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// Workflow action buttons based on current status
class _WorkflowActions extends ConsumerWidget {
  final Specification specification;

  const _WorkflowActions({required this.specification});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workflowState = ref.watch(specificationWorkflowActionProvider);
    final isLoading = workflowState.isLoading;

    Widget? actionButton;
    switch (specification.status) {
      case SpecificationStatus.DRAFT:
        actionButton = FilledButton(
          onPressed: isLoading
              ? null
              : () => ref
                  .read(specificationWorkflowActionProvider.notifier)
                  .submitForReview(specification.id),
          child: const Text('Submit for Review'),
        );
        break;
      case SpecificationStatus.IN_REVIEW:
        actionButton = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton(
              onPressed: isLoading
                  ? null
                  : () => ref
                      .read(specificationWorkflowActionProvider.notifier)
                      .approve(specification.id),
              child: const Text('Approve'),
            ),
            const SizedBox(width: AppSpacing.xs),
            OutlinedButton(
              onPressed: isLoading
                  ? null
                  : () => ref
                      .read(specificationWorkflowActionProvider.notifier)
                      .reject(specification.id),
              child: const Text('Reject'),
            ),
          ],
        );
        break;
      case SpecificationStatus.APPROVED:
        actionButton = FilledButton(
          onPressed: isLoading
              ? null
              : () => ref
                  .read(specificationWorkflowActionProvider.notifier)
                  .startWork(specification.id),
          child: const Text('Start Work'),
        );
        break;
      case SpecificationStatus.IN_PROGRESS:
        actionButton = FilledButton(
          onPressed: isLoading
              ? null
              : () => ref
                  .read(specificationWorkflowActionProvider.notifier)
                  .markDelivered(specification.id),
          child: const Text('Mark Delivered'),
        );
        break;
      case SpecificationStatus.DELIVERED:
        actionButton = FilledButton(
          onPressed: isLoading
              ? null
              : () => ref
                  .read(specificationWorkflowActionProvider.notifier)
                  .markAccepted(specification.id),
          child: const Text('Accept'),
        );
        break;
      case SpecificationStatus.ACCEPTED:
        actionButton = null;
        break;
    }

    if (actionButton == null) return const SizedBox.shrink();

    return actionButton;
  }
}

/// Requirements tab — list of requirements in this specification
class _RequirementsTab extends ConsumerWidget {
  final String specificationId;

  const _RequirementsTab({required this.specificationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reqsAsync =
        ref.watch(specificationRequirementsProvider(specificationId));

    return reqsAsync.when(
      data: (reqs) {
        if (reqs.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.checklist_outlined,
                    size: 48, color: AppColors.textTertiary),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'No requirements yet',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                FilledButton.icon(
                  onPressed: () => _showCreateDialog(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Create Requirement'),
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
                    label: const Text('New Requirement'),
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
                itemCount: reqs.length,
                itemBuilder: (context, index) =>
                    RequirementCard(requirement: reqs[index]),
              ),
            ),
          ],
        );
      },
      loading: () =>
          const LoadingIndicator(message: 'Loading requirements...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () => ref.invalidate(
            specificationRequirementsProvider(specificationId)),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          CreateRequirementDialog(specificationId: specificationId),
    );
  }
}

/// Overview tab — specification metadata
class _OverviewTab extends StatelessWidget {
  final Specification specification;

  const _OverviewTab({required this.specification});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.pagePaddingHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Workflow progress
          Text('Workflow Progress', style: AppTypography.h3),
          const SizedBox(height: AppSpacing.md),
          _WorkflowProgress(currentStatus: specification.status),

          const SizedBox(height: AppSpacing.lg),

          Text('Details', style: AppTypography.h3),
          const SizedBox(height: AppSpacing.md),
          _DetailRow(label: 'Status', value: specification.status.name),
          _DetailRow(
              label: 'Version', value: 'v${specification.version}'),
          if (specification.authorName != null)
            _DetailRow(
                label: 'Author', value: specification.authorName!),
          if (specification.reviewerName != null)
            _DetailRow(
                label: 'Reviewer', value: specification.reviewerName!),
          if (specification.workstreamName != null)
            _DetailRow(
                label: 'Workstream',
                value: specification.workstreamName!),
          if (specification.programName != null)
            _DetailRow(
                label: 'Program', value: specification.programName!),
          if (specification.estimatedHours != null)
            _DetailRow(
              label: 'Estimated Hours',
              value:
                  '${specification.estimatedHours!.toStringAsFixed(1)}h',
            ),
          if (specification.actualHours != null)
            _DetailRow(
              label: 'Actual Hours',
              value:
                  '${specification.actualHours!.toStringAsFixed(1)}h',
            ),
          if (specification.approvedByName != null)
            _DetailRow(
                label: 'Approved By',
                value: specification.approvedByName!),
          if (specification.approvedAt != null)
            _DetailRow(
              label: 'Approved At',
              value: _formatDate(specification.approvedAt!),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

class _WorkflowProgress extends StatelessWidget {
  final SpecificationStatus currentStatus;

  const _WorkflowProgress({required this.currentStatus});

  @override
  Widget build(BuildContext context) {
    final steps = SpecificationStatus.values;
    final currentIndex = steps.indexOf(currentStatus);

    return Row(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isCompleted = index < currentIndex;
        final isCurrent = index == currentIndex;

        return Expanded(
          child: Row(
            children: [
              if (index > 0)
                Expanded(
                  child: Container(
                    height: 2,
                    color: isCompleted
                        ? AppColors.primary
                        : AppColors.border,
                  ),
                ),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.primary
                      : isCurrent
                          ? AppColors.primary.withOpacity(0.15)
                          : AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isCompleted || isCurrent
                        ? AppColors.primary
                        : AppColors.border,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check,
                          size: 14, color: Colors.white)
                      : Text(
                          '${index + 1}',
                          style: AppTypography.labelSmall.copyWith(
                            color: isCurrent
                                ? AppColors.primary
                                : AppColors.textTertiary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              if (index < steps.length - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    color: isCompleted
                        ? AppColors.primary
                        : AppColors.border,
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
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
