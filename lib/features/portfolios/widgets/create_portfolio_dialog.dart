import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../providers/portfolios_providers.dart';

class CreatePortfolioDialog extends ConsumerStatefulWidget {
  const CreatePortfolioDialog({super.key});

  @override
  ConsumerState<CreatePortfolioDialog> createState() =>
      _CreatePortfolioDialogState();
}

class _CreatePortfolioDialogState
    extends ConsumerState<CreatePortfolioDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final portfolio =
        await ref.read(createPortfolioActionProvider.notifier).create(
              CreatePortfolioRequest(
                name: _nameController.text.trim(),
                description: _descriptionController.text.trim().isEmpty
                    ? null
                    : _descriptionController.text.trim(),
              ),
            );

    if (portfolio != null && mounted) {
      Navigator.pop(context);
      context.go(Routes.portfolioById(portfolio.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final createState = ref.watch(createPortfolioActionProvider);
    final isLoading = createState.isLoading;

    return AlertDialog(
      title: const Text('Create Portfolio'),
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
                  labelText: 'Portfolio Name',
                  hintText: 'e.g., Digital Transformation',
                ),
                autofocus: true,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Brief description of the portfolio',
                ),
                maxLines: 3,
              ),
              if (createState.hasError) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  createState.error.toString(),
                  style: TextStyle(color: AppColors.error, fontSize: 12),
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
}
