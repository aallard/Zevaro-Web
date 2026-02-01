import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../providers/decisions_providers.dart';

class DecisionResolutionDialog extends ConsumerStatefulWidget {
  final Decision decision;

  const DecisionResolutionDialog({super.key, required this.decision});

  @override
  ConsumerState<DecisionResolutionDialog> createState() =>
      _DecisionResolutionDialogState();
}

class _DecisionResolutionDialogState
    extends ConsumerState<DecisionResolutionDialog> {
  final _optionController = TextEditingController();
  final _rationaleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _optionController.dispose();
    _rationaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resolveState = ref.watch(resolveDecisionActionProvider);
    final isLoading = resolveState.isLoading;

    return AlertDialog(
      title: const Text('Resolve Decision'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.decision.title,
                style: AppTypography.labelLarge,
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: _optionController,
                decoration: const InputDecoration(
                  labelText: 'Selected Option',
                  hintText: 'What was decided?',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _rationaleController,
                decoration: const InputDecoration(
                  labelText: 'Rationale',
                  hintText: 'Why was this option chosen?',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              if (resolveState.hasError) ...[
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Text(
                    resolveState.error.toString(),
                    style: TextStyle(color: AppColors.error),
                  ),
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
        ElevatedButton(
          onPressed: isLoading ? null : _resolve,
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Resolve'),
        ),
      ],
    );
  }

  Future<void> _resolve() async {
    if (!_formKey.currentState!.validate()) return;

    final request = ResolveDecisionRequest(
      selectedOption: _optionController.text.trim(),
      decisionRationale: _rationaleController.text.trim(),
    );

    final success = await ref
        .read(resolveDecisionActionProvider.notifier)
        .resolve(widget.decision.id, request);

    if (success && mounted) {
      Navigator.pop(context, true);
    }
  }
}
