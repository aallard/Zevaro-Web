import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../providers/stakeholders_providers.dart';

class ResponseHistoryCard extends ConsumerWidget {
  final String stakeholderId;

  const ResponseHistoryCard({super.key, required this.stakeholderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync =
        ref.watch(stakeholderResponseHistoryProvider(stakeholderId));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history, color: AppColors.primary),
                const SizedBox(width: AppSpacing.sm),
                Text('Response History', style: AppTypography.h4),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            historyAsync.when(
              data: (responses) {
                if (responses.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        children: [
                          Icon(Icons.history,
                              size: 32, color: AppColors.textTertiary),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'No response history yet',
                            style: TextStyle(color: AppColors.textTertiary),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: responses.length.clamp(0, 10),
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final response = responses[index];
                    return _ResponseHistoryItem(response: response);
                  },
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text('Error: $e'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResponseHistoryItem extends StatelessWidget {
  final StakeholderResponse response;

  const _ResponseHistoryItem({required this.response});

  @override
  Widget build(BuildContext context) {
    final wasOnTime = response.withinSla;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: (wasOnTime ? AppColors.success : AppColors.error).withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          wasOnTime ? Icons.check : Icons.schedule,
          color: wasOnTime ? AppColors.success : AppColors.error,
          size: 20,
        ),
      ),
      title: Text(
        response.decisionTitle ?? 'Decision',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Row(
        children: [
          Text(
            response.responseTimeDisplay,
            style: AppTypography.bodySmall.copyWith(
              color: wasOnTime ? AppColors.success : AppColors.error,
            ),
          ),
          if (response.respondedAt != null) ...[
            const SizedBox(width: AppSpacing.sm),
            Text(
              '• ${_formatDate(response.respondedAt!)}',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ],
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
        decoration: BoxDecoration(
          color: (wasOnTime ? AppColors.success : AppColors.warning).withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        child: Text(
          wasOnTime ? 'On Time' : 'Late',
          style: AppTypography.labelSmall.copyWith(
            color: wasOnTime ? AppColors.success : AppColors.warning,
          ),
        ),
      ),
      onTap: () => context.go(Routes.decisionById(response.decisionId)),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'Today';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
