import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../widgets/create_team_dialog.dart';
import '../widgets/team_list.dart';

class TeamsScreen extends ConsumerWidget {
  const TeamsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Toolbar
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              const Spacer(),
              FilledButton.icon(
                onPressed: () => showCreateTeamDialog(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New Team'),
              ),
            ],
          ),
        ),

        // Content
        const Expanded(child: TeamListWidget()),
      ],
    );
  }
}
