import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen>
    with TickerProviderStateMixin {
  late AnimationController _pdfAnimController;
  late Animation<double> _pdfRotation;
  bool _isGeneratingPdf = false;
  bool _pdfDone = false;

  @override
  void initState() {
    super.initState();
    _pdfAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _pdfRotation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _pdfAnimController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _pdfAnimController.dispose();
    super.dispose();
  }

  void _generateReport() async {
    setState(() {
      _isGeneratingPdf = true;
      _pdfDone = false;
    });
    _pdfAnimController.repeat();
    await Future.delayed(const Duration(seconds: 3));
    _pdfAnimController.stop();
    _pdfAnimController.reset();
    setState(() {
      _isGeneratingPdf = false;
      _pdfDone = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _pdfDone = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 8),
                    _buildAnomalyAlert(),
                    const SizedBox(height: 20),
                    _buildProfitSalesChart(),
                    const SizedBox(height: 20),
                    _buildPeakHourHeatmap(),
                    const SizedBox(height: 20),
                    _buildAiGrowthTips(),
                    const SizedBox(height: 20),
                    _buildRetentionGauge(),
                    const SizedBox(height: 20),
                    _buildTopProfitMakers(),
                    const SizedBox(height: 20),
                    _buildMenuEngineering(),
                    const SizedBox(height: 20),
                    _buildSentimentDashboard(),
                    const SizedBox(height: 20),
                    _buildInvestorReport(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────
  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AI Business Insights',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Café Élite · Powered by SME360 AI',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppTheme.muted,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primary, AppTheme.secondary],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_awesome, color: Colors.white, size: 14),
              const SizedBox(width: 4),
              Text(
                'Live',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── 6. Sales Anomaly Alert ─────────────────────────────────
  Widget _buildAnomalyAlert() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.error.withAlpha(80)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppTheme.error.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: AppTheme.error,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sales Anomaly Detected',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.error,
                  ),
                ),
                Text(
                  "Today's sales are 23% below last week's average (\$1,240 vs \$1,610)",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppTheme.error.withAlpha(200),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── 1. Profit vs Sales Chart + 7. Forecast ─────────────────
  Widget _buildProfitSalesChart() {
    final salesData = [4200.0, 4800.0, 4500.0, 5200.0, 4900.0, 5600.0, 5100.0];
    final profitData = [1260.0, 1440.0, 1350.0, 1560.0, 1470.0, 1680.0, 1530.0];
    final forecastData = [5100.0, 5400.0, 5800.0, 6100.0];

    return _SectionCard(
      title: 'Profit vs Sales',
      subtitle: 'Monthly · with AI Forecast',
      icon: Icons.show_chart_rounded,
      trailing: Row(
        children: [
          _LegendDot(color: AppTheme.primary, label: 'Revenue'),
          const SizedBox(width: 10),
          _LegendDot(color: AppTheme.secondary, label: 'Profit'),
          const SizedBox(width: 10),
          _LegendDot(
            color: AppTheme.chartAccent,
            label: 'Forecast',
            dashed: true,
          ),
        ],
      ),
      child: SizedBox(
        height: 200,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (_) =>
                  FlLine(color: AppTheme.outlineVariant, strokeWidth: 1),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (v, _) => Text(
                    '\$${(v / 1000).toStringAsFixed(1)}k',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 9,
                      color: AppTheme.muted,
                    ),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (v, _) {
                    const months = [
                      'Jul',
                      'Aug',
                      'Sep',
                      'Oct',
                      'Nov',
                      'Dec',
                      'Jan',
                      'Feb',
                      'Mar',
                      'Apr',
                    ];
                    final idx = v.toInt();
                    if (idx < 0 || idx >= months.length) {
                      return const SizedBox();
                    }
                    return Text(
                      months[idx],
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9,
                        color: AppTheme.muted,
                      ),
                    );
                  },
                ),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              // Sales line
              LineChartBarData(
                spots: salesData
                    .asMap()
                    .entries
                    .map((e) => FlSpot(e.key.toDouble(), e.value))
                    .toList(),
                isCurved: true,
                color: AppTheme.primary,
                barWidth: 2.5,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: AppTheme.primary.withAlpha(25),
                ),
              ),
              // Profit line
              LineChartBarData(
                spots: profitData
                    .asMap()
                    .entries
                    .map((e) => FlSpot(e.key.toDouble(), e.value))
                    .toList(),
                isCurved: true,
                color: AppTheme.secondary,
                barWidth: 2.5,
                dotData: const FlDotData(show: false),
              ),
              // Forecast dashed line
              LineChartBarData(
                spots: [
                  FlSpot(6, 5100),
                  ...forecastData.asMap().entries.map(
                    (e) => FlSpot((e.key + 7).toDouble(), e.value),
                  ),
                ],
                isCurved: true,
                color: AppTheme.chartAccent,
                barWidth: 2,
                dashArray: [6, 4],
                dotData: const FlDotData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── 2. Peak Hour Heatmap ───────────────────────────────────
  Widget _buildPeakHourHeatmap() {
    final hours = ['6am', '8am', '10am', '12pm', '2pm', '4pm', '6pm', '8pm'];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final data = [
      [0.2, 0.6, 0.9, 1.0, 0.7, 0.5, 0.3, 0.1],
      [0.3, 0.7, 0.8, 0.9, 0.6, 0.4, 0.2, 0.1],
      [0.2, 0.5, 0.7, 0.8, 0.5, 0.4, 0.3, 0.1],
      [0.3, 0.6, 0.8, 1.0, 0.7, 0.5, 0.3, 0.2],
      [0.4, 0.8, 0.9, 1.0, 0.8, 0.6, 0.5, 0.2],
      [0.5, 0.7, 0.8, 0.9, 1.0, 0.9, 0.7, 0.4],
      [0.3, 0.5, 0.6, 0.7, 0.8, 0.7, 0.5, 0.2],
    ];

    return _SectionCard(
      title: 'Peak Hour Heatmap',
      subtitle: 'Staff scheduling guide',
      icon: Icons.grid_view_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hour labels
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: Row(
              children: hours
                  .map(
                    (h) => Expanded(
                      child: Text(
                        h,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 8,
                          color: AppTheme.muted,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 4),
          ...days.asMap().entries.map((dayEntry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 32,
                    child: Text(
                      dayEntry.value,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9,
                        color: AppTheme.muted,
                      ),
                    ),
                  ),
                  ...data[dayEntry.key].map((intensity) {
                    return Expanded(
                      child: Container(
                        height: 22,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          color: Color.lerp(
                            AppTheme.primaryContainer,
                            AppTheme.primary,
                            intensity,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 32),
              Text(
                'Low',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 9,
                  color: AppTheme.muted,
                ),
              ),
              Expanded(
                child: Container(
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryContainer, AppTheme.primary],
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              Text(
                'Peak',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 9,
                  color: AppTheme.muted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── 3. AI Growth Tips ──────────────────────────────────────
  Widget _buildAiGrowthTips() {
    final tips = [
      _GrowthTip(
        icon: Icons.trending_up_rounded,
        color: AppTheme.success,
        bg: AppTheme.successContainer,
        title: 'Increase Latte prices by 5%',
        detail: 'Boost monthly margin by ~12% · Low churn risk',
        impact: '+\$480/mo',
      ),
      _GrowthTip(
        icon: Icons.schedule_rounded,
        color: AppTheme.primary,
        bg: AppTheme.primaryContainer,
        title: 'Add a 3pm Happy Hour promo',
        detail: 'Off-peak slot with 40% lower foot traffic',
        impact: '+\$320/mo',
      ),
      _GrowthTip(
        icon: Icons.loyalty_rounded,
        color: AppTheme.secondary,
        bg: AppTheme.secondaryContainer,
        title: 'Launch a loyalty stamp card',
        detail: 'Returning customers spend 2.3× more on avg',
        impact: '+\$610/mo',
      ),
    ];

    return _SectionCard(
      title: 'AI Growth Tips',
      subtitle: 'Tap a card to apply',
      icon: Icons.lightbulb_outline_rounded,
      child: Column(
        children: tips.map((tip) => _GrowthTipCard(tip: tip)).toList(),
      ),
    );
  }

  // ── 4. Customer Retention Gauge ────────────────────────────
  Widget _buildRetentionGauge() {
    const retentionPct = 0.68;
    return _SectionCard(
      title: 'Customer Retention',
      subtitle: 'Returning vs New customers',
      icon: Icons.people_alt_outlined,
      child: Row(
        children: [
          SizedBox(
            width: 140,
            height: 100,
            child: CustomPaint(
              painter: _GaugePainter(value: retentionPct),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '68%',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primary,
                        ),
                      ),
                      Text(
                        'Returning',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          color: AppTheme.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _RetentionRow(
                  label: 'Returning',
                  pct: 0.68,
                  color: AppTheme.primary,
                ),
                const SizedBox(height: 10),
                _RetentionRow(
                  label: 'New',
                  pct: 0.32,
                  color: AppTheme.chartAccent,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.successContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '↑ 4% vs last month',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.success,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── 5. Top Profit Makers ───────────────────────────────────
  Widget _buildTopProfitMakers() {
    final items = [
      _ProfitItem(rank: 1, name: 'Cold Brew', profit: 3.50, units: 142),
      _ProfitItem(rank: 2, name: 'Matcha Latte', profit: 3.10, units: 118),
      _ProfitItem(rank: 3, name: 'Espresso Shot', profit: 2.80, units: 203),
      _ProfitItem(rank: 4, name: 'Avocado Toast', profit: 2.60, units: 87),
      _ProfitItem(rank: 5, name: 'Flat White', profit: 2.40, units: 156),
    ];

    return _SectionCard(
      title: 'Top Profit Makers',
      subtitle: 'Ranked by net profit per unit',
      icon: Icons.emoji_events_outlined,
      child: Column(
        children: items.map((item) => _ProfitItemRow(item: item)).toList(),
      ),
    );
  }

  // ── 8. Menu Engineering ───────────────────────────────────
  Widget _buildMenuEngineering() {
    return _SectionCard(
      title: 'Menu Engineering',
      subtitle: 'AI-powered item recommendations',
      icon: Icons.restaurant_menu_rounded,
      child: Column(
        children: [
          _MenuAdviceRow(
            action: 'Promote',
            item: 'Cold Brew',
            reason: 'High profit (\$3.50/unit) · Growing demand',
            color: AppTheme.success,
            bg: AppTheme.successContainer,
            icon: Icons.rocket_launch_rounded,
          ),
          const SizedBox(height: 8),
          _MenuAdviceRow(
            action: 'Promote',
            item: 'Matcha Latte',
            reason: 'Trending +28% this month · Good margin',
            color: AppTheme.primary,
            bg: AppTheme.primaryContainer,
            icon: Icons.trending_up_rounded,
          ),
          const SizedBox(height: 8),
          _MenuAdviceRow(
            action: 'Remove',
            item: 'Decaf Drip',
            reason: 'Only 3 orders/week · Low margin (\$0.80)',
            color: AppTheme.error,
            bg: AppTheme.errorContainer,
            icon: Icons.remove_circle_outline_rounded,
          ),
          const SizedBox(height: 8),
          _MenuAdviceRow(
            action: 'Reprice',
            item: 'Vanilla Latte',
            reason: 'Underpriced vs market by \$0.75',
            color: AppTheme.warning,
            bg: AppTheme.warningContainer,
            icon: Icons.price_change_outlined,
          ),
        ],
      ),
    );
  }

  // ── 10. Customer Sentiment ────────────────────────────────
  Widget _buildSentimentDashboard() {
    final sentiments = [
      _Sentiment(
        emoji: '😍',
        label: 'Excellent',
        count: 48,
        color: AppTheme.success,
      ),
      _Sentiment(
        emoji: '😊',
        label: 'Good',
        count: 31,
        color: AppTheme.primary,
      ),
      _Sentiment(
        emoji: '😐',
        label: 'Neutral',
        count: 12,
        color: AppTheme.warning,
      ),
      _Sentiment(emoji: '😞', label: 'Poor', count: 5, color: AppTheme.error),
    ];
    const total = 96;

    return _SectionCard(
      title: 'Customer Sentiment',
      subtitle: 'Based on 96 recent reviews',
      icon: Icons.sentiment_satisfied_alt_rounded,
      child: Column(
        children: [
          Row(
            children: sentiments.map((s) {
              final pct = (s.count / total * 100).round();
              return Expanded(
                child: Column(
                  children: [
                    Text(s.emoji, style: const TextStyle(fontSize: 28)),
                    const SizedBox(height: 4),
                    Text(
                      '$pct%',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: s.color,
                      ),
                    ),
                    Text(
                      s.label,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        color: AppTheme.muted,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Row(
              children: sentiments.map((s) {
                return Expanded(
                  flex: s.count,
                  child: Container(height: 8, color: s.color),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.successContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: AppTheme.success,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'Overall sentiment: Very Positive (4.3/5)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.success,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── 9. Investor Report ────────────────────────────────────
  Widget _buildInvestorReport() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.secondary, AppTheme.primary],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.description_outlined,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Investor Report Generator',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Generate a full business summary PDF with revenue, profit, KPIs, and AI forecasts.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: Colors.white.withAlpha(200),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _isGeneratingPdf ? null : _generateReport,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: _isGeneratingPdf
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedBuilder(
                            animation: _pdfRotation,
                            builder: (_, __) => Transform.rotate(
                              angle: _pdfRotation.value,
                              child: const Icon(
                                Icons.sync_rounded,
                                color: AppTheme.secondary,
                                size: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Generating PDF...',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.secondary,
                            ),
                          ),
                        ],
                      )
                    : _pdfDone
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            color: AppTheme.success,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Report Ready!',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.success,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.picture_as_pdf_rounded,
                            color: AppTheme.secondary,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Generate Investor Report',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.secondary,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Reusable Section Card ──────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;
  final Widget? trailing;

  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppTheme.primary, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.onSurface,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppTheme.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (trailing != null) ...[const SizedBox(height: 10), trailing!],
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

// ── Legend Dot ─────────────────────────────────────────────
class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  final bool dashed;

  const _LegendDot({
    required this.color,
    required this.label,
    this.dashed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        dashed
            ? Row(
                children: List.generate(
                  3,
                  (i) => Container(
                    width: 4,
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    color: color,
                  ),
                ),
              )
            : Container(width: 12, height: 3, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            color: AppTheme.muted,
          ),
        ),
      ],
    );
  }
}

// ── Growth Tip ─────────────────────────────────────────────
class _GrowthTip {
  final IconData icon;
  final Color color;
  final Color bg;
  final String title;
  final String detail;
  final String impact;

  const _GrowthTip({
    required this.icon,
    required this.color,
    required this.bg,
    required this.title,
    required this.detail,
    required this.impact,
  });
}

class _GrowthTipCard extends StatefulWidget {
  final _GrowthTip tip;
  const _GrowthTipCard({required this.tip});

  @override
  State<_GrowthTipCard> createState() => _GrowthTipCardState();
}

class _GrowthTipCardState extends State<_GrowthTipCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _expanded ? widget.tip.bg : AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _expanded
                ? widget.tip.color.withAlpha(80)
                : AppTheme.outlineVariant,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: widget.tip.bg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(widget.tip.icon, color: widget.tip.color, size: 16),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.tip.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  if (_expanded) ...[
                    const SizedBox(height: 3),
                    Text(
                      widget.tip.detail,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppTheme.muted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: widget.tip.bg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.tip.impact,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: widget.tip.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Gauge Painter ──────────────────────────────────────────
class _GaugePainter extends CustomPainter {
  final double value;
  const _GaugePainter({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.85;
    final radius = size.width * 0.45;

    final bgPaint = Paint()
      ..color = AppTheme.outlineVariant
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fgPaint = Paint()
      ..shader = const LinearGradient(
        colors: [AppTheme.chartAccent, AppTheme.primary],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: radius))
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: radius),
      math.pi,
      math.pi,
      false,
      bgPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: radius),
      math.pi,
      math.pi * value,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_GaugePainter old) => old.value != value;
}

// ── Retention Row ──────────────────────────────────────────
class _RetentionRow extends StatelessWidget {
  final String label;
  final double pct;
  final Color color;

  const _RetentionRow({
    required this.label,
    required this.pct,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppTheme.muted,
              ),
            ),
            Text(
              '${(pct * 100).round()}%',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct,
            backgroundColor: AppTheme.outlineVariant,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

// ── Profit Item ────────────────────────────────────────────
class _ProfitItem {
  final int rank;
  final String name;
  final double profit;
  final int units;

  const _ProfitItem({
    required this.rank,
    required this.name,
    required this.profit,
    required this.units,
  });
}

class _ProfitItemRow extends StatelessWidget {
  final _ProfitItem item;
  const _ProfitItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final rankColors = [
      const Color(0xFFFFD700),
      const Color(0xFFC0C0C0),
      const Color(0xFFCD7F32),
      AppTheme.muted,
      AppTheme.muted,
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: rankColors[item.rank - 1].withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '#${item.rank}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: rankColors[item.rank - 1],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
                Text(
                  '${item.units} units sold',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppTheme.muted,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppTheme.successContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '\$${item.profit.toStringAsFixed(2)}/unit',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppTheme.success,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Menu Advice Row ────────────────────────────────────────
class _MenuAdviceRow extends StatelessWidget {
  final String action;
  final String item;
  final String reason;
  final Color color;
  final Color bg;
  final IconData icon;

  const _MenuAdviceRow({
    required this.action,
    required this.item,
    required this.reason,
    required this.color,
    required this.bg,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        action,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  reason,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppTheme.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sentiment ──────────────────────────────────────────────
class _Sentiment {
  final String emoji;
  final String label;
  final int count;
  final Color color;

  const _Sentiment({
    required this.emoji,
    required this.label,
    required this.count,
    required this.color,
  });
}
