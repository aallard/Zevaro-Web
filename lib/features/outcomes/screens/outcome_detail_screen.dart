import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/common/loading_indicator.dart';
import '../../../shared/widgets/common/error_view.dart';
import '../providers/outcomes_providers.dart';
import '../widgets/outcome_status_badge.dart';
import '../widgets/outcome_key_results.dart';

class OutcomeDetailScreen extends ConsumerWidget {
  final String id;

  const OutcomeDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outcomeAsync = ref.watch(outcomeDetailProvider(id));
    final hypothesesAsync = ref.watch(outcomeHypothesesProvider(id));
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > AppConstants.tabletBreakpoint;

    return outcomeAsync.when(
      data: (outcome) => SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            TextButton.icon(
              onPressed: () => context.go(Routes.outcomes),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('Back to Outcomes'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                padding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Header card
            _OutcomeHeader(outcome: outcome, ref: ref),
            const SizedBox(height: AppSpacing.lg),

            // Content
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        OutcomeKeyResults(outcome: outcome),
                        const SizedBox(height: AppSpacing.lg),
                        _OutcomeHypotheses(hypothesesAsync: hypothesesAsync),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: _OutcomeMetadata(outcome: outcome),
                  ),
                ],
              )
            else ...[
              OutcomeKeyResults(outcome: outcome),
              const SizedBox(height: AppSpacing.lg),
              _OutcomeMetadata(outcome: outcome),
              const SizedBox(height: AppSpacing.lg),
              _OutcomeHypotheses(hypothesesAsync: hypothesesAsync),
            ],

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
      loading: () => const LoadingIndicator(message: 'Loading outcome...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () => ref.invalidate(outcomeDetailProvider(id)),
      ),
    );
  }
}

class _OutcomeHeader extends StatelessWidget {
  final Outcome outcome;
  final WidgetRef ref;

  const _OutcomeHeader({required this.outcome, required this.ref});

  @override
  Widget build(BuildContext context) {
    final priorityColor =
        Color(int.parse(outcome.priority.color.replaceFirst('#', '0xFF')));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                OutcomeStatusBadge(status: outcome.status),
                const SizedBox(width: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: Text(
                    outcome.priority.displayName,
                    style:
                        AppTypography.labelMedium.copyWith(color: priorityColor),
                  ),
                ),
                const Spacer(),
                if (outcome.status.isEditable)
                  PopupMenuButton<OutcomeStatus>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (newStatus) {
                      ref
                          .read(updateOutcomeStatusProvider.notifier)
                          .updateStatus(outcome.id, newStatus);
                    },
                    itemBuilder: (context) => OutcomeStatus.values
                        .where((s) => s != outcome.status)
                        .map((s) => PopupMenuItem(
                              value: s,
                              child: Text('Mark as ${s.displayName}'),
                            ))
                        .toList(),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(outcome.title, style: AppTypography.h2),
            if (outcome.description?.isNotEmpty ?? false) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                outcome.description!,
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _OutcomeMetadata extends StatelessWidget {
  final Outcome outcome;

  const _OutcomeMetadata({required this.outcome});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Details', style: AppTypography.h4),
            const SizedBox(height: AppSpacing.md),
            _MetadataRow(
                icon: Icons.calendar_today_outlined,
                label: 'Created',
                value: _formatDate(outcome.createdAt)),
            const SizedBox(height: AppSpacing.sm),
            _MetadataRow(
                icon: Icons.update_outlined,
                label: 'Updated',
                value: _formatDate(outcome.updatedAt)),
            if (outcome.targetDate != null) ...[
              const SizedBox(height: AppSpacing.sm),
              _MetadataRow(
                  icon: Icons.flag_outlined,
                  label: 'Target',
                  value: _formatDate(outcome.targetDate!)),
            ],
            if (outcome.teamName != null) ...[
              const SizedBox(height: AppSpacing.sm),
              _MetadataRow(
                  icon: Icons.group_outlined,
                  label: 'Team',
                  value: outcome.teamName!),
            ],
            if (outcome.ownerName != null) ...[
              const SizedBox(height: AppSpacing.sm),
              _MetadataRow(
                  icon: Icons.person_outlined,
                  label: 'Owner',
                  value: outcome.ownerName!),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _MetadataRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetadataRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textTertiary),
        const SizedBox(width: AppSpacing.sm),
        Text(label,
            style: AppTypography.bodySmall
                .copyWith(color: AppColors.textSecondary)),
        const Spacer(),
        Text(value, style: AppTypography.bodySmall),
      ],
    );
  }
}

class _OutcomeHypotheses extends StatelessWidget {
  final AsyncValue<List<Hypothesis>> hypothesesAsync;

  const _OutcomeHypotheses({required this.hypothesesAsync});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Hypotheses', style: AppTypography.h4),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    // TODO: Create hypothesis for this outcome
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            hypothesesAsync.when(
              data: (hypotheses) {
                if (hypotheses.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        children: [
                          Icon(Icons.science_outlined,
                              size: 32, color: AppColors.textTertiary),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'No hypotheses yet',
                            style: AppTypography.bodyMedium
                                .copyWith(color: AppColors.textTertiary),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: hypotheses.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final h = hypotheses[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(h.statement, style: AppTypography.labelMedium),
                      subtitle: Text(h.status.displayName),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.go(Routes.hypothesisById(h.id)),
                    );
                  },
                );
              },
              loading: () => const LoadingIndicator(),
              error: (e, _) => Text('Error: $e'),
            ),
          ],
        ),
      ),
    );
  }
}
