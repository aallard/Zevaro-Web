import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import 'ticket_type_badge.dart';
import 'ticket_severity_badge.dart';
import 'ticket_status_badge.dart';

class TicketCard extends StatelessWidget {
  final Ticket ticket;

  const TicketCard({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go(Routes.ticketById(ticket.id)),
        child: Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.xs),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              // Identifier
              SizedBox(
                width: 90,
                child: Text(
                  ticket.identifier,
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Title
              Expanded(
                flex: 3,
                child: Text(
                  ticket.title,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(width: AppSpacing.sm),

              // Type
              TicketTypeBadge(type: ticket.type),

              const SizedBox(width: AppSpacing.xs),

              // Severity
              if (ticket.severity != null) ...[
                TicketSeverityBadge(severity: ticket.severity!),
                const SizedBox(width: AppSpacing.xs),
              ],

              // Status
              TicketStatusBadge(status: ticket.status),

              // Assignee
              if (ticket.assignedToName != null) ...[
                const SizedBox(width: AppSpacing.sm),
                SizedBox(
                  width: 100,
                  child: Text(
                    ticket.assignedToName!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],

              // Source indicator
              const SizedBox(width: AppSpacing.xs),
              Icon(
                _sourceIcon(ticket.source),
                size: 14,
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _sourceIcon(TicketSource source) {
    switch (source) {
      case TicketSource.MANUAL:
        return Icons.edit_outlined;
      case TicketSource.JIRA_SYNC:
        return Icons.sync_outlined;
      case TicketSource.SLACK:
        return Icons.chat_outlined;
      case TicketSource.EMAIL:
        return Icons.email_outlined;
      case TicketSource.API:
        return Icons.api_outlined;
      case TicketSource.AI_DETECTED:
        return Icons.auto_fix_high_outlined;
    }
  }
}
