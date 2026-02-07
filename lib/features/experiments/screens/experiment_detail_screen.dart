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
import '../providers/experiments_providers.dart';

class ExperimentDetailScreen extends ConsumerWidget {
  final String id;

  const ExperimentDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final experimentAsync = ref.watch(experimentDetailProvider(id));
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 900;

    return experimentAsync.when(
      data: (experiment) => SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumb
            Row(
              children: [
                TextButton.icon(
                  onPressed: () => context.go(Routes.experiments),
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: const Text('Experiments'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    padding: EdgeInsets.zero,
                  ),
                ),
                Text(
                  ' > ',
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.textTertiary),
                ),
                Text(
                  experiment.name,
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Header
            _ExperimentHeader(experiment: experiment),
            const SizedBox(height: AppSpacing.md),

            // Timeline bar for running experiments
            if (experiment.status == ExperimentStatus.RUNNING &&
                experiment.daysElapsed != null) ...[
              _TimelineBar(experiment: experiment),
              const SizedBox(height: AppSpacing.lg),
            ],

            // Content
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        _VariantComparison(experiment: experiment),
                        const SizedBox(height: AppSpacing.lg),
                        _DescriptionSection(experiment: experiment),
                        const SizedBox(height: AppSpacing.lg),
                        _ConfigSection(experiment: experiment),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      children: [
                        _SidebarPanel(experiment: experiment),
                        const SizedBox(height: AppSpacing.lg),
                        _QuickActionsPanel(experiment: experiment),
                      ],
                    ),
                  ),
                ],
              )
            else ...[
              _SidebarPanel(experiment: experiment),
              const SizedBox(height: AppSpacing.lg),
              _QuickActionsPanel(experiment: experiment),
              const SizedBox(height: AppSpacing.lg),
              _VariantComparison(experiment: experiment),
              const SizedBox(height: AppSpacing.lg),
              _DescriptionSection(experiment: experiment),
              const SizedBox(height: AppSpacing.lg),
              _ConfigSection(experiment: experiment),
            ],
          ],
        ),
      ),
      loading: () =>
          const LoadingIndicator(message: 'Loading experiment...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () => ref.invalidate(experimentDetailProvider(id)),
      ),
    );
  }
}

class _TimelineBar extends StatelessWidget {
  final Experiment experiment;

  const _TimelineBar({required this.experiment});

  @override
  Widget build(BuildContext context) {
    final progress = ((experiment.daysElapsed ?? 0) /
            (experiment.durationDays ?? 1) *
            100)
        .clamp(0, 100);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
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
              Text(
                'Day ${experiment.daysElapsed} of ${experiment.durationDays ?? "∞"}',
                style: AppTypography.h4,
              ),
              const Spacer(),
              Text(
                '${progress.toStringAsFixed(0)}%',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            child: LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: AppColors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getTypeColor(experiment),
              ),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(Experiment experiment) {
    switch (experiment.type) {
      case ExperimentType.A_B_TEST:
        return AppColors.experimentAbTest;
      case ExperimentType.FEATURE_FLAG:
        return AppColors.experimentFeatureFlag;
      case ExperimentType.CANARY:
        return AppColors.experimentCanary;
      case ExperimentType.MANUAL:
        return AppColors.experimentManual;
    }
  }
}

class _ExperimentHeader extends StatelessWidget {
  final Experiment experiment;

