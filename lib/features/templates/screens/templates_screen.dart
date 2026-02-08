import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/common/loading_indicator.dart';
import '../../../shared/widgets/common/error_view.dart';
import '../providers/templates_providers.dart';
import '../widgets/apply_template_dialog.dart';
import '../widgets/create_template_dialog.dart';

class TemplatesScreen extends ConsumerWidget {
  const TemplatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesAsync = ref.watch(programTemplatesProvider);

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
              Text('Program Templates', style: AppTypography.h2),
              const Spacer(),
              FilledButton.icon(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const CreateTemplateDialog(),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New Template'),
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

        // Content
        Expanded(
          child: templatesAsync.when(
            data: (templates) {
              if (templates.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.dashboard_customize_outlined,
                          size: 64, color: AppColors.textTertiary),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'No templates yet',
                        style: AppTypography.h3
                            .copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Create reusable program templates\nto speed up program creation.',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textTertiary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
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
                    padding:
                        const EdgeInsets.all(AppSpacing.pagePaddingHorizontal),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: AppSpacing.md,
                      mainAxisSpacing: AppSpacing.md,
                      childAspectRatio: 1.8,
                    ),
                    itemCount: templates.length,
                    itemBuilder: (context, index) =>
                        _TemplateCard(template: templates[index]),
                  );
                },
              );
            },
            loading: () =>
                const LoadingIndicator(message: 'Loading templates...'),
            error: (e, _) => ErrorView(
              message: e.toString(),
              onRetry: () => ref.invalidate(programTemplatesProvider),
            ),
          ),
        ),
      ],
    );
  }
}

class _TemplateCard extends ConsumerWidget {
  final ProgramTemplate template;

  const _TemplateCard({required this.template});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.dashboard_customize,
                  size: 20, color: AppColors.primary),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  template.name,
                  style: AppTypography.h4,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (template.isSystem)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Text(
                    'System',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.info,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          if (template.description != null)
            Expanded(
              child: Text(
                template.description!,
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.textSecondary),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            )
          else
            const Spacer(),
          const Divider(),
          Row(
            children: [
              // Apply button
              FilledButton.icon(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => ApplyTemplateDialog(template: template),
                ),
                icon: const Icon(Icons.play_arrow, size: 16),
                label: const Text('Use Template'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xxs,
                  ),
                  textStyle: AppTypography.labelSmall,
                ),
              ),
              const Spacer(),
              if (!template.isSystem)
                IconButton(
                  icon: const Icon(Icons.delete_outline,
                      size: 18, color: AppColors.error),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Delete Template'),
                        content: Text(
                            'Delete "${template.name}"? This cannot be undone.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.error,
                            ),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      ref
                          .read(templateActionsProvider.notifier)
                          .deleteTemplate(template.id);
                    }
                  },
                  tooltip: 'Delete',
                ),
            ],
          ),
        ],
      ),
    );
  }
}
