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
import '../providers/documents_providers.dart';

class DocumentEditorScreen extends ConsumerStatefulWidget {
  final String id;

  const DocumentEditorScreen({super.key, required this.id});

  @override
  ConsumerState<DocumentEditorScreen> createState() =>
      _DocumentEditorScreenState();
}

class _DocumentEditorScreenState
    extends ConsumerState<DocumentEditorScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _initFromDocument(Document doc) {
    if (!_initialized) {
      _titleController.text = doc.title;
      _bodyController.text = doc.body ?? '';
      _initialized = true;
    }
  }

  Future<void> _save() async {
    final result =
        await ref.read(updateDocumentActionProvider.notifier).save(
              widget.id,
              UpdateDocumentRequest(
                title: _titleController.text.trim(),
                body: _bodyController.text.trim().isEmpty
                    ? null
                    : _bodyController.text.trim(),
              ),
            );

    if (result != null && mounted) {
      context.go(Routes.documentById(widget.id));
    }
  }

  Future<void> _saveAndPublish() async {
    final updated =
        await ref.read(updateDocumentActionProvider.notifier).save(
              widget.id,
              UpdateDocumentRequest(
                title: _titleController.text.trim(),
                body: _bodyController.text.trim().isEmpty
                    ? null
                    : _bodyController.text.trim(),
              ),
            );

    if (updated != null) {
      await ref
          .read(documentWorkflowActionProvider.notifier)
          .publish(widget.id);

      if (mounted) {
        context.go(Routes.documentById(widget.id));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final docAsync = ref.watch(documentProvider(widget.id));
    final updateState = ref.watch(updateDocumentActionProvider);
    final isLoading = updateState.isLoading;

    return docAsync.when(
      data: (doc) {
        _initFromDocument(doc);

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
                  TextButton.icon(
                    onPressed: () =>
                        context.go(Routes.documentById(widget.id)),
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: const Text('Back'),
                  ),
                  const Spacer(),
                  if (updateState.hasError)
                    Padding(
                      padding: const EdgeInsets.only(
                          right: AppSpacing.sm),
                      child: Text(
                        updateState.error.toString(),
                        style: TextStyle(
                            color: AppColors.error, fontSize: 12),
                      ),
                    ),
                  OutlinedButton(
                    onPressed: isLoading ? null : _save,
                    child: const Text('Save Draft'),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  FilledButton(
                    onPressed: isLoading ? null : _saveAndPublish,
                    child: const Text('Save & Publish'),
                  ),
                ],
              ),
            ),

            // Editor
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(
                    AppSpacing.pagePaddingHorizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    TextField(
                      controller: _titleController,
                      style: AppTypography.h2,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Document Title',
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: AppSpacing.md),

                    // Body
                    TextField(
                      controller: _bodyController,
                      maxLines: null,
                      minLines: 20,
                      style: AppTypography.bodyMedium.copyWith(
                        fontFamily: 'monospace',
                        height: 1.6,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Start writing...',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      loading: () =>
          const LoadingIndicator(message: 'Loading document...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () =>
            ref.invalidate(documentProvider(widget.id)),
      ),
    );
  }
}
