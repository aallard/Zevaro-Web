import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../providers/settings_providers.dart';

class NotificationSettingsWidget extends ConsumerWidget {
  const NotificationSettingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(notificationSettingsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Text('Email Notifications', style: AppTypography.labelMedium),
        ),
        SwitchListTile(
          title: const Text('Decision assignments'),
          subtitle: const Text('When you\'re assigned to a new decision'),
          value: prefs.emailOnDecision,
          onChanged: (value) {
            ref
                .read(notificationSettingsProvider.notifier)
                .setEmailOnDecision(value);
          },
        ),
        SwitchListTile(
          title: const Text('Mentions'),
          subtitle: const Text('When someone mentions you in a comment'),
          value: prefs.emailOnMention,
          onChanged: (value) {
            ref
                .read(notificationSettingsProvider.notifier)
                .setEmailOnMention(value);
          },
        ),
        SwitchListTile(
          title: const Text('Daily digest'),
          subtitle: const Text('Summary of pending decisions each morning'),
          value: prefs.emailDigest,
          onChanged: (value) {
            ref
                .read(notificationSettingsProvider.notifier)
                .setEmailDigest(value);
          },
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Text('Push Notifications', style: AppTypography.labelMedium),
        ),
        SwitchListTile(
          title: const Text('Urgent decisions'),
          subtitle: const Text('Immediate alerts for blocking decisions'),
          value: prefs.pushOnUrgent,
          onChanged: (value) {
            ref
                .read(notificationSettingsProvider.notifier)
                .setPushOnUrgent(value);
          },
        ),
      ],
    );
  }
}
