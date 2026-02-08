import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../spaces/providers/spaces_providers.dart';
import '../providers/documents_providers.dart';

class CreateDocumentDialog extends ConsumerStatefulWidget {
  final String spaceId;
  final String? parentDocumentId;

  const CreateDocumentDialog({
    super.key,
    required this.spaceId,
    this.parentDocumentId,
  });

  @override
  ConsumerState<CreateDocumentDialog> createState() =>
      _CreateDocumentDialogState();
}

class _CreateDocumentDialogState
    extends ConsumerState<CreateDocumentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  DocumentType _type = DocumentType.PAGE;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final document =
        await ref.read(createDocumentActionProvider.notifier).create(
              CreateDocumentRequest(
                spaceId: widget.spaceId,
                parentDocumentId: widget.parentDocumentId,
                title: _titleController.text.trim(),
                body: _bodyController.text.trim().isEmpty
                    ? null
                    : _bodyController.text.trim(),
                type: _type,
              ),
            );

    if (document != null && mounted) {
      // Select the new document in the tree
      ref
          .read(selectedDocumentIdProvider.notifier)
          .select(document.id);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final createState = ref.watch(createDocumentActionProvider);
    final isLoading = createState.isLoading;

    return AlertDialog(
      title: Text(widget.parentDocumentId != null
          ? 'Create Child Page'
          : 'Create Document'),
      content: SizedBox(
        width: 480,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'e.g., Getting Started Guide',
                ),
                autofocus: true,
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Title is required'
                    : null,
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<DocumentType>(
                value: _type,
                decoration:
                    const InputDecoration(labelText: 'Type'),
                items: DocumentType.values.map((t) {
                  return DropdownMenuItem(
                    value: t,
                    child: Text(_typeLabel(t)),
                  );
                }).toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _type = v);
                },
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(
                  labelText: 'Content (optional)',
                  hintText: 'Start writing...',
                ),
                maxLines: 5,
              ),
              if (createState.hasError) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  createState.error.toString(),
                  style:
                      TextStyle(color: AppColors.error, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: isLoading ? null : _submit,
          child: isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Create'),
        ),
      ],
    );
  }

  String _typeLabel(DocumentType type) {
    switch (type) {
      case DocumentType.PAGE:
        return 'Page';
      case DocumentType.SPECIFICATION:
        return 'Specification';
      case DocumentType.TEMPLATE:
        return 'Template';
      case DocumentType.MEETING_NOTES:
        return 'Meeting Notes';
      case DocumentType.DECISION_RECORD:
        return 'Decision Record';
      case DocumentType.RFC:
        return 'RFC';
      case DocumentType.RUNBOOK:
        return 'Runbook';
    }
  }
}
