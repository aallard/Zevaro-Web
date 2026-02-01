import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/avatar.dart';

class TeamMemberCard extends StatelessWidget {
  final TeamMember member;
  final VoidCallback? onChangeRole;
  final VoidCallback? onRemove;

  const TeamMemberCard({
    super.key,
    required this.member,
    this.onChangeRole,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        children: [
          ZAvatar(
            name: member.userFullName,
            imageUrl: member.userAvatarUrl,
            size: 40,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.userFullName,
                  style: AppTypography.labelMedium,
                ),
                Text(
                  member.user.title ?? '',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xxs,
            ),
            decoration: BoxDecoration(
              color: _getRoleColor(member.teamRole).withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
            child: Text(
              member.teamRole.displayName,
              style: AppTypography.labelSmall.copyWith(
                color: _getRoleColor(member.teamRole),
              ),
            ),
          ),
          if (onChangeRole != null || onRemove != null)
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: AppColors.textSecondary),
              onSelected: (value) {
                if (value == 'role') onChangeRole?.call();
                if (value == 'remove') onRemove?.call();
              },
              itemBuilder: (context) => [
                if (onChangeRole != null)
                  const PopupMenuItem(
                    value: 'role',
                    child: Row(
                      children: [
                        Icon(Icons.swap_horiz, size: 18),
                        SizedBox(width: 8),
                        Text('Change Role'),
                      ],
                    ),
                  ),
                if (onRemove != null)
                  PopupMenuItem(
                    value: 'remove',
                    child: Row(
                      children: [
                        Icon(Icons.person_remove, size: 18, color: AppColors.error),
                        const SizedBox(width: 8),
                        Text('Remove', style: TextStyle(color: AppColors.error)),
                      ],
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Color _getRoleColor(TeamMemberRole role) {
    switch (role) {
      case TeamMemberRole.OWNER:
        return AppColors.error;
      case TeamMemberRole.LEAD:
        return AppColors.warning;
      case TeamMemberRole.MEMBER:
        return AppColors.primary;
    }
  }
}
