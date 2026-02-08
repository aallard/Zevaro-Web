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
import '../widgets/ticket_type_badge.dart';
import '../widgets/ticket_severity_badge.dart';
import '../widgets/ticket_status_badge.dart';
import '../widgets/triage_ticket_dialog.dart';
import '../widgets/resolve_ticket_dialog.dart';
import '../providers/tickets_providers.dart';

class TicketDetailScreen extends ConsumerWidget {
  final String id;

  const TicketDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketAsync = ref.watch(ticketProvider(id));

    return ticketAsync.when(
      data: (ticket) => _DetailContent(ticket: ticket),
      loading: () =>
          const LoadingIndicator(message: 'Loading ticket...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () => ref.invalidate(ticketProvider(id)),
      ),
    );
  }
}

class _DetailContent extends ConsumerWidget {
  final Ticket ticket;

  const _DetailContent({required this.ticket});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding:
                const EdgeInsets.all(AppSpacing.pagePaddingHorizontal),
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
                      onTap: () => context.go(Routes.workstreamById(
                          ticket.workstreamId)),
                      child: Text(
                        ticket.workstreamName ?? 'Workstream',
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
                      ticket.identifier,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Identifier + title
                Row(
                  children: [
                    Text(
                      ticket.identifier,
                      style: AppTypography.h3.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(ticket.title,
                          style: AppTypography.h2),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                // Badges
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    TicketTypeBadge(type: ticket.type),
                    if (ticket.severity != null)
                      TicketSeverityBadge(
                          severity: ticket.severity!),
                    TicketStatusBadge(status: ticket.status),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Workflow actions
                _WorkflowActions(ticket: ticket),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(
                AppSpacing.pagePaddingHorizontal),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 800;
                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 2,
                          child: _LeftColumn(ticket: ticket)),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                          flex: 1,
                          child: _RightColumn(ticket: ticket)),
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LeftColumn(ticket: ticket),
                    const SizedBox(height: AppSpacing.lg),
                    _RightColumn(ticket: ticket),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LeftColumn extends StatelessWidget {
  final Ticket ticket;

  const _LeftColumn({required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Description
        if (ticket.description != null) ...[
          Text('Description', style: AppTypography.h3),
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius:
                  BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(ticket.description!,
                style: AppTypography.bodyMedium),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],

        // Bug fields
        if (ticket.type == TicketType.BUG) ...[
          if (ticket.stepsToReproduce != null) ...[
            Text('Steps to Reproduce', style: AppTypography.h3),
            const SizedBox(height: AppSpacing.sm),
            _ContentBox(content: ticket.stepsToReproduce!),
            const SizedBox(height: AppSpacing.lg),
          ],
          if (ticket.expectedBehavior != null) ...[
            Text('Expected Behavior', style: AppTypography.h3),
            const SizedBox(height: AppSpacing.sm),
            _ContentBox(content: ticket.expectedBehavior!),
            const SizedBox(height: AppSpacing.lg),
          ],
          if (ticket.actualBehavior != null) ...[
            Text('Actual Behavior', style: AppTypography.h3),
            const SizedBox(height: AppSpacing.sm),
            _ContentBox(content: ticket.actualBehavior!),
            const SizedBox(height: AppSpacing.lg),
          ],
        ],

        // Resolution info
        if (ticket.resolution != null) ...[
          Text('Resolution', style: AppTypography.h3),
          const SizedBox(height: AppSpacing.sm),
          _ContentBox(content: ticket.resolution!.name),
          const SizedBox(height: AppSpacing.lg),
        ],
      ],
    );
  }
}

class _RightColumn extends StatelessWidget {
  final Ticket ticket;

  const _RightColumn({required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Details', style: AppTypography.h4),
          const SizedBox(height: AppSpacing.md),
          _DetailRow(
              label: 'Reporter',
              value: ticket.reportedByName ?? 'Unknown'),
          if (ticket.assignedToName != null)
            _DetailRow(
                label: 'Assignee', value: ticket.assignedToName!),
          _DetailRow(label: 'Source', value: ticket.source.name),
          if (ticket.externalRef != null)
            _DetailRow(
                label: 'External Ref', value: ticket.externalRef!),
          if (ticket.environment != null)
            _DetailRow(
                label: 'Environment', value: ticket.environment!),
          if (ticket.estimatedHours != null)
            _DetailRow(
              label: 'Estimated',
              value:
                  '${ticket.estimatedHours!.toStringAsFixed(1)}h',
            ),
          if (ticket.actualHours != null)
            _DetailRow(
              label: 'Actual',
              value: '${ticket.actualHours!.toStringAsFixed(1)}h',
            ),
          if (ticket.resolvedAt != null)
            _DetailRow(
              label: 'Resolved',
              value: _formatDate(ticket.resolvedAt!),
            ),
          if (ticket.closedAt != null)
            _DetailRow(
              label: 'Closed',
              value: _formatDate(ticket.closedAt!),
            ),
          if (ticket.createdAt != null)
            _DetailRow(
              label: 'Created',
              value: _formatDate(ticket.createdAt!),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

class _ContentBox extends StatelessWidget {
  final String content;

  const _ContentBox({required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(content, style: AppTypography.bodyMedium),
    );
  }
}

/// Workflow action buttons based on ticket status
class _WorkflowActions extends ConsumerWidget {
  final Ticket ticket;

  const _WorkflowActions({required this.ticket});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workflowState = ref.watch(ticketWorkflowActionProvider);
    final isLoading = workflowState.isLoading;

    final actions = <Widget>[];

    switch (ticket.status) {
      case TicketStatus.NEW:
        actions.add(FilledButton(
          onPressed: isLoading
              ? null
              : () => showDialog(
                    context: context,
                    builder: (_) =>
                        TriageTicketDialog(ticketId: ticket.id),
                  ),
          child: const Text('Triage'),
        ));
        break;
      case TicketStatus.TRIAGED:
        actions.add(FilledButton(
          onPressed: isLoading
              ? null
              : () => ref
                  .read(ticketWorkflowActionProvider.notifier)
                  .startWork(ticket.id),
          child: const Text('Start Work'),
        ));
        break;
      case TicketStatus.IN_PROGRESS:
        actions.add(FilledButton(
          onPressed: isLoading
              ? null
              : () => ref
                  .read(ticketWorkflowActionProvider.notifier)
                  .submitForReview(ticket.id),
          child: const Text('Submit for Review'),
        ));
        break;
      case TicketStatus.IN_REVIEW:
        actions.add(FilledButton(
          onPressed: isLoading
              ? null
              : () => showDialog(
                    context: context,
                    builder: (_) =>
                        ResolveTicketDialog(ticketId: ticket.id),
                  ),
          child: const Text('Resolve'),
        ));
        break;
      case TicketStatus.RESOLVED:
        actions.add(FilledButton(
          onPressed: isLoading
              ? null
              : () => ref
                  .read(ticketWorkflowActionProvider.notifier)
                  .close(ticket.id),
          child: const Text('Close'),
        ));
        break;
      case TicketStatus.CLOSED:
      case TicketStatus.WONT_FIX:
        break;
    }

    // Won't Fix available for any open status
    if (ticket.status != TicketStatus.CLOSED &&
        ticket.status != TicketStatus.WONT_FIX &&
        ticket.status != TicketStatus.RESOLVED) {
      actions.add(OutlinedButton(
        onPressed: isLoading
            ? null
            : () => ref
                .read(ticketWorkflowActionProvider.notifier)
                .wontFix(ticket.id),
        child: const Text("Won't Fix"),
      ));
    }

    if (actions.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: AppSpacing.xs,
      children: actions,
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
            width: 100,
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: AppTypography.bodyMedium),
          ),
        ],
      ),
    );
  }
}
