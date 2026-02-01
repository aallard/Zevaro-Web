import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/badge.dart';
import 'decision_card.dart';

class DecisionColumn extends StatelessWidget {
  final DecisionStatus status;
  final List<Decision> decisions;

  const DecisionColumn({
    super.key,
    required this.status,
    required this.decisions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      margin: const EdgeInsets.only(right: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Column header
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: _getHeaderColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getHeaderColor(),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  _getTitle(),
                  style: AppTypography.labelLarge,
                ),
                const SizedBox(width: AppSpacing.sm),
                ZBadge(
                  count: decisions.length,
                  color: AppColors.textSecondary,
                  showZero: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Cards
          Expanded(
            child: decisions.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    itemCount: decisions.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      return DecisionCard(decision: decisions[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getEmptyIcon(),
              size: 32,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              _getEmptyMessage(),
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getHeaderColor() {
    switch (status) {
      case DecisionStatus.NEEDS_INPUT:
        return AppColors.error;
      case DecisionStatus.UNDER_DISCUSSION:
        return AppColors.warning;
      case DecisionStatus.DECIDED:
        return AppColors.success;
      case DecisionStatus.IMPLEMENTED:
        return AppColors.success;
      case DecisionStatus.DEFERRED:
        return AppColors.surfaceVariant;
      case DecisionStatus.CANCELLED:
        return AppColors.surfaceVariant;
    }
  }

  String _getTitle() {
    switch (status) {
      case DecisionStatus.NEEDS_INPUT:
        return 'Needs Input';
      case DecisionStatus.UNDER_DISCUSSION:
        return 'Under Discussion';
      case DecisionStatus.DECIDED:
        return 'Decided';
      case DecisionStatus.IMPLEMENTED:
        return 'Implemented';
      case DecisionStatus.DEFERRED:
        return 'Deferred';
      case DecisionStatus.CANCELLED:
        return 'Cancelled';
    }
  }

  IconData _getEmptyIcon() {
    switch (status) {
      case DecisionStatus.NEEDS_INPUT:
        return Icons.inbox_outlined;
      case DecisionStatus.UNDER_DISCUSSION:
        return Icons.forum_outlined;
      case DecisionStatus.DECIDED:
        return Icons.check_circle_outline;
      case DecisionStatus.IMPLEMENTED:
        return Icons.rocket_launch_outlined;
      case DecisionStatus.DEFERRED:
        return Icons.pause_circle_outline;
      case DecisionStatus.CANCELLED:
        return Icons.cancel_outlined;
    }
  }

  String _getEmptyMessage() {
    switch (status) {
      case DecisionStatus.NEEDS_INPUT:
        return 'No decisions waiting for input';
      case DecisionStatus.UNDER_DISCUSSION:
        return 'No active discussions';
      case DecisionStatus.DECIDED:
        return 'No recent decisions';
      case DecisionStatus.IMPLEMENTED:
        return 'No implemented decisions';
      case DecisionStatus.DEFERRED:
        return 'No deferred decisions';
      case DecisionStatus.CANCELLED:
        return 'No cancelled decisions';
    }
  }
}
