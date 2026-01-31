import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import 'urgency_badge.dart';
import 'sla_indicator.dart';

class DecisionListItem extends StatelessWidget {
  final Decision decision;

  const DecisionListItem({
    super.key,
    required this.decision,
  });

  @override
  Widget build(BuildContext context) {
    final urgencyColor =
        Color(int.parse(decision.urgency.color.replaceFirst('#', '0xFF')));
    final statusColor = _getStatusColor(decision.status);

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        leading: Container(
          width: 4,
          height: 48,
          decoration: BoxDecoration(
            color: urgencyColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        title: Text(
          decision.title,
          style: AppTypography.labelLarge,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Text(
                decision.status.displayName,
                style: AppTypography.labelSmall.copyWith(color: statusColor),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: SlaIndicator(decision: decision)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            UrgencyBadge(urgency: decision.urgency, compact: true),
            const SizedBox(width: AppSpacing.sm),
            const Icon(Icons.chevron_right, color: AppColors.textTertiary),
          ],
        ),
        onTap: () => context.go(Routes.decisionById(decision.id)),
      ),
    );
  }

  Color _getStatusColor(DecisionStatus status) {
    switch (status) {
      case DecisionStatus.NEEDS_INPUT:
        return AppColors.error;
      case DecisionStatus.UNDER_DISCUSSION:
        return AppColors.warning;
      case DecisionStatus.DECIDED:
        return AppColors.success;
    }
  }
}
