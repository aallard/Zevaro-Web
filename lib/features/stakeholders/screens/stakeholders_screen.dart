import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/constants/app_constants.dart';
import '../widgets/stakeholder_leaderboard.dart';
import '../widgets/slow_responders_card.dart';

class StakeholdersScreen extends ConsumerWidget {
  const StakeholdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > AppConstants.tabletBreakpoint;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Expanded(flex: 2, child: StakeholderLeaderboard()),
                SizedBox(width: AppSpacing.lg),
                Expanded(flex: 1, child: SlowRespondersCard()),
              ],
            )
          : const Column(
              children: [
                StakeholderLeaderboard(),
                SizedBox(height: AppSpacing.lg),
                SlowRespondersCard(),
              ],
            ),
    );
  }
}
