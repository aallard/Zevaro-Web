import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../providers/tickets_providers.dart';

class CreateTicketDialog extends ConsumerStatefulWidget {
  final String workstreamId;

  const CreateTicketDialog({super.key, required this.workstreamId});

  @override
  ConsumerState<CreateTicketDialog> createState() =>
      _CreateTicketDialogState();
}

class _CreateTicketDialogState extends ConsumerState<CreateTicketDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _environmentController = TextEditingController();
  final _stepsController = TextEditingController();
  final _expectedController = TextEditingController();
  final _actualController = TextEditingController();
  TicketType _type = TicketType.BUG;
  TicketSeverity? _severity;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _environmentController.dispose();
    _stepsController.dispose();
    _expectedController.dispose();
    _actualController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final ticket =
        await ref.read(createTicketActionProvider.notifier).create(
              widget.workstreamId,
              CreateTicketRequest(
                title: _titleController.text.trim(),
                description: _descriptionController.text.trim().isEmpty
                    ? null
                    : _descriptionController.text.trim(),
                type: _type,
                severity: _severity,
                environment: _environmentController.text.trim().isEmpty
                    ? null
                    : _environmentController.text.trim(),
                stepsToReproduce: _stepsController.text.trim().isEmpty
                    ? null
                    : _stepsController.text.trim(),
                expectedBehavior: _expectedController.text.trim().isEmpty
                    ? null
                    : _expectedController.text.trim(),
                actualBehavior: _actualController.text.trim().isEmpty
                    ? null
                    : _actualController.text.trim(),
              ),
            );

    if (ticket != null && mounted) {
      Navigator.pop(context);
      context.go(Routes.ticketById(ticket.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final createState = ref.watch(createTicketActionProvider);
    final isLoading = createState.isLoading;
    final isBug = _type == TicketType.BUG;

    return AlertDialog(
      title: const Text('Create Ticket'),
      content: SizedBox(
        width: 520,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'e.g., Login button unresponsive on mobile',
                  ),
                  autofocus: true,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Title is required'
                      : null,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<TicketType>(
                        value: _type,
                        decoration:
                            const InputDecoration(labelText: 'Type'),
                        items: TicketType.values.map((t) {
                          return DropdownMenuItem(
                              value: t, child: Text(_typeLabel(t)));
                        }).toList(),
                        onChanged: (v) {
                          if (v != null) setState(() => _type = v);
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: DropdownButtonFormField<TicketSeverity>(
                        value: _severity,
                        decoration:
                            const InputDecoration(labelText: 'Severity'),
                        items: [
                          const DropdownMenuItem(
                              value: null, child: Text('None')),
                          ...TicketSeverity.values.map((s) {
                            return DropdownMenuItem(
                                value: s,
                                child: Text(_severityLabel(s)));
                          }),
                        ],
                        onChanged: (v) =>
                            setState(() => _severity = v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Detailed description',
                  ),
                  maxLines: 3,
                ),
                if (isBug) ...[
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _environmentController,
                    decoration: const InputDecoration(
                      labelText: 'Environment',
                      hintText: 'e.g., Chrome 120, macOS 14.2',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _stepsController,
                    decoration: const InputDecoration(
                      labelText: 'Steps to Reproduce',
                      hintText: '1. Go to...\n2. Click...',
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _expectedController,
                    decoration: const InputDecoration(
                      labelText: 'Expected Behavior',
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _actualController,
                    decoration: const InputDecoration(
                      labelText: 'Actual Behavior',
                    ),
                    maxLines: 2,
                  ),
                ],
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

  String _typeLabel(TicketType type) {
    switch (type) {
      case TicketType.BUG:
        return 'Bug';
      case TicketType.ENHANCEMENT:
        return 'Enhancement';
      case TicketType.MAINTENANCE:
        return 'Maintenance';
      case TicketType.SECURITY:
        return 'Security';
      case TicketType.TECH_DEBT:
        return 'Tech Debt';
    }
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
