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
import '../widgets/space_type_badge.dart';
import '../providers/spaces_providers.dart';
import '../../documents/widgets/document_tree.dart';
import '../../documents/widgets/document_status_badge.dart';
import '../../documents/widgets/create_document_dialog.dart';
import '../../documents/providers/documents_providers.dart';

class SpaceDetailScreen extends ConsumerWidget {
  final String id;

  const SpaceDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spaceAsync = ref.watch(spaceProvider(id));

    return spaceAsync.when(
      data: (space) => _SpaceDetailContent(space: space),
      loading: () =>
          const LoadingIndicator(message: 'Loading space...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () => ref.invalidate(spaceProvider(id)),
      ),
    );
  }
}

class _SpaceDetailContent extends ConsumerWidget {
  final Space space;

  const _SpaceDetailContent({required this.space});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDocId = ref.watch(selectedDocumentIdProvider);

    return Column(
      children: [
        // Header
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
              InkWell(
                onTap: () => context.go(Routes.spaces),
                child: Text(
                  'Spaces',
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
              if (space.icon != null) ...[
                Text(space.icon!,
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(width: AppSpacing.xs),
              ],
              Text(
                space.name,
                style: AppTypography.h3,
              ),
              const SizedBox(width: AppSpacing.sm),
              SpaceTypeBadge(type: space.type),
              const Spacer(),
              FilledButton.icon(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) =>
                      CreateDocumentDialog(spaceId: space.id),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New Page'),
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

        // Body: tree sidebar + content
        Expanded(
          child: Row(
            children: [
              // Document tree sidebar
              Container(
                width: 280,
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  border: Border(
                    right: BorderSide(color: AppColors.border),
                  ),
                ),
                child: DocumentTree(
                  spaceId: space.id,
                  selectedDocumentId: selectedDocId,
                  onSelectDocument: (id) => ref
                      .read(selectedDocumentIdProvider.notifier)
                      .select(id),
                ),
              ),

              // Content area
              Expanded(
                child: selectedDocId != null
                    ? _DocumentContent(documentId: selectedDocId)
                    : Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.article_outlined,
                                size: 48,
                                color: AppColors.textTertiary),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'Select a document from the tree',
                              style:
                                  AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Displays selected document content
class _DocumentContent extends ConsumerWidget {
  final String documentId;

  const _DocumentContent({required this.documentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final docAsync = ref.watch(documentProvider(documentId));

    return docAsync.when(
      data: (doc) => SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pagePaddingHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + status + actions
            Row(
              children: [
                Expanded(
                  child:
                      Text(doc.title, style: AppTypography.h2),
                ),
                DocumentStatusBadge(status: doc.status),
                const SizedBox(width: AppSpacing.sm),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () =>
                      context.go(Routes.documentEdit(doc.id)),
                  tooltip: 'Edit',
                ),
                // Workflow buttons
                if (doc.status == DocumentStatus.DRAFT)
                  FilledButton(
                    onPressed: () => ref
                        .read(documentWorkflowActionProvider.notifier)
                        .publish(doc.id),
                    child: const Text('Publish'),
                  ),
                if (doc.status == DocumentStatus.PUBLISHED)
                  OutlinedButton(
                    onPressed: () => ref
                        .read(documentWorkflowActionProvider.notifier)
                        .archive(doc.id),
                    child: const Text('Archive'),
                  ),
              ],
            ),

            // Meta
            const SizedBox(height: AppSpacing.sm),
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
                if (doc.lastEditedByName != null)
                  Text(
                    'Last edited by ${doc.lastEditedByName!}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // Body
            if (doc.body != null)
              SelectableText(
                doc.body!,
                style: AppTypography.bodyMedium.copyWith(
                  height: 1.6,
                ),
              )
            else
              Text(
                'No content yet. Click Edit to add content.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
      loading: () =>
          const LoadingIndicator(message: 'Loading document...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () => ref.invalidate(documentProvider(documentId)),
      ),
    );
  }
}
