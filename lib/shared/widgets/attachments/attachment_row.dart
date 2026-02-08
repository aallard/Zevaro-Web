import 'package:flutter/material.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class AttachmentRow extends StatelessWidget {
  final Attachment attachment;
  final VoidCallback? onDownload;
  final VoidCallback? onDelete;

  const AttachmentRow({
    super.key,
    required this.attachment,
    this.onDownload,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          // File type icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(_fileIcon, size: 20, color: _iconColor),
          ),
          const SizedBox(width: AppSpacing.sm),

          // File info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attachment.fileName,
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    if (attachment.fileSize != null)
                      Text(
                        _formatFileSize(attachment.fileSize!),
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    if (attachment.uploadedByName != null) ...[
                      if (attachment.fileSize != null)
                        Text(
                          ' \u00b7 ',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      Text(
                        attachment.uploadedByName!,
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                    if (attachment.createdAt != null) ...[
                      Text(
                        ' \u00b7 ',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                      Text(
                        _formatDate(attachment.createdAt!),
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Actions
          if (onDownload != null)
            IconButton(
              icon: const Icon(Icons.download_outlined, size: 18),
              onPressed: onDownload,
              tooltip: 'Download',
              color: AppColors.textSecondary,
            ),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 18),
              onPressed: onDelete,
              tooltip: 'Delete',
              color: AppColors.error,
            ),
        ],
      ),
    );
  }

  IconData get _fileIcon {
    final type = (attachment.fileType ?? '').toLowerCase();
    if (type.contains('image')) return Icons.image_outlined;
    if (type.contains('pdf')) return Icons.picture_as_pdf_outlined;
    if (type.contains('spreadsheet') || type.contains('excel') || type.contains('csv')) {
      return Icons.table_chart_outlined;
    }
    if (type.contains('presentation') || type.contains('powerpoint')) {
      return Icons.slideshow_outlined;
    }
    if (type.contains('zip') || type.contains('archive') || type.contains('tar')) {
      return Icons.folder_zip_outlined;
    }
    if (type.contains('video')) return Icons.videocam_outlined;
    if (type.contains('audio')) return Icons.audiotrack_outlined;
    if (type.contains('text') || type.contains('document') || type.contains('word')) {
      return Icons.description_outlined;
    }
    return Icons.insert_drive_file_outlined;
  }

  Color get _iconColor {
    final type = (attachment.fileType ?? '').toLowerCase();
    if (type.contains('image')) return Colors.purple;
    if (type.contains('pdf')) return Colors.red;
    if (type.contains('spreadsheet') || type.contains('excel')) return Colors.green;
    if (type.contains('zip') || type.contains('archive')) return Colors.orange;
    return AppColors.textSecondary;
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
