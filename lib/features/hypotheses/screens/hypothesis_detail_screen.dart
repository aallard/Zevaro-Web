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
import '../providers/hypotheses_providers.dart';
import '../widgets/hypothesis_status_badge.dart';
import '../widgets/hypothesis_effort_impact.dart';
import '../widgets/hypothesis_blocking.dart';
import '../widgets/hypothesis_workflow.dart';

class HypothesisDetailScreen extends ConsumerWidget {
  final String id;

  const HypothesisDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hypothesisAsync = ref.watch(hypothesisDetailProvider(id));
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > AppConstants.tabletBreakpoint;

    return hypothesisAsync.when(
      data: (hypothesis) => SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            TextButton.icon(
              onPressed: () => context.go(Routes.hypotheses),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('Back to Hypotheses'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                padding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Blocking alert
            HypothesisBlockingAlert(hypothesis: hypothesis),
            if (hypothesis.status == HypothesisStatus.BLOCKED)
              const SizedBox(height: AppSpacing.md),

            // Header card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        HypothesisStatusBadge(status: hypothesis.status),
                        const Spacer(),
                        if (hypothesis.outcomeId != null)
                          TextButton.icon(
                            onPressed: () =>
                                context.go(Routes.outcomeById(hypothesis.outcomeId!)),
                            icon: const Icon(Icons.flag_outlined, size: 16),
                            label: const Text('View Outcome'),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(hypothesis.statement, style: AppTypography.h2),
                    if (hypothesis.description?.isNotEmpty ?? false) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        hypothesis.description!,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    HypothesisEffortImpact(hypothesis: hypothesis),
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
                    flex: 2,
                    child: HypothesisWorkflow(hypothesis: hypothesis),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: _buildMetadataCard(hypothesis),
                  ),
                ],
              )
            else ...[
              HypothesisWorkflow(hypothesis: hypothesis),
              const SizedBox(height: AppSpacing.lg),
              _buildMetadataCard(hypothesis),
            ],
          ],
        ),
      ),
      loading: () => const LoadingIndicator(message: 'Loading hypothesis...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () => ref.invalidate(hypothesisDetailProvider(id)),
      ),
    );
  }

  Widget _buildMetadataCard(Hypothesis hypothesis) {
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
              value: _formatDate(hypothesis.createdAt),
            ),
            const SizedBox(height: AppSpacing.sm),
            _MetadataRow(
              icon: Icons.timer_outlined,
              label: 'Time in Status',
              value: _formatDuration(hypothesis.timeInStatus),
            ),
            const SizedBox(height: AppSpacing.sm),
            _MetadataRow(
              icon: Icons.psychology_outlined,
              label: 'Confidence',
              value: hypothesis.confidence.displayName,
            ),
            if (hypothesis.validatedAt != null) ...[
              const SizedBox(height: AppSpacing.sm),
              _MetadataRow(
                icon: Icons.verified,
                label: 'Validated',
                value: _formatDate(hypothesis.validatedAt!),
              ),
            ],
            if (hypothesis.invalidatedAt != null) ...[
              const SizedBox(height: AppSpacing.sm),
              _MetadataRow(
                icon: Icons.cancel,
                label: 'Invalidated',
                value: _formatDate(hypothesis.invalidatedAt!),
              ),
            ],
            if (hypothesis.teamName != null) ...[
              const SizedBox(height: AppSpacing.sm),
              _MetadataRow(
                icon: Icons.group_outlined,
                label: 'Team',
                value: hypothesis.teamName!,
              ),
            ],
            if (hypothesis.ownerName != null) ...[
              const SizedBox(height: AppSpacing.sm),
              _MetadataRow(
                icon: Icons.person_outlined,
                label: 'Owner',
                value: hypothesis.ownerName!,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return 'Unknown';
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else {
      return '${duration.inMinutes}m';
    }
  }
}

class _MetadataRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetadataRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textTertiary),
        const SizedBox(width: AppSpacing.sm),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(value, style: AppTypography.bodySmall),
      ],
    );
  }
}
