import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../providers/decisions_providers.dart';
import 'vote_card.dart';

class DecisionVotes extends ConsumerStatefulWidget {
  final Decision decision;

  const DecisionVotes({super.key, required this.decision});

  @override
  ConsumerState<DecisionVotes> createState() => _DecisionVotesState();
}

class _DecisionVotesState extends ConsumerState<DecisionVotes> {
  final _commentController = TextEditingController();
  String? _selectedVote;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final voteState = ref.watch(voteOnDecisionProvider);
    final isLoading = voteState.isLoading;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Votes', style: AppTypography.h4),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '(${widget.decision.voteCount})',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Vote form (if not decided)
            if (widget.decision.status != DecisionStatus.DECIDED) ...[
              Text(
                'Cast your vote',
                style: AppTypography.labelMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                children: [
                  _VoteOption(
                    label: 'Approve',
                    isSelected: _selectedVote == 'Approve',
                    color: AppColors.success,
                    onTap: () => setState(() => _selectedVote = 'Approve'),
                  ),
                  _VoteOption(
                    label: 'Reject',
                    isSelected: _selectedVote == 'Reject',
                    color: AppColors.error,
                    onTap: () => setState(() => _selectedVote = 'Reject'),
                  ),
                  _VoteOption(
                    label: 'Abstain',
                    isSelected: _selectedVote == 'Abstain',
                    color: AppColors.textSecondary,
                    onTap: () => setState(() => _selectedVote = 'Abstain'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  hintText: 'Add a comment (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      _selectedVote == null || isLoading ? null : _submitVote,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Submit Vote'),
                ),
              ),
              const Divider(height: AppSpacing.xl),
            ],

            // Existing votes
            if (widget.decision.votes?.isEmpty ?? true)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text(
                    'No votes yet',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.decision.votes!.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  return VoteCard(vote: widget.decision.votes![index]);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitVote() async {
    if (_selectedVote == null) return;

    final success = await ref.read(voteOnDecisionProvider.notifier).vote(
          widget.decision.id,
          _selectedVote!,
          comment: _commentController.text.isNotEmpty
              ? _commentController.text
              : null,
        );

    if (success && mounted) {
      setState(() {
        _selectedVote = null;
        _commentController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vote submitted')),
      );
    }
  }
}

class _VoteOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _VoteOption({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: color.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? color : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      ),
      onSelected: (_) => onTap(),
    );
  }
}
