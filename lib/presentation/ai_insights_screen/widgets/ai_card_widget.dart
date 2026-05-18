import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/status_badge_widget.dart';

class AiCardWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onToggle;

  const AiCardWidget({super.key, required this.data, required this.onToggle});

  IconData _iconFromString(String name) {
    const map = {
      'card_giftcard': Icons.card_giftcard_rounded,
      'schedule': Icons.schedule_rounded,
      'restaurant_menu': Icons.restaurant_menu_rounded,
      'place': Icons.place_rounded,
      'business_center': Icons.business_center_rounded,
    };
    return map[name] ?? Icons.lightbulb_rounded;
  }

  BadgeStatus _statusFromString(String s) {
    switch (s) {
      case 'success':
        return BadgeStatus.success;
      case 'warning':
        return BadgeStatus.warning;
      case 'info':
        return BadgeStatus.info;
      default:
        return BadgeStatus.neutral;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isExpanded = data['isExpanded'] as bool;
    final steps = (data['steps'] as List).cast<String>();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(16),
          splashColor: AppTheme.primary.withAlpha(20),
          highlightColor: AppTheme.primary.withAlpha(10),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _iconFromString(data['icon'] as String),
                        size: 22,
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['title'] as String,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              StatusBadgeWidget(
                                label: data['category'] as String,
                                status: BadgeStatus.info,
                              ),
                              StatusBadgeWidget(
                                label: 'Impact: ${data['impact']}',
                                status: _statusFromString(
                                  data['impactColor'] as String,
                                ),
                                icon: Icons.bolt_rounded,
                              ),
                              StatusBadgeWidget(
                                label: 'Effort: ${data['effort']}',
                                status: BadgeStatus.neutral,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 250),
                      child: const Icon(
                        Icons.expand_more_rounded,
                        size: 22,
                        color: AppTheme.muted,
                      ),
                    ),
                  ],
                ),

                // Summary (always visible)
                const SizedBox(height: 12),
                Text(
                  data['summary'] as String,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                  maxLines: isExpanded ? null : 2,
                  overflow: isExpanded
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                ),

                // Expanded content
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState: isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: const SizedBox.shrink(),
                  secondChild: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Container(height: 1, color: AppTheme.outlineVariant),
                      const SizedBox(height: 14),
                      Text(
                        'Action Steps',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...steps.asMap().entries.map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryContainer,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${e.key + 1}',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  e.value,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    color: AppTheme.onSurfaceVariant,
                                    height: 1.45,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Impact summary row
                      Row(
                        children: [
                          Expanded(
                            child: _impactPill(
                              Icons.trending_up_rounded,
                              'Est. Revenue',
                              data['estimatedRevImpact'] as String,
                              AppTheme.success,
                              AppTheme.successContainer,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _impactPill(
                              Icons.timer_outlined,
                              'Time to Result',
                              data['timeToResult'] as String,
                              AppTheme.primary,
                              AppTheme.primaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _impactPill(
    IconData icon,
    String label,
    String value,
    Color color,
    Color bg,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
