import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/loading_indicator.dart';
import '../../../shared/widgets/common/error_view.dart';
import '../providers/decisions_providers.dart';
import 'decision_card.dart';

class DecisionBoard extends ConsumerWidget {
  const DecisionBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decisionsAsync = ref.watch(decisionsByStatusProvider);

    return decisionsAsync.when(
      data: (decisionsByStatus) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(AppSpacing.md),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BoardColumn(
                  status: DecisionStatus.NEEDS_INPUT,
                  decisions: decisionsByStatus[DecisionStatus.NEEDS_INPUT] ?? [],
                ),
                const SizedBox(width: AppSpacing.sm),
                _BoardColumn(
                  status: DecisionStatus.UNDER_DISCUSSION,
                  decisions:
                      decisionsByStatus[DecisionStatus.UNDER_DISCUSSION] ?? [],
                ),
                const SizedBox(width: AppSpacing.sm),
                _BoardColumn(
                  status: DecisionStatus.DECIDED,
                  decisions: decisionsByStatus[DecisionStatus.DECIDED] ?? [],
                ),
                const SizedBox(width: AppSpacing.sm),
                _BoardColumn(
                  status: DecisionStatus.IMPLEMENTED,
                  decisions: decisionsByStatus[DecisionStatus.IMPLEMENTED] ?? [],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const LoadingIndicator(message: 'Loading decisions...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () => ref.invalidate(decisionsByStatusProvider),
      ),
    );
  }
}

class _BoardColumn extends StatelessWidget {
  final DecisionStatus status;
  final List<Decision> decisions;

  const _BoardColumn({
    required this.status,
    required this.decisions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Column header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _getHeaderColor(),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  _getTitle(),
                  style: AppTypography.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: Text(
                    '${decisions.length}',
                    style: AppTypography.labelSmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Cards
          Expanded(
            child: decisions.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: AppSpacing.xxs,
                    ),
                    itemCount: decisions.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.xs),
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
        return AppColors.primary;
      case DecisionStatus.DEFERRED:
        return AppColors.surfaceVariant;
      case DecisionStatus.CANCELLED:
        return AppColors.surfaceVariant;
    }
  }

  Color _getBackgroundColor() {
    switch (status) {
      case DecisionStatus.NEEDS_INPUT:
        return AppColors.error.withOpacity(0.03);
      case DecisionStatus.UNDER_DISCUSSION:
        return AppColors.warning.withOpacity(0.03);
      case DecisionStatus.DECIDED:
        return AppColors.success.withOpacity(0.03);
      case DecisionStatus.IMPLEMENTED:
        return AppColors.primary.withOpacity(0.03);
      default:
        return AppColors.surfaceVariant.withOpacity(0.5);
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
