import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../providers/spaces_providers.dart';

class CreateSpaceDialog extends ConsumerStatefulWidget {
  const CreateSpaceDialog({super.key});

  @override
  ConsumerState<CreateSpaceDialog> createState() =>
      _CreateSpaceDialogState();
}

class _CreateSpaceDialogState extends ConsumerState<CreateSpaceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  SpaceType _type = SpaceType.TEAM;
  SpaceVisibility _visibility = SpaceVisibility.PUBLIC;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final space =
        await ref.read(createSpaceActionProvider.notifier).create(
              CreateSpaceRequest(
                name: _nameController.text.trim(),
                description: _descriptionController.text.trim().isEmpty
                    ? null
                    : _descriptionController.text.trim(),
                type: _type,
                visibility: _visibility,
              ),
            );

    if (space != null && mounted) {
      Navigator.pop(context);
      context.go(Routes.spaceById(space.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final createState = ref.watch(createSpaceActionProvider);
    final isLoading = createState.isLoading;

    return AlertDialog(
      title: const Text('Create Space'),
      content: SizedBox(
        width: 480,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Space Name',
                  hintText: 'e.g., Engineering Wiki',
                ),
                autofocus: true,
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Name is required'
                    : null,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'What is this space for?',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<SpaceType>(
                      value: _type,
                      decoration:
                          const InputDecoration(labelText: 'Type'),
                      items: [SpaceType.TEAM, SpaceType.GLOBAL]
                          .map((t) {
                        return DropdownMenuItem(
                          value: t,
                          child: Text(_typeLabel(t)),
                        );
                      }).toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _type = v);
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: DropdownButtonFormField<SpaceVisibility>(
                      value: _visibility,
                      decoration: const InputDecoration(
                          labelText: 'Visibility'),
                      items: SpaceVisibility.values.map((v) {
                        return DropdownMenuItem(
                          value: v,
                          child: Text(_visibilityLabel(v)),
                        );
                      }).toList(),
                      onChanged: (v) {
                        if (v != null)
                            setState(() => _visibility = v);
                      },
                    ),
                  ),
                ],
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

  String _typeLabel(SpaceType type) {
    switch (type) {
      case SpaceType.PROGRAM:
        return 'Program';
      case SpaceType.TEAM:
        return 'Team';
      case SpaceType.PERSONAL:
        return 'Personal';
      case SpaceType.GLOBAL:
        return 'Global';
    }
  }

  String _visibilityLabel(SpaceVisibility visibility) {
    switch (visibility) {
      case SpaceVisibility.PUBLIC:
        return 'Public';
      case SpaceVisibility.PRIVATE:
        return 'Private';
      case SpaceVisibility.RESTRICTED:
        return 'Restricted';
    }
  }
}
