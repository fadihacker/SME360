import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/status_badge_widget.dart';

class AccountSectionGroupWidget extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final ValueChanged<String> onItemTap;

  const AccountSectionGroupWidget({
    super.key,
    required this.title,
    required this.items,
    required this.onItemTap,
  });

  BadgeStatus _badgeStatusFromString(String? s) {
    switch (s) {
      case 'success':
        return BadgeStatus.success;
      case 'warning':
        return BadgeStatus.warning;
      case 'error':
        return BadgeStatus.error;
      case 'info':
        return BadgeStatus.info;
      default:
        return BadgeStatus.neutral;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.muted,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              final isLast = i == items.length - 1;
              return _AccountSectionRow(
                item: item,
                isLast: isLast,
                badgeStatusFromString: _badgeStatusFromString,
                onTap: () => onItemTap(item['sheetType'] as String),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _AccountSectionRow extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool isLast;
  final BadgeStatus Function(String?) badgeStatusFromString;
  final VoidCallback onTap;

  const _AccountSectionRow({
    required this.item,
    required this.isLast,
    required this.badgeStatusFromString,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(isLast ? 0 : 0),
              bottom: Radius.circular(isLast ? 16 : 0),
            ),
            splashColor: (item['color'] as Color).withAlpha(20),
            highlightColor: (item['color'] as Color).withAlpha(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: item['bgColor'] as Color,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      size: 20,
                      color: item['color'] as Color,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              item['label'] as String,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.onSurface,
                              ),
                            ),
                            if (item['badge'] != null) ...[
                              const SizedBox(width: 8),
                              StatusBadgeWidget(
                                label: item['badge'] as String,
                                status: badgeStatusFromString(
                                  item['badgeStatus'] as String?,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item['subtitle'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: AppTheme.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: AppTheme.outline,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            thickness: 1,
            color: AppTheme.outlineVariant,
            indent: 70,
            endIndent: 0,
          ),
      ],
    );
  }
}