  const _ExperimentHeader({required this.experiment});

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: _typeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Text(
                experiment.type.displayName.toUpperCase(),
                style: AppTypography.labelSmall.copyWith(
                  color: _typeColor,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: _statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Text(
                experiment.status.displayName.toUpperCase(),
                style: AppTypography.labelSmall.copyWith(
                  color: _statusColor,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(experiment.name, style: AppTypography.h2),
        if (experiment.hypothesisTitle != null) ...[
          const SizedBox(height: AppSpacing.xxs),
          Row(
            children: [
              Icon(Icons.science, size: 14, color: AppColors.textTertiary),
              const SizedBox(width: 4),
              Text(
                'Testing: ${experiment.hypothesisTitle}',
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.textTertiary),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _VariantComparison extends StatelessWidget {
  final Experiment experiment;

  const _VariantComparison({required this.experiment});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.cardPaddingLarge),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Variant Comparison', style: AppTypography.h4),
          const SizedBox(height: AppSpacing.lg),

          if (experiment.controlValue == null ||
              experiment.variantValue == null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text('No results recorded yet.',
                    style: AppTypography.bodySmall),
              ),
            )
          else ...[
            // Large metric comparison
            Row(
              children: [
                Expanded(
                  child: _LargeMetric(
                    label: 'Control',
                    value: experiment.controlValue!,
                    color: AppColors.textSecondary,
                  ),
                ),
                // VS divider
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Text('vs',
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.textTertiary)),
                ),
                Expanded(
                  child: _LargeMetric(
                    label: 'Variant',
                    value: experiment.variantValue!,
                    color: experiment.isVariantWinning
                        ? AppColors.success
                        : AppColors.error,
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                // Delta
                if (experiment.deltaPercent != null)
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: experiment.isVariantWinning
                          ? AppColors.success.withOpacity(0.1)
                          : AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                          AppSpacing.radiusLg),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          experiment.isVariantWinning
                              ? Icons.trending_up
                              : Icons.trending_down,
                          color: experiment.isVariantWinning
                              ? AppColors.success
                              : AppColors.error,
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${experiment.isVariantWinning ? "+" : ""}${experiment.deltaPercent!.toStringAsFixed(1)}%',
                          style: AppTypography.h3.copyWith(
                            color: experiment.isVariantWinning
                                ? AppColors.success
                                : AppColors.error,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Statistical summary row
            Row(
              children: [
                _StatBox(
                  label: 'Confidence',
                  value: experiment.confidenceLevel != null
                      ? '${experiment.confidenceLevel!.toStringAsFixed(1)}%'
                      : 'N/A',
                  color: experiment.isSignificant
                      ? AppColors.success
                      : AppColors.warning,
                ),
                const SizedBox(width: AppSpacing.md),
                _StatBox(
                  label: 'Sample Size',
                  value:
                      '${experiment.currentSampleSize} / ${experiment.sampleSizeTarget}',
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSpacing.md),
                _StatBox(
                  label: 'Traffic Split',
                  value: '${experiment.trafficSplit}%',
                  color: AppColors.info,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _LargeMetric extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _LargeMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        children: [
          Text(label, style: AppTypography.labelSmall),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            '${value.toStringAsFixed(1)}%',
            style: AppTypography.h1.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Column(
          children: [
            Text(label, style: AppTypography.labelSmall),
            const SizedBox(height: 2),
            Text(
              value,
              style: AppTypography.labelLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  final Experiment experiment;

  const _DescriptionSection({required this.experiment});

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
            experiment.description ?? 'No description provided.',
            style: AppTypography.bodyMedium
                .copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _ConfigSection extends StatelessWidget {
  final Experiment experiment;

  const _ConfigSection({required this.experiment});

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
          Text('Configuration', style: AppTypography.h4),
          const SizedBox(height: AppSpacing.md),
          _ConfigRow(
              label: 'Primary Metric',
              value: experiment.primaryMetric ?? 'Not set'),
          _ConfigRow(
              label: 'Duration',
              value: experiment.durationDays != null
                  ? '${experiment.durationDays} days'
                  : 'Open-ended'),
          _ConfigRow(
              label: 'Traffic Split',
              value: '${experiment.trafficSplit}% variant'),
          _ConfigRow(
              label: 'Target Sample',
              value: '${experiment.sampleSizeTarget} users'),
          if (experiment.audienceFilter != null)
            _ConfigRow(
                label: 'Audience', value: experiment.audienceFilter!),
        ],
      ),
    );
  }
}

class _ConfigRow extends StatelessWidget {
  final String label;
  final String value;

  const _ConfigRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(label,
                style: AppTypography.labelSmall
                    .copyWith(color: AppColors.textTertiary)),
          ),
          Expanded(
            child: Text(value, style: AppTypography.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _SidebarPanel extends StatelessWidget {
  final Experiment experiment;

  const _SidebarPanel({required this.experiment});

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
                experiment.status.displayName,
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
                  name: experiment.ownerName ?? 'Unassigned',
                  size: 28,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(experiment.ownerName ?? 'Unassigned',
                    style: AppTypography.bodyMedium),
              ],
            ),
          ),
          if (experiment.hypothesisTitle != null) ...[
            const Divider(height: AppSpacing.lg),
            _Field(
              label: 'Hypothesis',
              child: Text(experiment.hypothesisTitle!,
                  style: AppTypography.bodyMedium),
            ),
          ],
          if (experiment.startDate != null) ...[
            const Divider(height: AppSpacing.lg),
            _Field(
              label: 'Start Date',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_formatDate(experiment.startDate!),
                      style: AppTypography.bodyMedium),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    '${_daysAgo(experiment.startDate!)} days ago',
                    style: AppTypography.labelSmall
                        .copyWith(color: AppColors.textTertiary),
                  ),
                ],
              ),
            ),
          ],
          if (experiment.endDate != null) ...[
            const Divider(height: AppSpacing.lg),
            _Field(
              label: 'End Date',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_formatDate(experiment.endDate!),
                      style: AppTypography.bodyMedium),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    '${experiment.daysRemaining ?? 0} days remaining',
                    style: AppTypography.labelSmall.copyWith(
                      color: experiment.isOverdue
                          ? AppColors.error
                          : AppColors.textTertiary,
                      fontWeight: experiment.isOverdue
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (experiment.daysRemaining != null &&
              experiment.status == ExperimentStatus.RUNNING) ...[
            const Divider(height: AppSpacing.lg),
            _Field(
              label: 'Days Remaining',
              child: Text('${experiment.daysRemaining} days',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  )),
            ),
          ],
          if (experiment.project != null) ...[
            const Divider(height: AppSpacing.lg),
            _Field(
              label: 'Project',
              child: Text(experiment.project!.name,
                  style: AppTypography.bodyMedium),
            ),
          ],
          if (experiment.conclusion != null) ...[
            const Divider(height: AppSpacing.lg),
            _Field(
              label: 'Conclusion',
              child: Text(experiment.conclusion!,
                  style: AppTypography.bodyMedium),
            ),
          ],
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

  int _daysAgo(DateTime date) {
    return DateTime.now().difference(date).inDays;
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

class _QuickActionsPanel extends StatelessWidget {
  final Experiment experiment;

  const _QuickActionsPanel({required this.experiment});

  @override
  Widget build(BuildContext context) {
    final isRunning = experiment.status == ExperimentStatus.RUNNING;
    final isConcluded = experiment.status == ExperimentStatus.CONCLUDED;

    if (!isRunning && !isConcluded) {
      return const SizedBox.shrink();
    }

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
          Text('Quick Actions', style: AppTypography.h4),
          const SizedBox(height: AppSpacing.md),
          if (isRunning) ...[
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.warning,
                ),
                child: Text(
                  'End Early',
                  style: AppTypography.labelMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.success,
                ),
                child: Text(
                  'Extend Duration',
                  style: AppTypography.labelMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
          if (isConcluded) ...[
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: Text(
                  'Declare Winner',
                  style: AppTypography.labelMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
