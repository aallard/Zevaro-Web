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

class WorkloadMatrix extends ConsumerWidget {
  const WorkloadMatrix({super.key});

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
                Icon(Icons.assessment_outlined, size: 64,
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
                        child: Text('Member',
                            style: AppTypography.labelMedium),
                      ),
                      SizedBox(
                        width: 100,
                        child: Text('Draft',
                            style: AppTypography.labelMedium,
                            textAlign: TextAlign.center),
                      ),
                      SizedBox(
                        width: 100,
                        child: Text('Ready',
                            style: AppTypography.labelMedium,
                            textAlign: TextAlign.center),
                      ),
                      SizedBox(
                        width: 100,
                        child: Text('Building',
                            style: AppTypography.labelMedium,
                            textAlign: TextAlign.center),
                      ),
                      SizedBox(
                        width: 100,
                        child: Text('Measuring',
                            style: AppTypography.labelMedium,
                            textAlign: TextAlign.center),
                      ),
                    ],
                  ),
                ),
                // Build rows from member data
                ...members.map((member) => _WorkloadRow(member: member)),
              ],
            ),
          ),
        );
      },
      loading: () => const LoadingIndicator(message: 'Loading workload...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () => ref.invalidate(teamMembersWithStatsProvider),
      ),
    );
  }
}

class _WorkloadRow extends StatelessWidget {
  final TeamMember member;

  const _WorkloadRow({required this.member});

  @override
  Widget build(BuildContext context) {
    final memberName = member.user.fullName ?? 'Unknown User';

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
          // Member info
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
                  child: Text(
                    memberName,
                    style: AppTypography.labelLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // Draft count
          SizedBox(
            width: 100,
            child: Center(
              child: Text(
                '0',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Ready count
          SizedBox(
            width: 100,
            child: Center(
              child: Text(
                '0',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Building count
          SizedBox(
            width: 100,
            child: Center(
              child: Text(
                '0',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Measuring count
          SizedBox(
            width: 100,
            child: Center(
              child: Text(
                '0',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
