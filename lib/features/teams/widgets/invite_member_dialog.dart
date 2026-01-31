import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../providers/teams_providers.dart';

class InviteMemberDialog extends ConsumerStatefulWidget {
  final String teamId;
  final String teamName;

  const InviteMemberDialog({
    super.key,
    required this.teamId,
    required this.teamName,
  });

  @override
  ConsumerState<InviteMemberDialog> createState() => _InviteMemberDialogState();
}

class _InviteMemberDialogState extends ConsumerState<InviteMemberDialog> {
  String? _selectedUserId;
  TeamMemberRole _selectedRole = TeamMemberRole.MEMBER;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(availableUsersProvider(widget.teamId));

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 450, maxHeight: 400),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const Icon(Icons.person_add, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Text('Invite Member', style: AppTypography.h3),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Add a member to ${widget.teamName}',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Content
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User selection
                      usersAsync.when(
                        data: (users) {
                          if (users.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(AppSpacing.lg),
                                child: Column(
                                  children: [
                                    Icon(Icons.people_outline,
                                        size: 48, color: AppColors.textTertiary),
                                    const SizedBox(height: AppSpacing.sm),
                                    Text(
                                      'No users available to invite',
                                      style: AppTypography.bodyMedium.copyWith(
                                        color: AppColors.textTertiary,
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(
                                      'All users are already members',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.textTertiary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return DropdownButtonFormField<String>(
                            value: _selectedUserId,
                            decoration: const InputDecoration(
                              labelText: 'Select User *',
                              border: OutlineInputBorder(),
                            ),
                            items: users.map((user) {
                              return DropdownMenuItem(
                                value: user.id,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 14,
                                      backgroundColor:
                                          AppColors.primary.withOpacity(0.1),
                                      child: Text(
                                        user.fullName.isNotEmpty
                                            ? user.fullName[0].toUpperCase()
                                            : 'U',
                                        style: AppTypography.labelSmall
                                            .copyWith(color: AppColors.primary),
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.sm),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(user.fullName,
                                              overflow: TextOverflow.ellipsis),
                                          Text(
                                            user.email,
                                            style: AppTypography.bodySmall.copyWith(
                                              color: AppColors.textSecondary,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (v) => setState(() => _selectedUserId = v),
                          );
                        },
                        loading: () => const LinearProgressIndicator(),
                        error: (e, _) => Text('Error loading users: $e'),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Role selection
                      DropdownButtonFormField<TeamMemberRole>(
                        value: _selectedRole,
                        decoration: const InputDecoration(
                          labelText: 'Role *',
                          border: OutlineInputBorder(),
                        ),
                        items: TeamMemberRole.values.map((role) {
                          return DropdownMenuItem(
                            value: role,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(role.displayName),
                                Text(
                                  _roleDescription(role),
                                  style: AppTypography.bodySmall
                                      .copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (v) =>
                            setState(() => _selectedRole = v ?? TeamMemberRole.MEMBER),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  ElevatedButton(
                    onPressed:
                        _isLoading || _selectedUserId == null ? null : _submit,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Invite'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _roleDescription(TeamMemberRole role) {
    switch (role) {
      case TeamMemberRole.MEMBER:
        return 'Can view and participate';
      case TeamMemberRole.LEAD:
        return 'Can manage team members';
      case TeamMemberRole.OWNER:
        return 'Full team control';
    }
  }

  Future<void> _submit() async {
    if (_selectedUserId == null) return;

    setState(() => _isLoading = true);

    try {
      final addMember = ref.read(addTeamMemberProvider.notifier);
      final success = await addMember.add(
        widget.teamId,
        _selectedUserId!,
        _selectedRole,
      );

      if (mounted && success) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Member invited successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

/// Helper function to show the dialog
Future<bool?> showInviteMemberDialog(
  BuildContext context, {
  required String teamId,
  required String teamName,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => InviteMemberDialog(teamId: teamId, teamName: teamName),
  );
}
