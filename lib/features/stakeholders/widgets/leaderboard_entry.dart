import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/avatar.dart';

class LeaderboardEntryWidget extends StatelessWidget {
  final StakeholderLeaderboardEntry entry;
  final bool isCurrentUser;

  const LeaderboardEntryWidget({
    super.key,
    required this.entry,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isCurrentUser ? AppColors.primary.withOpacity(0.1) : null,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: isCurrentUser ? Border.all(color: AppColors.primary) : null,
      ),
      child: InkWell(
        onTap: entry.userId != null
            ? () => context.go(Routes.stakeholderById(entry.userId!))
            : null,
        child: Row(
          children: [
            // Rank
            SizedBox(
              width: 40,
              child: Column(
                children: [
                  Text(
                    '#${entry.rank}',
                    style: AppTypography.h4.copyWith(
                      color: _getRankColor(entry.rank),
                    ),
                  ),
                  if (entry.rankChange != null && entry.rankChange != 0)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          entry.rankChange! > 0
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          size: 12,
                          color: entry.rankChange! > 0
                              ? AppColors.success
                              : AppColors.error,
                        ),
                        Text(
                          '${entry.rankChange!.abs()}',
                          style: AppTypography.labelSmall.copyWith(
                            color: entry.rankChange! > 0
                                ? AppColors.success
                                : AppColors.error,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),

            // Avatar + Name
            ZAvatar(name: entry.fullName, imageUrl: entry.avatarUrl, size: 36),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.fullName,
                    style: AppTypography.labelMedium,
                  ),
                  Text(
                    '${entry.respondedDecisions} responses',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Stats
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  entry.avgResponseTimeDisplay,
                  style: AppTypography.labelMedium.copyWith(
                    color: _getTimeColor(entry.avgResponseTimeMinutes),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 12,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      entry.slaComplianceDisplay,
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return AppColors.textPrimary;
    }
  }

  Color _getTimeColor(double minutes) {
    if (minutes < 30) return AppColors.success;
    if (minutes < 120) return AppColors.warning;
    return AppColors.error;
  }
}
