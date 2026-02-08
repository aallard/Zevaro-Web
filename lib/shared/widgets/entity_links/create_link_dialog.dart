import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../providers/entity_link_action_providers.dart';
import '../../utils/entity_navigation.dart';

class CreateLinkDialog extends ConsumerStatefulWidget {
  final EntityType sourceType;
  final String sourceId;

  const CreateLinkDialog({
    super.key,
    required this.sourceType,
    required this.sourceId,
  });

  @override
  ConsumerState<CreateLinkDialog> createState() =>
      _CreateLinkDialogState();
}

class _CreateLinkDialogState extends ConsumerState<CreateLinkDialog> {
  final _formKey = GlobalKey<FormState>();
  final _targetIdController = TextEditingController();
  EntityType _targetType = EntityType.SPECIFICATION;
  LinkType _linkType = LinkType.RELATES_TO;

  @override
  void dispose() {
    _targetIdController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final link =
        await ref.read(entityLinkActionsProvider.notifier).create(
              CreateEntityLinkRequest(
                sourceType: widget.sourceType,
                sourceId: widget.sourceId,
                targetType: _targetType,
                targetId: _targetIdController.text.trim(),
                linkType: _linkType,
              ),
            );

    if (link != null && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final actionState = ref.watch(entityLinkActionsProvider);
    final isLoading = actionState.isLoading;

    return AlertDialog(
      title: const Text('Add Link'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<EntityType>(
                value: _targetType,
                decoration: const InputDecoration(
                    labelText: 'Target Entity Type'),
                items: EntityType.values.map((t) {
                  return DropdownMenuItem(
                    value: t,
                    child: Text(entityTypeLabel(t)),
                  );
                }).toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _targetType = v);
                },
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _targetIdController,
                decoration: const InputDecoration(
                  labelText: 'Target Entity ID',
                  hintText: 'Paste the entity ID...',
                ),
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Required'
                    : null,
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<LinkType>(
                value: _linkType,
                decoration:
                    const InputDecoration(labelText: 'Link Type'),
                items: LinkType.values.map((t) {
                  return DropdownMenuItem(
                    value: t,
                    child: Text(linkTypeLabel(t)),
                  );
                }).toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _linkType = v);
                },
              ),
              if (actionState.hasError) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  actionState.error.toString(),
                  style: TextStyle(
                      color: AppColors.error, fontSize: 12),
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
              : const Text('Create Link'),
        ),
      ],
    );
  }
}
