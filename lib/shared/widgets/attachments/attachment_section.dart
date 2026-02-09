import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../providers/attachment_action_providers.dart';
import '../common/loading_indicator.dart';
import '../common/error_view.dart';
import 'attachment_row.dart';

class AttachmentSection extends ConsumerWidget {
  final AttachmentParentType parentType;
  final String parentId;

  const AttachmentSection({
    super.key,
    required this.parentType,
    required this.parentId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attachmentsAsync =
        ref.watch(entityAttachmentsProvider(parentType, parentId));

    return attachmentsAsync.when(
      data: (attachments) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with upload button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Text(
                    '${attachments.length} ${attachments.length == 1 ? 'file' : 'files'}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const Spacer(),
                  OutlinedButton.icon(
                    onPressed: () => _pickAndUpload(context, ref),
                    icon: const Icon(Icons.upload_outlined, size: 16),
                    label: const Text('Upload'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
                      textStyle: AppTypography.labelSmall,
                    ),
                  ),
                ],
              ),
            ),

            if (attachments.isEmpty)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.attach_file_outlined,
                          size: 36, color: AppColors.textTertiary),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'No attachments',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...attachments.map(
                (attachment) => AttachmentRow(
                  attachment: attachment,
                  onDownload: () => _download(ref, attachment),
                  onDelete: () =>
                      _confirmDelete(context, ref, attachment),
                ),
              ),
          ],
        );
      },
      loading: () =>
          const LoadingIndicator(message: 'Loading attachments...'),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () =>
            ref.invalidate(entityAttachmentsProvider(parentType, parentId)),
      ),
    );
  }

  void _download(WidgetRef ref, Attachment attachment) {
    final url = ref
        .read(attachmentActionsProvider.notifier)
        .getDownloadUrl(attachment.id);
    launchUrl(Uri.parse(url));
  }

  void _confirmDelete(
      BuildContext context, WidgetRef ref, Attachment attachment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Attachment'),
        content: Text(
            'Delete "${attachment.fileName}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(attachmentActionsProvider.notifier).deleteAttachment(
                    attachment.id,
                    parentType,
                    parentId,
                  );
            },
            style:
                FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAndUpload(BuildContext context, WidgetRef ref) async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    if (file.bytes == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not read file data.')),
        );
      }
      return;
    }

    final attachment = await ref
        .read(attachmentActionsProvider.notifier)
        .uploadFromBytes(parentType, parentId, file.bytes!, file.name);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(attachment != null
              ? 'Uploaded "${file.name}"'
              : 'Failed to upload "${file.name}"'),
        ),
      );
    }
  }
}
