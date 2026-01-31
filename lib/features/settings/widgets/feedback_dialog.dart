import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class FeedbackDialog extends StatefulWidget {
  const FeedbackDialog({super.key});

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  final _controller = TextEditingController();
  String _feedbackType = 'suggestion';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.feedback_outlined, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Text('Send Feedback', style: AppTypography.h3),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: AppSpacing.md),

              // Feedback type
              Text('What kind of feedback?', style: AppTypography.labelMedium),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                children: [
                  ChoiceChip(
                    label: const Text('Suggestion'),
                    selected: _feedbackType == 'suggestion',
                    onSelected: (_) =>
                        setState(() => _feedbackType = 'suggestion'),
                  ),
                  ChoiceChip(
                    label: const Text('Bug Report'),
                    selected: _feedbackType == 'bug',
                    onSelected: (_) => setState(() => _feedbackType = 'bug'),
                  ),
                  ChoiceChip(
                    label: const Text('Question'),
                    selected: _feedbackType == 'question',
                    onSelected: (_) =>
                        setState(() => _feedbackType = 'question'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Feedback text
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Your feedback',
                  hintText: _feedbackType == 'bug'
                      ? 'Describe the issue you encountered...'
                      : 'Tell us what you think...',
                  border: const OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed:
                        _isSubmitting ? null : () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  ElevatedButton(
                    onPressed:
                        _isSubmitting || _controller.text.isEmpty ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Send Feedback'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    setState(() => _isSubmitting = true);

    // Simulate sending feedback
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thank you for your feedback!')),
      );
    }
  }
}

Future<void> showFeedbackDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => const FeedbackDialog(),
  );
}
