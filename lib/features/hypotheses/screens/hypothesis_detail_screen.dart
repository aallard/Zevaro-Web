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
import '../../../shared/widgets/common/avatar.dart';

class HypothesisDetailScreen extends ConsumerWidget {
  final String id;

  const HypothesisDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hypothesisAsync = ref.watch(hypothesisProvider(id));
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 900;

    return hypothesisAsync.when(
      data: (hypothesis) => SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumb: "Hypotheses > {statement}"
            GestureDetector(
              onTap: () => context.go(Routes.hypotheses),
              child: Row(
                children: [
                  Text(
                    'Hypotheses',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '>',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      hypothesis.statement,
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Header with status badges
            _HypothesisHeader(hypothesis: hypothesis),
            const SizedBox(height: AppSpacing.lg),

            // Content
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        _BeliefSection(hypothesis: hypothesis),
                        const SizedBox(height: AppSpacing.lg),
                        _DescriptionSection(hypothesis: hypothesis),
                        const SizedBox(height: AppSpacing.lg),
                        if (hypothesis.metrics != null && hypothesis.metrics!.isNotEmpty)
                          ...[
                            _MetricsSection(hypothesis: hypothesis),
                            const SizedBox(height: AppSpacing.lg),
                          ],
                        _ExperimentsSection(
                          hypothesisId: hypothesis.id,
                          ref: ref,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: _SidebarPanel(hypothesis: hypothesis),
                  ),
                ],
              )
            else ...[
              _SidebarPanel(hypothesis: hypothesis),
              const SizedBox(height: AppSpacing.lg),
              _BeliefSection(hypothesis: hypothesis),
              const SizedBox(height: AppSpacing.lg),
              _DescriptionSection(hypothesis: hypothesis),
              const SizedBox(height: AppSpacing.lg),
              if (hypothesis.metrics != null && hypothesis.metrics!.isNotEmpty)
                ...[
                  _MetricsSection(hypothesis: hypothesis),
                  const SizedBox(height: AppSpacing.lg),
                ],
              _ExperimentsSection(
                hypothesisId: hypothesis.id,
                ref: ref,
              ),
            ],
          ],
        ),
      ),
      loading: () => const LoadingIndicator(message: 'Loading hypothesis...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () => ref.invalidate(hypothesisProvider(id)),
      ),
    );
  }
}

class _HypothesisHeader extends StatelessWidget {
  final Hypothesis hypothesis;

  const _HypothesisHeader({required this.hypothesis});

