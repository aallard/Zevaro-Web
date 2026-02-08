import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/loading_indicator.dart';
import '../../../shared/widgets/common/error_view.dart';
import '../widgets/requirement_status_badge.dart';
import '../widgets/requirement_priority_badge.dart';

class RequirementDetailScreen extends ConsumerStatefulWidget {
  final String id;

  const RequirementDetailScreen({super.key, required this.id});

  @override
  ConsumerState<RequirementDetailScreen> createState() =>
      _RequirementDetailScreenState();
}

class _RequirementDetailScreenState
    extends ConsumerState<RequirementDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reqAsync = ref.watch(requirementProvider(widget.id));

    return reqAsync.when(
      data: (req) => _DetailContent(
        requirement: req,
        tabController: _tabController,
      ),
      loading: () =>
          const LoadingIndicator(message: 'Loading requirement...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () =>
            ref.invalidate(requirementProvider(widget.id)),
      ),
    );
  }
}

class _DetailContent extends ConsumerWidget {
  final Requirement requirement;
  final TabController tabController;

  const _DetailContent({
    required this.requirement,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(AppSpacing.pagePaddingHorizontal),
          decoration: const BoxDecoration(
            color: AppColors.surface,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumb
              Row(
                children: [
                  InkWell(
                    onTap: () => context.go(Routes.specificationById(
                        requirement.specificationId)),
                    child: Text(
                      requirement.specificationName ?? 'Specification',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs),
                    child: Icon(Icons.chevron_right,
                        size: 16, color: AppColors.textTertiary),
                  ),
                  Text(
                    requirement.identifier,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Identifier + Title
              Row(
                children: [
                  Text(
                    requirement.identifier,
                    style: AppTypography.h3.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(requirement.title,
                        style: AppTypography.h2),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              // Badges row
              Row(
                children: [
                  RequirementStatusBadge(status: requirement.status),
                  const SizedBox(width: AppSpacing.xs),
                  RequirementPriorityBadge(
                      priority: requirement.priority),
                  const SizedBox(width: AppSpacing.xs),
                  _TypeBadge(type: requirement.type),
                ],
              ),

              if (requirement.description != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  requirement.description!,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),

        // Tabs
        Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(
              bottom: BorderSide(color: AppColors.border),
            ),
          ),
          child: TabBar(
            controller: tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            tabs: const [
              Tab(text: 'Details'),
              Tab(text: 'Dependencies'),
            ],
          ),
        ),

        // Tab content
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              _DetailsTab(requirement: requirement),
              _DependenciesTab(requirementId: requirement.id),
            ],
          ),
        ),
      ],
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final RequirementType type;

  const _TypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        _label,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String get _label {
    switch (type) {
      case RequirementType.FUNCTIONAL:
        return 'Functional';
      case RequirementType.NON_FUNCTIONAL:
        return 'Non-Functional';
      case RequirementType.CONSTRAINT:
        return 'Constraint';
      case RequirementType.INTERFACE:
        return 'Interface';
    }
  }
}

/// Details tab
class _DetailsTab extends StatelessWidget {
  final Requirement requirement;

  const _DetailsTab({required this.requirement});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.pagePaddingHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (requirement.acceptanceCriteria != null) ...[
            Text('Acceptance Criteria', style: AppTypography.h3),
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius:
                    BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                requirement.acceptanceCriteria!,
                style: AppTypography.bodyMedium,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],

          Text('Details', style: AppTypography.h3),
          const SizedBox(height: AppSpacing.md),
          _DetailRow(
              label: 'Type', value: requirement.type.name),
          _DetailRow(
              label: 'Priority', value: requirement.priority.name),
          _DetailRow(
              label: 'Status', value: requirement.status.name),
          if (requirement.estimatedHours != null)
            _DetailRow(
              label: 'Estimated Hours',
              value:
                  '${requirement.estimatedHours!.toStringAsFixed(1)}h',
            ),
          if (requirement.actualHours != null)
            _DetailRow(
              label: 'Actual Hours',
              value:
                  '${requirement.actualHours!.toStringAsFixed(1)}h',
            ),
          if (requirement.createdAt != null)
            _DetailRow(
              label: 'Created',
              value: _formatDate(requirement.createdAt!),
            ),
          if (requirement.updatedAt != null)
            _DetailRow(
              label: 'Updated',
              value: _formatDate(requirement.updatedAt!),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

/// Dependencies tab
class _DependenciesTab extends ConsumerWidget {
  final String requirementId;

  const _DependenciesTab({required this.requirementId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final depsAsync =
        ref.watch(requirementDependenciesProvider(requirementId));

    return depsAsync.when(
      data: (deps) {
        if (deps.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.link_off,
                    size: 48, color: AppColors.textTertiary),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'No dependencies',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding:
              const EdgeInsets.all(AppSpacing.pagePaddingHorizontal),
          itemCount: deps.length,
          itemBuilder: (context, index) {
            final dep = deps[index];
            return _DependencyRow(dependency: dep);
          },
        );
      },
      loading: () =>
          const LoadingIndicator(message: 'Loading dependencies...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () => ref.invalidate(
            requirementDependenciesProvider(requirementId)),
      ),
    );
  }
}

class _DependencyRow extends StatelessWidget {
  final RequirementDependency dependency;

  const _DependencyRow({required this.dependency});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(
            _dependencyIcon(dependency.type),
            size: 16,
            color: _dependencyColor(dependency.type),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            _dependencyLabel(dependency.type),
            style: AppTypography.labelSmall.copyWith(
              color: _dependencyColor(dependency.type),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          if (dependency.dependsOnIdentifier != null)
            Text(
              dependency.dependsOnIdentifier!,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              dependency.dependsOnTitle ?? '',
              style: AppTypography.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  IconData _dependencyIcon(DependencyType type) {
    switch (type) {
      case DependencyType.BLOCKS:
        return Icons.block;
      case DependencyType.REQUIRES:
        return Icons.arrow_forward;
      case DependencyType.RELATES_TO:
        return Icons.link;
    }
  }

  Color _dependencyColor(DependencyType type) {
    switch (type) {
      case DependencyType.BLOCKS:
        return AppColors.error;
      case DependencyType.REQUIRES:
        return AppColors.warning;
      case DependencyType.RELATES_TO:
        return AppColors.textSecondary;
    }
  }

  String _dependencyLabel(DependencyType type) {
    switch (type) {
      case DependencyType.BLOCKS:
        return 'Blocks';
      case DependencyType.REQUIRES:
        return 'Requires';
      case DependencyType.RELATES_TO:
        return 'Relates to';
    }
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
