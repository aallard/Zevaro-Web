import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../providers/tickets_providers.dart';

class TriageTicketDialog extends ConsumerStatefulWidget {
  final String ticketId;

  const TriageTicketDialog({super.key, required this.ticketId});

  @override
  ConsumerState<TriageTicketDialog> createState() =>
      _TriageTicketDialogState();
}

class _TriageTicketDialogState
    extends ConsumerState<TriageTicketDialog> {
  TicketSeverity _severity = TicketSeverity.MEDIUM;

  Future<void> _submit() async {
    final result =
        await ref.read(ticketWorkflowActionProvider.notifier).triage(
              widget.ticketId,
              TriageTicketRequest(severity: _severity),
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
      title: const Text('Triage Ticket'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<TicketSeverity>(
              value: _severity,
              decoration:
                  const InputDecoration(labelText: 'Severity'),
              items: TicketSeverity.values.map((s) {
                return DropdownMenuItem(
                  value: s,
                  child: Text(_severityLabel(s)),
                );
              }).toList(),
              onChanged: (v) {
                if (v != null) setState(() => _severity = v);
              },
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
              : const Text('Triage'),
        ),
      ],
    );
  }

  String _severityLabel(TicketSeverity severity) {
    switch (severity) {
      case TicketSeverity.CRITICAL:
        return 'Critical';
      case TicketSeverity.HIGH:
        return 'High';
      case TicketSeverity.MEDIUM:
        return 'Medium';
      case TicketSeverity.LOW:
        return 'Low';
    }
  }
}
