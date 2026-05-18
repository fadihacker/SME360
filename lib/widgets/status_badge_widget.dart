import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

enum BadgeStatus { success, warning, error, info, neutral }

class StatusBadgeWidget extends StatelessWidget {
  final String label;
  final BadgeStatus status;
  final IconData? icon;

  const StatusBadgeWidget({
    super.key,
    required this.label,
    this.status = BadgeStatus.neutral,
    this.icon,
  });

  Color _bgColor() {
    switch (status) {
      case BadgeStatus.success:
        return AppTheme.successContainer;
      case BadgeStatus.warning:
        return AppTheme.warningContainer;
      case BadgeStatus.error:
        return AppTheme.errorContainer;
      case BadgeStatus.info:
        return AppTheme.infoContainer;
      case BadgeStatus.neutral:
        return AppTheme.surfaceVariant;
    }
  }

  Color _textColor() {
    switch (status) {
      case BadgeStatus.success:
        return AppTheme.success;
      case BadgeStatus.warning:
        return AppTheme.warning;
      case BadgeStatus.error:
        return AppTheme.error;
      case BadgeStatus.info:
        return AppTheme.info;
      case BadgeStatus.neutral:
        return AppTheme.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _bgColor(),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: _textColor()),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _textColor(),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
