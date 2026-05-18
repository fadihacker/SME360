import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class _KpiData {
  final String title;
  final String value;
  final String change;
  final bool isPositive;
  final bool isWarning;
  final IconData icon;
  final String subtitle;

  const _KpiData({
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
    this.isWarning = false,
    required this.icon,
    required this.subtitle,
  });
}

class KpiGridWidget extends StatefulWidget {
  const KpiGridWidget({super.key});

  @override
  State<KpiGridWidget> createState() => _KpiGridWidgetState();
}

class _KpiGridWidgetState extends State<KpiGridWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _staggerController;
  final List<Animation<double>> _cardAnims = [];

  final List<_KpiData> _kpis = const [
    _KpiData(
      title: 'Monthly Revenue',
      value: '\$24,830',
      change: '+12.4%',
      isPositive: true,
      icon: Icons.attach_money_rounded,
      subtitle: 'vs \$22,090 last month',
    ),
    _KpiData(
      title: 'Market Share',
      value: '18.3%',
      change: '-2.1%',
      isPositive: false,
      isWarning: true,
      icon: Icons.pie_chart_rounded,
      subtitle: 'Local cafés market share',
    ),
    _KpiData(
      title: 'Customer Retention',
      value: '68%',
      change: '+3.2%',
      isPositive: true,
      icon: Icons.people_alt_rounded,
      subtitle: 'Returning customers',
    ),
    _KpiData(
      title: 'Avg Order Value',
      value: '\$14.60',
      change: '+\$0.80',
      isPositive: true,
      icon: Icons.receipt_long_rounded,
      subtitle: 'Per transaction avg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    for (int i = 0; i < _kpis.length; i++) {
      final start = (i * 0.15).clamp(0.0, 1.0);
      final end = (start + 0.6).clamp(0.0, 1.0);
      _cardAnims.add(
        CurvedAnimation(
          parent: _staggerController,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );
    }
    _staggerController.forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Key Performance Indicators',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Mar 2026',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppTheme.muted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isTablet ? 4 : 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: isTablet ? 1.4 : 1.25,
          ),
          itemCount: _kpis.length,
          itemBuilder: (context, i) {
            return FadeTransition(
              opacity: _cardAnims[i],
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.15),
                  end: Offset.zero,
                ).animate(_cardAnims[i]),
                child: _KpiCard(data: _kpis[i]),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  final _KpiData data;

  const _KpiCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final bgColor = data.isWarning
        ? AppTheme.warningContainer
        : data.isPositive
        ? AppTheme.surface
        : AppTheme.surface;

    final borderColor = data.isWarning
        ? AppTheme.warning.withAlpha(80)
        : AppTheme.outlineVariant;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: data.isWarning
                      ? AppTheme.warning.withAlpha(20)
                      : AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  data.icon,
                  size: 18,
                  color: data.isWarning ? AppTheme.warning : AppTheme.primary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: data.isPositive
                      ? AppTheme.successContainer
                      : data.isWarning
                      ? AppTheme.warningContainer
                      : AppTheme.errorContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      data.isPositive
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      size: 10,
                      color: data.isPositive
                          ? AppTheme.success
                          : data.isWarning
                          ? AppTheme.warning
                          : AppTheme.error,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      data.change,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: data.isPositive
                            ? AppTheme.success
                            : data.isWarning
                            ? AppTheme.warning
                            : AppTheme.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.onSurface,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                data.title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                data.subtitle,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.muted,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
