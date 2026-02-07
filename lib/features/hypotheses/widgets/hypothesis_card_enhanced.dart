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
                  ? AppColors.success.withOpacity(0.4)
                  : isInvalidated
                      ? AppColors.error.withOpacity(0.4)
                      : AppColors.border,
            ),
          ),
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Linked outcome
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

              const SizedBox(height: AppSpacing.xxs),

              // Title
              Text(
                hypothesis.title,
                style: AppTypography.labelLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: AppSpacing.xxs),

              // Belief statement
              if (hypothesis.beliefStatement != null)
                Text(
                  hypothesis.beliefStatement!,
                  style: AppTypography.bodySmall.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

              const SizedBox(height: AppSpacing.xs),

              // Effort + Impact badges
              Row(
                children: [
                  if (hypothesis.effort != null)
                    _Badge(
                      label: hypothesis.effort!,
                      color: AppColors.secondary,
                    ),
                  if (hypothesis.effort != null && hypothesis.impact != null)
                    const SizedBox(width: AppSpacing.xxs),
                  if (hypothesis.impact != null)
                    _Badge(
                      label: hypothesis.impact!,
                      color: _impactColor(hypothesis.impact!),
                    ),
                  const Spacer(),
                  // Owner avatar
                  if (hypothesis.ownerName != null)
                    ZAvatar(
                      name: hypothesis.ownerName!,
                      imageUrl: hypothesis.ownerAvatarUrl,
                      size: 20,
                    ),
                ],
              ),

              // Concluded status
              if (isValidated || isInvalidated) ...[
                const SizedBox(height: AppSpacing.xs),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isValidated
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.error.withOpacity(0.1),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isValidated ? Icons.check : Icons.close,
                        size: 12,
                        color: isValidated
                            ? AppColors.success
                            : AppColors.error,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        isValidated ? 'VALIDATED' : 'INVALIDATED',
                        style: AppTypography.labelSmall.copyWith(
                          color: isValidated
                              ? AppColors.success
                              : AppColors.error,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
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

  Color _impactColor(String impact) {
    switch (impact.toUpperCase()) {
      case 'HIGH':
        return AppColors.success;
      case 'MEDIUM':
        return AppColors.warning;
      case 'LOW':
        return AppColors.textTertiary;
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