  Color get _statusColor {
    switch (hypothesis.status) {
      case HypothesisStatus.VALIDATED:
        return AppColors.success;
      case HypothesisStatus.INVALIDATED:
        return AppColors.error;
      case HypothesisStatus.MEASURING:
      case HypothesisStatus.DEPLOYED:
        return AppColors.warning;
      case HypothesisStatus.BUILDING:
        return AppColors.secondary;
      case HypothesisStatus.BLOCKED:
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Text(
                hypothesis.status.displayName.toUpperCase(),
                style: AppTypography.labelSmall.copyWith(
                  color: _statusColor,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            if (hypothesis.effort != null) ...[
              const SizedBox(width: AppSpacing.xs),
              _MetaBadge(
                label: 'Effort: ${hypothesis.effort}',
                color: AppColors.secondary,
              ),
            ],
            if (hypothesis.impact != null) ...[
              const SizedBox(width: AppSpacing.xs),
              _MetaBadge(
                label: 'Impact: ${hypothesis.impact}',
                color: AppColors.success,
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(hypothesis.statement, style: AppTypography.h2),
        if (hypothesis.outcomeName != null) ...[
          const SizedBox(height: AppSpacing.xxs),
          Row(
            children: [
              Icon(Icons.flag_outlined, size: 14, color: AppColors.textTertiary),
              const SizedBox(width: 4),
              Text(
                'Linked to: ${hypothesis.outcomeName}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _MetaBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _MetaBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _BeliefSection extends StatelessWidget {
  final Hypothesis hypothesis;

  const _BeliefSection({required this.hypothesis});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.cardPaddingLarge),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.03),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hypothesis Statement', style: AppTypography.h4),
          const SizedBox(height: AppSpacing.md),
          if (hypothesis.statement.isNotEmpty) ...[
            _BeliefRow(
              label: 'We believe',
              content: hypothesis.statement,
            ),
          ],
          if (hypothesis.description != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _BeliefRow(
              label: 'Will result in',
              content: hypothesis.description!,
            ),
          ],
          if (hypothesis.metrics != null && hypothesis.metrics!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            _BeliefRow(
              label: 'Measured by',
              content: hypothesis.metrics!
                  .map((m) => m.name)
                  .join(', '),
            ),
          ],
        ],
      ),
    );
  }
}

class _BeliefRow extends StatelessWidget {
  final String label;
  final String content;

  const _BeliefRow({required this.label, required this.content});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            content,
            style: AppTypography.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  final Hypothesis hypothesis;

  const _DescriptionSection({required this.hypothesis});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Description', style: AppTypography.h4),
          const SizedBox(height: AppSpacing.sm),
          Text(
            hypothesis.description ?? 'No description provided.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricsSection extends StatelessWidget {
  final Hypothesis hypothesis;

  const _MetricsSection({required this.hypothesis});

  @override
  Widget build(BuildContext context) {
    final metrics = hypothesis.metrics ?? [];
    if (metrics.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Metrics', style: AppTypography.h4),
          const SizedBox(height: AppSpacing.md),
          ...metrics.map((metric) {
            final progress = metric.progressToTarget;
            final progressPercent =
                progress != null ? (progress * 100).toStringAsFixed(1) : 'N/A';
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              metric.name,
                              style: AppTypography.labelMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xxs),
                            Text(
                              'Baseline: ${metric.formattedBaseline} → Target: ${metric.formattedTarget}',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                        child: Text(
                          '$progressPercent%',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (metric.currentValue != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusSm),
                      child: LinearProgressIndicator(
                        value: progress != null
                            ? progress.clamp(0.0, 1.0)
                            : null,
                        minHeight: 4,
                        backgroundColor:
                            AppColors.textTertiary.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progress != null && progress > 0
                              ? AppColors.success
                              : AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class _ExperimentsSection extends StatelessWidget {
  final String hypothesisId;
  final WidgetRef ref;

  const _ExperimentsSection({
    required this.hypothesisId,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final experimentsAsync =
        ref.watch(hypothesisExperimentsProvider(hypothesisId));

    return Container(
      width: double.infinity,
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
              Text('Experiments', style: AppTypography.h4),
              const Spacer(),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Experiment'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          experimentsAsync.when(
            data: (experiments) {
              if (experiments.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Center(
                    child: Text(
                      'No experiments linked yet.',
                      style: AppTypography.bodySmall,
                    ),
                  ),
                );
              }
              return Column(
                children: experiments
                    .map((e) => _ExperimentRow(experiment: e))
                    .toList(),
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (e, _) => Text('Failed to load experiments',
                style: AppTypography.bodySmall),
          ),
        ],
      ),
    );
  }
}

class _ExperimentRow extends StatelessWidget {
  final Experiment experiment;

  const _ExperimentRow({required this.experiment});

  Color get _typeColor {
    switch (experiment.type) {
      case ExperimentType.A_B_TEST:
        return const Color(0xFF8B5CF6);
      case ExperimentType.FEATURE_FLAG:
        return const Color(0xFF14B8A6);
      case ExperimentType.CANARY:
        return const Color(0xFFF59E0B);
      case ExperimentType.MANUAL:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.borderLight),
        ),
      ),
      child: Row(
        children: [
          // Type badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: _typeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Text(
              experiment.type.displayName,
              style: AppTypography.labelSmall.copyWith(
                color: _typeColor,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Name
          Expanded(
            child: Text(
              experiment.name,
              style: AppTypography.labelLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: _statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Text(
              experiment.status.displayName,
              style: AppTypography.labelSmall.copyWith(
                color: _statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Confidence
          if (experiment.confidenceLevel != null) ...[
            const SizedBox(width: AppSpacing.sm),
            Text(
              '${experiment.confidenceLevel!.toStringAsFixed(0)}% conf.',
              style: AppTypography.labelSmall.copyWith(
                color: experiment.isSignificant
                    ? AppColors.success
                    : AppColors.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color get _statusColor {
    switch (experiment.status) {
      case ExperimentStatus.RUNNING:
        return AppColors.secondary;
      case ExperimentStatus.CONCLUDED:
        return AppColors.success;
      case ExperimentStatus.CANCELLED:
        return AppColors.error;
      default:
        return AppColors.textTertiary;
    }
  }
}

class _SidebarPanel extends StatelessWidget {
  final Hypothesis hypothesis;

  const _SidebarPanel({required this.hypothesis});

  Color get _statusColor {
    switch (hypothesis.status) {
      case HypothesisStatus.VALIDATED:
        return AppColors.success;
      case HypothesisStatus.INVALIDATED:
        return AppColors.error;
      case HypothesisStatus.MEASURING:
      case HypothesisStatus.DEPLOYED:
        return AppColors.warning;
      case HypothesisStatus.BUILDING:
        return AppColors.secondary;
      default:
        return AppColors.primary;
    }
  }

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
          _Field(
            label: 'Status',
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Text(
                hypothesis.status.displayName,
                style: AppTypography.labelMedium.copyWith(
                  color: _statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const Divider(height: AppSpacing.lg),
          _Field(
            label: 'Owner',
            child: Row(
              children: [
                ZAvatar(
                  name: hypothesis.ownerName ?? 'Unassigned',
                  size: 28,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(hypothesis.ownerName ?? 'Unassigned',
                    style: AppTypography.bodyMedium),
              ],
            ),
          ),
          if (hypothesis.effort != null) ...[
            const Divider(height: AppSpacing.lg),
            _Field(
              label: 'Effort',
              child: Text(hypothesis.effort!,
                  style: AppTypography.bodyMedium),
            ),
          ],
          if (hypothesis.impact != null) ...[
            const Divider(height: AppSpacing.lg),
            _Field(
              label: 'Impact',
              child: Text(hypothesis.impact!,
                  style: AppTypography.bodyMedium),
            ),
          ],
          if (hypothesis.project != null) ...[
            const Divider(height: AppSpacing.lg),
            _Field(
              label: 'Project',
              child: Text(hypothesis.project!.name,
                  style: AppTypography.bodyMedium),
            ),
          ],
          const Divider(height: AppSpacing.lg),
          _Field(
            label: 'Created',
            child: Text(
              _formatDate(hypothesis.createdAt),
              style: AppTypography.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _Field extends StatelessWidget {
  final String label;
  final Widget child;

  const _Field({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTypography.labelSmall
                .copyWith(color: AppColors.textTertiary)),
        const SizedBox(height: AppSpacing.xxs),
        child,
      ],
    );
  }
}
