import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/loading_indicator.dart';
import 'leaderboard_entry.dart';

class StakeholderLeaderboard extends ConsumerWidget {
  const StakeholderLeaderboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardAsync = ref.watch(stakeholderLeaderboardProvider());
    final currentUserAsync = ref.watch(currentUserProvider);
    final currentUserId = currentUserAsync.valueOrNull?.id;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.leaderboard, color: AppColors.warning),
                const SizedBox(width: AppSpacing.sm),
                Text('Response Time Leaderboard', style: AppTypography.h4),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            leaderboardAsync.when(
              data: (entries) {
                if (entries.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Text(
                        'No leaderboard data yet',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: entries.length.clamp(0, 10),
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return LeaderboardEntryWidget(
                      entry: entry,
                      isCurrentUser: entry.userId == currentUserId,
                    );
                  },
                );
              },
              loading: () => const LoadingIndicator(),
              error: (e, _) => Text('Error: $e'),
            ),
          ],
        ),
      ),
    );
  }
}
