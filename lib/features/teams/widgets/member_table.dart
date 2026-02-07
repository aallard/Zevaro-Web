import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/avatar.dart';
import '../../../shared/widgets/common/loading_indicator.dart';
import '../../../shared/widgets/common/error_view.dart';
import '../providers/teams_providers.dart';

class MemberTable extends ConsumerWidget {
  const MemberTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(teamMembersWithStatsProvider);

    return membersAsync.when(
      data: (members) {
        if (members.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.groups_outlined, size: 64,
                    color: AppColors.textTertiary),
                const SizedBox(height: AppSpacing.md),
                Text('No team members yet',
                    style: AppTypography.h3
                        .copyWith(color: AppColors.textSecondary)),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pagePaddingHorizontal),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.cardPadding,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppSpacing.radiusLg),
                      topRight: Radius.circular(AppSpacing.radiusLg),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text('Team Members',
                            style: AppTypography.labelMedium),
                      ),
                      SizedBox(
                        width: 100,
                        child: Text('Role',
                            style: AppTypography.labelMedium,
                            textAlign: TextAlign.center),
                      ),
                      SizedBox(
                        width: 120,
                        child: Text('Pending Decisions',
                            style: AppTypography.labelMedium,
                            textAlign: TextAlign.center),
                      ),
                      SizedBox(
                        width: 120,
                        child: Text('Response Time',
                            style: AppTypography.labelMedium,
                            textAlign: TextAlign.center),
                      ),
                    ],
                  ),
                ),
                // Build rows from member data
                ...members.map((member) => _MemberRow(member: member)),
              ],
            ),
          ),
        );
      },
      loading: () => const LoadingIndicator(message: 'Loading team members...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () => ref.invalidate(teamMembersWithStatsProvider),
      ),
    );
  }
}

class _MemberRow extends StatelessWidget {
  final TeamMember member;

  const _MemberRow({required this.member});

  Color _getRoleColor(TeamMemberRole role) {
    switch (role) {
      case TeamMemberRole.LEAD:
        return AppColors.primary;
      case TeamMemberRole.OWNER:
        return AppColors.secondary;
      case TeamMemberRole.MEMBER:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final memberName = member.user.fullName ?? 'Unknown User';
    final memberEmail = member.user.title ?? '';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.cardPadding,
        vertical: AppSpacing.md,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.borderLight),
        ),
      ),
      child: Row(
        children: [
          // Avatar + name + email
          Expanded(
            flex: 2,
            child: Row(
              children: [
                ZAvatar(
                  name: memberName,
                  imageUrl: member.user.avatarUrl,
                  size: 40,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        memberName,
                        style: AppTypography.labelLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (memberEmail.isNotEmpty)
                        Text(
                          memberEmail,
                          style: AppTypography.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Role badge
          SizedBox(
            width: 100,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getRoleColor(member.teamRole).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
                child: Text(
                  member.teamRole.displayName,
                  style: AppTypography.labelSmall.copyWith(
                    color: _getRoleColor(member.teamRole),
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                ),
              ),
            ),
          ),
          // Pending decisions
          SizedBox(
            width: 120,
            child: Center(
              child: Text(
                '0 decisions pending',
                style: AppTypography.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Response time
          SizedBox(
            width: 120,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.timer_outlined,
                      size: 14, color: AppColors.textTertiary),
                  const SizedBox(width: 4),
                  Text(
                    'N/A',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
