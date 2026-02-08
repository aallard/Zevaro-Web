import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/loading_indicator.dart';
import '../../../shared/widgets/common/error_view.dart';
import '../providers/programs_providers.dart';
import '../widgets/program_card.dart';
import '../widgets/program_list_view.dart';
import '../widgets/create_program_dialog.dart';
import '../widgets/program_filters_bar.dart';

class ProgramsScreen extends ConsumerWidget {
  final String? programId;

  const ProgramsScreen({super.key, this.programId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewMode = ref.watch(programViewModeNotifierProvider);
    final programsAsync = ref.watch(filteredProgramsProvider);

    return Column(
      children: [
        // ── Row 1: Title + Search + View Toggle + New Program ──
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pagePaddingHorizontal,
            vertical: AppSpacing.md,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
          ),
          child: Row(
            children: [
              // Title
              Text(
                'Programs',
                style: AppTypography.h2,
              ),

              const Spacer(),

              // Search field
              SizedBox(
                width: 220,
                height: 40,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: AppTypography.bodySmall,
                    prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.textTertiary),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                  onChanged: (value) {
                    ref.read(programFiltersProvider.notifier).setSearch(
                          value.isEmpty ? null : value,
                        );
                  },
                ),
              ),

              const SizedBox(width: AppSpacing.md),

              // View toggle – plain icon buttons
              _ViewToggleButton(
                icon: Icons.view_list_rounded,
                isActive: viewMode == ProgramViewMode.list,
                onTap: () => ref.read(programViewModeNotifierProvider.notifier).setList(),
              ),
              const SizedBox(width: AppSpacing.xxs),
              _ViewToggleButton(
                icon: Icons.grid_view_rounded,
                isActive: viewMode == ProgramViewMode.card,
                onTap: () => ref.read(programViewModeNotifierProvider.notifier).setCard(),
              ),

              const SizedBox(width: AppSpacing.md),

              // New program button
              FilledButton.icon(
                onPressed: () => _showCreateDialog(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New Program'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.sidebarAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Row 2: Filter pills + Sort ──
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pagePaddingHorizontal,
            vertical: AppSpacing.xs,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(
              bottom: BorderSide(color: AppColors.border),
            ),
          ),
          child: Row(
            children: [
              // Filter pills (no search – search is in row 1 now)
              const ProgramFiltersBar(),

              const SizedBox(width: AppSpacing.sm),

              // "Sort." dropdown (inline with pills)
              PopupMenuButton<String>(
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'name', child: Text('Name')),
                  const PopupMenuItem(value: 'status', child: Text('Status')),
                  const PopupMenuItem(value: 'recent', child: Text('Recent')),
                ],
                onSelected: (value) {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Sort.',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xxs),
                      const Icon(Icons.expand_more, size: 16, color: AppColors.textSecondary),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // "Sort: Recent" dropdown on far right
              PopupMenuButton<String>(
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'recent', child: Text('Recent')),
                  const PopupMenuItem(value: 'name', child: Text('Name')),
                  const PopupMenuItem(value: 'status', child: Text('Status')),
                ],
                onSelected: (value) {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Sort: Recent',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xxs),
                      const Icon(Icons.expand_more, size: 16, color: AppColors.textSecondary),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Content ──
        Expanded(
          child: programsAsync.when(
            data: (programs) {
              if (programs.isEmpty) {
                return _EmptyState(
                  onCreateProgram: () => _showCreateDialog(context),
                );
              }

              return viewMode == ProgramViewMode.card
                  ? _ProgramCardGrid(programs: programs)
                  : ProgramListView(programs: programs);
            },
            loading: () =>
                const LoadingIndicator(message: 'Loading programs...'),
            error: (e, _) => ErrorView(
              message: e.toString(),
              onRetry: () => ref.invalidate(filteredProgramsProvider),
            ),
          ),
        ),
      ],
    );
  }

  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreateProgramDialog(),
    );
  }
}

/// Plain icon button for list/grid toggle
class _ViewToggleButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _ViewToggleButton({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isActive ? AppColors.primary : AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _ProgramCardGrid extends StatelessWidget {
  final List<Program> programs;

  const _ProgramCardGrid({required this.programs});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1200
            ? 3
            : constraints.maxWidth > 800
                ? 2
                : 1;

        return GridView.builder(
          padding: const EdgeInsets.all(AppSpacing.pagePaddingHorizontal),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: 1.6,
          ),
          itemCount: programs.length,
          itemBuilder: (context, index) =>
              ProgramCard(program: programs[index]),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onCreateProgram;

  const _EmptyState({required this.onCreateProgram});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.folder_outlined,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No programs yet',
            style: AppTypography.h3.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Create your first program to start organizing\nyour outcomes, hypotheses, and decisions.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: onCreateProgram,
            icon: const Icon(Icons.add),
            label: const Text('Create Program'),
          ),
        ],
      ),
    );
  }
}
