import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../providers/tickets_providers.dart';

class ResolveTicketDialog extends ConsumerStatefulWidget {
  final String ticketId;

  const ResolveTicketDialog({super.key, required this.ticketId});

  @override
  ConsumerState<ResolveTicketDialog> createState() =>
      _ResolveTicketDialogState();
}

class _ResolveTicketDialogState
    extends ConsumerState<ResolveTicketDialog> {
  TicketResolution _resolution = TicketResolution.FIXED;
  final _actualHoursController = TextEditingController();

  @override
  void dispose() {
    _actualHoursController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final actualHours = _actualHoursController.text.trim().isNotEmpty
        ? double.tryParse(_actualHoursController.text.trim())
        : null;

    final result =
        await ref.read(ticketWorkflowActionProvider.notifier).resolve(
              widget.ticketId,
              ResolveTicketRequest(
                resolution: _resolution,
                actualHours: actualHours,
              ),
            );

    if (result != null && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final workflowState = ref.watch(ticketWorkflowActionProvider);
    final isLoading = workflowState.isLoading;

    return AlertDialog(
      title: const Text('Resolve Ticket'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<TicketResolution>(
              value: _resolution,
              decoration:
                  const InputDecoration(labelText: 'Resolution'),
              items: TicketResolution.values.map((r) {
                return DropdownMenuItem(
                  value: r,
                  child: Text(_resolutionLabel(r)),
                );
              }).toList(),
              onChanged: (v) {
                if (v != null) setState(() => _resolution = v);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _actualHoursController,
              decoration: const InputDecoration(
                labelText: 'Actual Hours (optional)',
                hintText: 'e.g., 4.5',
              ),
              keyboardType: TextInputType.number,
            ),
            if (workflowState.hasError) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                workflowState.error.toString(),
                style:
                    TextStyle(color: AppColors.error, fontSize: 12),
              ),
            ],
          ],
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
              : const Text('Resolve'),
        ),
      ],
    );
  }

  String _resolutionLabel(TicketResolution resolution) {
    switch (resolution) {
      case TicketResolution.FIXED:
        return 'Fixed';
      case TicketResolution.DUPLICATE:
        return 'Duplicate';
      case TicketResolution.WONT_FIX:
        return "Won't Fix";
      case TicketResolution.CANNOT_REPRODUCE:
        return 'Cannot Reproduce';
      case TicketResolution.BY_DESIGN:
        return 'By Design';
    }
  }
}
