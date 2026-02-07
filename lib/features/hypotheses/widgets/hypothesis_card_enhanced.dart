import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/avatar.dart';

class HypothesisCardEnhanced extends StatelessWidget {
  final Hypothesis hypothesis;

  const HypothesisCardEnhanced({super.key, required this.hypothesis});

  @override
  Widget build(BuildContext context) {
    final isValidated = hypothesis.status == HypothesisStatus.VALIDATED;
    final isInvalidated = hypothesis.status == HypothesisStatus.INVALIDATED;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go(Routes.hypothesisById(hypothesis.id)),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: isValidated
                  ? AppColors.success.withOpacity(0.5)
                  : isInvalidated
                      ? AppColors.error.withOpacity(0.5)
                      : AppColors.border,
              width: isValidated || isInvalidated ? 2 : 1,
            ),
          ),
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Linked outcome reference
              if (hypothesis.outcomeName != null)
                Text(
                  '→ ${hypothesis.outcomeName}',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

              if (hypothesis.outcomeName != null)
                const SizedBox(height: AppSpacing.xxs),

              // Title (statement)
              Text(
                hypothesis.statement,
                style: AppTypography.labelLarge.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: AppSpacing.xxs),

              // Description (belief statement) - italic, gray
              if (hypothesis.description != null && hypothesis.description!.isNotEmpty)
                Text(
                  hypothesis.description!,
                  style: AppTypography.bodySmall.copyWith(
                    fontStyle: FontStyle.italic,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

              const SizedBox(height: AppSpacing.xs),

              // Badges row: Effort, Impact, Confidence
              Row(
                children: [
                  if (hypothesis.effort != null)
                    _Badge(
                      label: hypothesis.effort!,
                      color: _effortColor(hypothesis.effort!),
                    ),
                  if (hypothesis.effort != null && hypothesis.impact != null)
                    const SizedBox(width: AppSpacing.xxs),
                  if (hypothesis.impact != null)
                    _Badge(
                      label: hypothesis.impact!,
                      color: _impactColor(hypothesis.impact!),
                    ),
                  if ((hypothesis.effort != null || hypothesis.impact != null) &&
                      hypothesis.confidence != null)
                    const SizedBox(width: AppSpacing.xxs),
                  if (hypothesis.confidence != null)
                    _ConfidenceBadge(confidence: hypothesis.confidence!),
                  const Spacer(),
                  // Owner avatar at bottom-right
                  if (hypothesis.ownerName != null)
                    ZAvatar(
                      name: hypothesis.ownerName!,
                      imageUrl: hypothesis.ownerAvatarUrl,
                      size: 24,
                    ),
                ],
              ),

              // Measuring cards: show metric improvements
              if (hypothesis.status == HypothesisStatus.MEASURING &&
                  hypothesis.metrics != null &&
                  hypothesis.metrics!.isNotEmpty)
                ..._buildMetricsSection(),

              // Concluded status badges
              if (isValidated || isInvalidated) ...[
                const SizedBox(height: AppSpacing.xs),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isValidated
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.error.withOpacity(0.1),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusSm),
                    border: Border.all(
                      color: isValidated
                          ? AppColors.success.withOpacity(0.5)
                          : AppColors.error.withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isValidated ? Icons.check_circle : Icons.cancel,
                        size: 14,
                        color: isValidated
                            ? AppColors.success
                            : AppColors.error,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isValidated ? 'VALIDATED' : 'INVALIDATED',
                        style: AppTypography.labelSmall.copyWith(
                          color: isValidated
                              ? AppColors.success
                              : AppColors.error,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                      if (isValidated) ...[
                        const SizedBox(width: 2),
                        Text(
                          '✓',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMetricsSection() {
    final metrics = hypothesis.metrics ?? [];
    if (metrics.isEmpty) return [];

    return [
      const SizedBox(height: AppSpacing.xs),
      Column(
        children: metrics.take(2).map((metric) {
          final improvement = metric.improvement;
          final formattedImprovement =
              improvement != null ? '${improvement.toStringAsFixed(1)}%' : 'N/A';
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Text(
                  metric.name,
                  style: AppTypography.labelSmall.copyWith(
                    fontSize: 9,
                    color: AppColors.textTertiary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Text(
                  formattedImprovement,
                  style: AppTypography.labelSmall.copyWith(
                    fontSize: 9,
                    color: improvement != null && improvement > 0
                        ? AppColors.success
                        : AppColors.textTertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    ];
  }

  Color _effortColor(String effort) {
    switch (effort.toUpperCase()) {
      case 'XS':
      case 'S':
        return AppColors.success;
      case 'M':
        return AppColors.warning;
      case 'L':
      case 'XL':
        return AppColors.error;
      default:
        return AppColors.secondary;
    }
  }

  Color _impactColor(String impact) {
    switch (impact.toUpperCase()) {
      case 'HIGH':
        return AppColors.success;
      case 'MEDIUM':
        return AppColors.warning;
      case 'LOW':
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _ConfidenceBadge extends StatelessWidget {
  final HypothesisConfidence confidence;

  const _ConfidenceBadge({required this.confidence});

  Color _getConfidenceColor() {
    final hexColor = confidence.color;
    return Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
  }

  @override
  Widget build(BuildContext context) {
    final color = _getConfidenceColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Text(
        confidence.displayName,
        style: AppTypography.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }
}
