import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class ExperimentCard extends StatelessWidget {
  final Experiment experiment;

  const ExperimentCard({super.key, required this.experiment});

  Color get _typeColor {
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

  @override
  Widget build(BuildContext context) {
    final isRunning = experiment.status == ExperimentStatus.RUNNING;
    final isConcluded = experiment.status == ExperimentStatus.CONCLUDED;
    final isDraft = experiment.status == ExperimentStatus.DRAFT;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go(Routes.experimentById(experiment.id)),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: Type badge + title + action buttons (running only)
              Row(
                children: [
                  // Type badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _typeColor.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Text(
                      experiment.type.displayName.toUpperCase(),
                      style: AppTypography.labelSmall.copyWith(
                        color: _typeColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      experiment.name,
                      style: AppTypography.h4,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Action buttons for running experiments
                  if (isRunning) ...[
                    const SizedBox(width: AppSpacing.sm),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xxs,
                        ),
                      ),
                      child: Text(
                        'View Details',
                        style: AppTypography.labelSmall,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xxs,
                        ),
                      ),
                      child: Text(
                        'End Early',
                        style: AppTypography.labelSmall,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xxs,
                        ),
                      ),
                      child: Text(
                        'Extend',
                        style: AppTypography.labelSmall,
                      ),
                    ),
                  ],
                ],
              ),

              // Linked hypothesis
              if (experiment.hypothesisTitle != null) ...[
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '→ ${experiment.hypothesisTitle}',
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.textTertiary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: AppSpacing.md),

              // Timeline bar for running experiments
              if (isRunning && experiment.daysElapsed != null) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Day ${experiment.daysElapsed} of ${experiment.durationDays ?? "∞"}',
                          style: AppTypography.labelSmall.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${((experiment.daysElapsed ?? 0) / (experiment.durationDays ?? 1) * 100).toStringAsFixed(0)}%',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusFull),
                      child: LinearProgressIndicator(
                        value: (experiment.daysElapsed ?? 0) /
                            (experiment.durationDays ?? 1),
                        backgroundColor: AppColors.surfaceVariant,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _typeColor,
                        ),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ],

              // Sample indicator for running experiments
              if (isRunning) ...[
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: experiment.hasReachedSampleTarget
                            ? AppColors.success
                            : AppColors.warning,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'Sample: ${experiment.currentSampleSize} / ${experiment.sampleSizeTarget} required',
                      style: AppTypography.labelSmall,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
              ],

              // Metrics row (for running/concluded)
              if (experiment.controlValue != null &&
                  experiment.variantValue != null) ...[
                Row(
                  children: [
                    // Control
                    _MetricDisplay(
                      label: 'Control',
                      value:
                          '${experiment.controlValue!.toStringAsFixed(1)}%',
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    // Variant
                    _MetricDisplay(
                      label: 'Variant',
                      value:
                          '${experiment.variantValue!.toStringAsFixed(1)}%',
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    // Delta
                    if (experiment.deltaPercent != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: experiment.isVariantWinning
                              ? AppColors.success.withOpacity(0.1)
                              : AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                              AppSpacing.radiusMd),
                        ),
                        child: Text(
                          '${experiment.isVariantWinning ? "+" : ""}${experiment.deltaPercent!.toStringAsFixed(1)}%',
                          style: AppTypography.h4.copyWith(
                            color: experiment.isVariantWinning
                                ? AppColors.success
                                : AppColors.error,
                          ),
                        ),
                      ),
                    const Spacer(),
                    // Confidence
                    if (experiment.confidenceLevel != null) ...[
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: experiment.isSignificant
                              ? AppColors.success
                              : AppColors.warning,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xxs),
                      Text(
                        '${experiment.confidenceLevel!.toStringAsFixed(0)}% confidence',
                        style: AppTypography.labelMedium.copyWith(
                          color: experiment.isSignificant
                              ? AppColors.success
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
              ],

              // Result banner for concluded
              if (isConcluded) ...[
                if (experiment.isVariantWinning &&
                    experiment.isSignificant &&
                    experiment.deltaPercent != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.08),
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusMd),
                      border: Border.all(
                        color: AppColors.success.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      'WINNER: Variant — +${experiment.deltaPercent!.toStringAsFixed(1)}%',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricDisplay extends StatelessWidget {
  final String label;
  final String value;

  const _MetricDisplay({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.labelSmall),
        Text(
          value,
          style: AppTypography.h3.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
