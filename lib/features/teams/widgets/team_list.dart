import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/common/loading_indicator.dart';
import '../../../shared/widgets/common/error_view.dart';
import '../providers/teams_providers.dart';
import 'team_card.dart';

class TeamListWidget extends ConsumerWidget {
  const TeamListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamsAsync = ref.watch(teamsListProvider);

    return teamsAsync.when(
      data: (teams) {
        if (teams.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.groups_outlined,
                    size: 64, color: AppColors.textTertiary),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'No teams found',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: teams.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) => TeamCard(team: teams[index]),
        );
      },
      loading: () => const LoadingIndicator(message: 'Loading teams...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () => ref.invalidate(teamsListProvider),
      ),
    );
  }
}
