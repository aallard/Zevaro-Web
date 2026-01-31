import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import 'hypothesis_status_badge.dart';

class HypothesisCard extends StatelessWidget {
  final Hypothesis hypothesis;

  const HypothesisCard({super.key, required this.hypothesis});

  @override
  Widget build(BuildContext context) {
    final statusColor =
        Color(int.parse(hypothesis.status.color.replaceFirst('#', '0xFF')));

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go(Routes.hypothesisById(hypothesis.id)),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: statusColor, width: 4),
            ),
          ),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  HypothesisStatusBadge(status: hypothesis.status, compact: true),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Text(
                      'Score: ${hypothesis.priorityScore}',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              // Statement
              Text(
                hypothesis.statement,
                style: AppTypography.labelLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xs),

              // Description
              if (hypothesis.description?.isNotEmpty ?? false)
                Text(
                  hypothesis.description!,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: AppSpacing.md),

              // Effort/Impact
              Row(
                children: [
                  _SizeIndicator(
                    label: 'Effort',
                    size: hypothesis.effortDisplay,
                    icon: Icons.work_outline,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  _SizeIndicator(
                    label: 'Impact',
                    size: hypothesis.impactDisplay,
                    icon: Icons.trending_up,
                  ),
                  const Spacer(),
                  if (hypothesis.status == HypothesisStatus.BLOCKED)
                    Icon(Icons.block, color: AppColors.error, size: 18),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SizeIndicator extends StatelessWidget {
  final String label;
  final String size;
  final IconData icon;

  const _SizeIndicator({
    required this.label,
    required this.size,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textTertiary),
        const SizedBox(width: 4),
        Text(
          size,
          style: AppTypography.labelSmall,
        ),
      ],
    );
  }
}
