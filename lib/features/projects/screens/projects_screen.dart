import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/loading_indicator.dart';
import '../../../shared/widgets/common/error_view.dart';
import '../providers/projects_providers.dart';
import '../widgets/project_card.dart';
import '../widgets/project_list_view.dart';
import '../widgets/create_project_dialog.dart';
import '../widgets/project_filters_bar.dart';

class ProjectsScreen extends ConsumerWidget {
  final String? projectId;

  const ProjectsScreen({super.key, this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewMode = ref.watch(projectViewModeNotifierProvider);
    final projectsAsync = ref.watch(filteredProjectsProvider);

    return Column(
      children: [
        // Toolbar
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pagePaddingHorizontal,
            vertical: AppSpacing.sm,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(
              bottom: BorderSide(color: AppColors.border),
            ),
          ),
          child: Row(
            children: [
              // Search and filters
              const Expanded(child: ProjectFiltersBar()),

              const SizedBox(width: AppSpacing.md),

              // View toggle
              SegmentedButton<ProjectViewMode>(
                segments: const [
                  ButtonSegment(
                    value: ProjectViewMode.card,
                    icon: Icon(Icons.grid_view_rounded, size: 18),
                  ),
                  ButtonSegment(
                    value: ProjectViewMode.list,
                    icon: Icon(Icons.view_list, size: 18),
                  ),
                ],
                selected: {viewMode},
                onSelectionChanged: (selected) {
                  ref
                      .read(projectViewModeNotifierProvider.notifier)
                      .toggle();
                },
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                ),
              ),

              const SizedBox(width: AppSpacing.md),

              // New project button
              FilledButton.icon(
                onPressed: () => _showCreateDialog(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New Project'),
              ),
            ],
          ),
        ),

        // Content
        Expanded(
          child: projectsAsync.when(
            data: (projects) {
              if (projects.isEmpty) {
                return _EmptyState(
                  onCreateProject: () => _showCreateDialog(context),
                );
              }

              return viewMode == ProjectViewMode.card
                  ? _ProjectCardGrid(projects: projects)
                  : ProjectListView(projects: projects);
            },
            loading: () =>
                const LoadingIndicator(message: 'Loading projects...'),
            error: (e, _) => ErrorView(
              message: e.toString(),
              onRetry: () => ref.invalidate(filteredProjectsProvider),
            ),
          ),
        ),
      ],
    );
  }

  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreateProjectDialog(),
    );
  }
}

class _ProjectCardGrid extends StatelessWidget {
  final List<Project> projects;

  const _ProjectCardGrid({required this.projects});

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
          itemCount: projects.length,
          itemBuilder: (context, index) =>
              ProjectCard(project: projects[index]),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onCreateProject;

  const _EmptyState({required this.onCreateProject});

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
            'No projects yet',
            style: AppTypography.h3.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Create your first project to start organizing\nyour outcomes, hypotheses, and decisions.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: onCreateProject,
            icon: const Icon(Icons.add),
            label: const Text('Create Project'),
          ),
        ],
      ),
    );
  }
}
