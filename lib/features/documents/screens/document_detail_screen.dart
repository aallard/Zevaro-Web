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
import '../widgets/document_type_badge.dart';
import '../widgets/document_status_badge.dart';
import '../widgets/version_history_panel.dart';
import '../providers/documents_providers.dart';

class DocumentDetailScreen extends ConsumerWidget {
  final String id;

  const DocumentDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final docAsync = ref.watch(documentProvider(id));

    return docAsync.when(
      data: (doc) => _DetailContent(document: doc),
      loading: () =>
          const LoadingIndicator(message: 'Loading document...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () => ref.invalidate(documentProvider(id)),
      ),
    );
  }
}

class _DetailContent extends ConsumerStatefulWidget {
  final Document document;

  const _DetailContent({required this.document});

  @override
  ConsumerState<_DetailContent> createState() =>
      _DetailContentState();
}

class _DetailContentState extends ConsumerState<_DetailContent> {
  bool _showVersions = false;

  @override
  Widget build(BuildContext context) {
    final doc = widget.document;

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(
              AppSpacing.pagePaddingHorizontal),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(
              bottom: BorderSide(color: AppColors.border),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumb
              Row(
                children: [
                  if (doc.spaceName != null)
                    InkWell(
                      onTap: () =>
                          context.go(Routes.spaceById(doc.spaceId)),
                      child: Text(
                        doc.spaceName!,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  if (doc.parentDocumentTitle != null) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs),
                      child: Icon(Icons.chevron_right,
                          size: 16, color: AppColors.textTertiary),
                    ),
                    Text(
                      doc.parentDocumentTitle!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs),
                    child: Icon(Icons.chevron_right,
                        size: 16, color: AppColors.textTertiary),
                  ),
                  Text(
                    doc.title,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Title + badges + actions
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(doc.title, style: AppTypography.h2),
                        const SizedBox(height: AppSpacing.xs),
                        Wrap(
                          spacing: AppSpacing.xs,
                          children: [
                            DocumentTypeBadge(type: doc.type),
                            DocumentStatusBadge(status: doc.status),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.history),
                    onPressed: () =>
                        setState(() => _showVersions = !_showVersions),
                    tooltip: 'Version History',
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () =>
                        context.go(Routes.documentEdit(doc.id)),
                    tooltip: 'Edit',
                  ),
                  if (doc.status == DocumentStatus.DRAFT)
                    FilledButton(
                      onPressed: () => ref
                          .read(
                              documentWorkflowActionProvider.notifier)
                          .publish(doc.id),
                      child: const Text('Publish'),
                    ),
                  if (doc.status == DocumentStatus.PUBLISHED)
                    OutlinedButton(
                      onPressed: () => ref
                          .read(
                              documentWorkflowActionProvider.notifier)
                          .archive(doc.id),
                      child: const Text('Archive'),
                    ),
                ],
              ),
            ],
          ),
        ),

        // Body + optional version panel
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(
                      AppSpacing.pagePaddingHorizontal),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Meta
                      Wrap(
                        spacing: AppSpacing.lg,
                        children: [
                          if (doc.authorName != null)
                            Text(
                              'Author: ${doc.authorName!}',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                          Text(
                            'v${doc.version}',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Body content
                      if (doc.body != null)
                        SelectableText(
                          doc.body!,
                          style: AppTypography.bodyMedium.copyWith(
                            height: 1.6,
                          ),
                        )
                      else
                        Text(
                          'No content yet.',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textTertiary,
                            fontStyle: FontStyle.italic,
                          ),
                        ),

                      // Tags
                      if (doc.tags != null &&
                          doc.tags!.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xl),
                        Wrap(
                          spacing: AppSpacing.xs,
                          children: doc.tags!
                              .map((tag) => Chip(
                                    label: Text(tag),
                                    visualDensity:
                                        VisualDensity.compact,
                                  ))
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (_showVersions)
                VersionHistoryPanel(documentId: doc.id),
            ],
          ),
        ),
      ],
    );
  }
}
