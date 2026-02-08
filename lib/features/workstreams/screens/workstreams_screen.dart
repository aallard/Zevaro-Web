import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/loading_indicator.dart';
import '../../../shared/widgets/common/error_view.dart';
import '../widgets/workstream_card.dart';
import '../widgets/create_workstream_dialog.dart';

class WorkstreamsScreen extends ConsumerWidget {
  const WorkstreamsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedProgramId = ref.watch(selectedProgramIdProvider);

    if (selectedProgramId == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.account_tree_outlined,
                size: 64, color: AppColors.textTertiary),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Select a program first',
              style:
                  AppTypography.h3.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Workstreams belong to a program.\nSelect a program from the sidebar to view its workstreams.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final workstreamsAsync =
        ref.watch(programWorkstreamsProvider(selectedProgramId));

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pagePaddingHorizontal,
            vertical: AppSpacing.md,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(
              bottom: BorderSide(color: AppColors.border),
            ),
          ),
          child: Row(
            children: [
              Text('Workstreams', style: AppTypography.h2),
              const Spacer(),
              FilledButton.icon(
                onPressed: () => _showCreateDialog(context, selectedProgramId),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New Workstream'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.sidebarAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Content
        Expanded(
          child: workstreamsAsync.when(
            data: (workstreams) {
              if (workstreams.isEmpty) {
                return _EmptyState(
                  onCreateWorkstream: () =>
                      _showCreateDialog(context, selectedProgramId),
                );
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 1200
                      ? 3
                      : constraints.maxWidth > 800
                          ? 2
                          : 1;

                  return GridView.builder(
                    padding: const EdgeInsets.all(
                        AppSpacing.pagePaddingHorizontal),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: AppSpacing.md,
                      mainAxisSpacing: AppSpacing.md,
                      childAspectRatio: 2.0,
                    ),
                    itemCount: workstreams.length,
                    itemBuilder: (context, index) =>
                        WorkstreamCard(workstream: workstreams[index]),
                  );
                },
              );
            },
            loading: () => const LoadingIndicator(
                message: 'Loading workstreams...'),
            error: (e, _) => ErrorView(
              message: e.toString(),
              onRetry: () => ref.invalidate(
                  programWorkstreamsProvider(selectedProgramId)),
            ),
          ),
        ),
      ],
    );
  }

  void _showCreateDialog(BuildContext context, String programId) {
    showDialog(
      context: context,
      builder: (context) => CreateWorkstreamDialog(programId: programId),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onCreateWorkstream;

  const _EmptyState({required this.onCreateWorkstream});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.account_tree_outlined,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No workstreams yet',
            style:
                AppTypography.h3.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Create a workstream to organize specifications\nand requirements for this program.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: onCreateWorkstream,
            icon: const Icon(Icons.add),
            label: const Text('Create Workstream'),
          ),
        ],
      ),
    );
  }
}
