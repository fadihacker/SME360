import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../ai_insights_screen/widgets/ai_card_widget.dart';

class BusinessIntelligenceScreen extends StatefulWidget {
  const BusinessIntelligenceScreen({super.key});

  @override
  State<BusinessIntelligenceScreen> createState() =>
      _BusinessIntelligenceScreenState();
}

class _BusinessIntelligenceScreenState extends State<BusinessIntelligenceScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _pdfAnimController;
  late Animation<double> _pdfRotation;
  bool _isGeneratingPdf = false;
  bool _pdfDone = false;
  bool _alertDismissed = false;

  final List<Map<String, dynamic>> _recommendationMaps = [
    {
      'title': 'Launch a Loyalty Punch Card Program',
      'category': 'Customer Retention',
      'impact': 'High',
      'effort': 'Low',
      'impactColor': 'success',
      'icon': 'card_giftcard',
      'summary':
          'Customers who earn rewards visit 2.4× more frequently. A digital punch card via a QR code at the counter can increase retention from 68% to an estimated 74% within 60 days.',
      'steps': [
        'Set up a free account on Stamp Me or similar loyalty app',
        'Print QR codes and place at counter and tables',
        'Offer "10th coffee free" as the starter reward',
        'Track redemption weekly and adjust reward threshold if needed',
      ],
      'estimatedRevImpact': '+\$1,840/mo',
      'timeToResult': '30–60 days',
      'isExpanded': false,
    },
    {
      'title': 'Optimize Morning Rush Staffing',
      'category': 'Operational Efficiency',
      'impact': 'Medium',
      'effort': 'Low',
      'impactColor': 'warning',
      'icon': 'schedule',
      'summary':
          'Peak orders occur between 7:30–9:00 AM but average wait time is 6.2 minutes — 40% above the 4.5-minute customer satisfaction threshold.',
      'steps': [
        'Review POS data for hourly order volume patterns',
        'Schedule one additional barista 7:15 AM–9:15 AM weekdays',
        'Set a 4.5-minute wait-time target and track it daily',
        'Offer a "skip-the-line" pre-order option via your website',
      ],
      'estimatedRevImpact': '+\$920/mo',
      'timeToResult': '14–21 days',
      'isExpanded': false,
    },
    {
      'title': 'Introduce a Seasonal Specialty Menu',
      'category': 'Revenue Growth',
      'impact': 'High',
      'effort': 'Medium',
      'impactColor': 'success',
      'icon': 'restaurant_menu',
      'summary':
          'Cafés with rotating seasonal menus see 18% higher avg order values and generate social media buzz organically.',
      'steps': [
        'Identify 3 trending spring beverages (matcha lemonade, lavender latte, cold brew tonic)',
        'Test with a 2-week soft launch to 20% of customers',
        'Price 10–15% above standard menu items to signal premium',
        'Photograph and post daily on Instagram and Google Business',
      ],
      'estimatedRevImpact': '+\$2,200/mo',
      'timeToResult': '21–45 days',
      'isExpanded': false,
    },
    {
      'title': 'Claim & Optimize Google Business Profile',
      'category': 'Market Visibility',
      'impact': 'High',
      'effort': 'Low',
      'impactColor': 'success',
      'icon': 'place',
      'summary':
          'Your Google Business profile has 34% fewer photos and 60% fewer reviews than the top 3 local café competitors.',
      'steps': [
        'Add 10+ high-quality interior and menu photos this week',
        'Respond to every unanswered review (positive and negative)',
        'Post a "Weekly Special" update every Monday morning',
        'Enable messaging so customers can ask questions directly',
      ],
      'estimatedRevImpact': '+\$1,100/mo',
      'timeToResult': '14–30 days',
      'isExpanded': false,
    },
    {
      'title': 'Introduce Corporate Catering Packages',
      'category': 'Revenue Diversification',
      'impact': 'High',
      'effort': 'High',
      'impactColor': 'info',
      'icon': 'business_center',
      'summary':
          'There are 12 office buildings within 600m of Café Élite. A monthly corporate coffee subscription could generate \$800–\$1,500 in predictable recurring revenue per account.',
      'steps': [
        'Create a simple 1-page catering menu PDF with pricing',
        'Identify and contact 5 nearby office managers via LinkedIn',
        'Offer a free trial box for 10 people to demonstrate quality',
        'Set up a simple recurring invoice via Wave or QuickBooks',
      ],
      'estimatedRevImpact': '+\$3,200/mo',
      'timeToResult': '45–90 days',
      'isExpanded': false,
    },
  ];

  late List<Map<String, dynamic>> _recommendations;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pdfAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _pdfRotation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _pdfAnimController, curve: Curves.linear),
    );
    _recommendations = List<Map<String, dynamic>>.from(
      _recommendationMaps.map((m) => Map<String, dynamic>.from(m)),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
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

  void _toggleExpanded(int index) {
    setState(() {
      _recommendations[index]['isExpanded'] =
          !(_recommendations[index]['isExpanded'] as bool);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Critical AI Alert Banner (permanent) ──────────
            if (!_alertDismissed) _buildCriticalAlertBanner(),
            // ── Header ────────────────────────────────────────
            _buildHeader(),
            // ── TabBar ────────────────────────────────────────
            _buildTabBar(),
            // ── Tab Content ───────────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPerformanceTab(),
                  _buildAiRecommendationsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCriticalAlertBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFB91C1C), Color(0xFFDC2626)],
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_rounded, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '⚠️ Critical Alert: Today\'s sales are 23% below last week\'s average (\$1,240 vs \$1,610)',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _alertDismissed = true),
            child: const Icon(Icons.close, color: Colors.white70, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      color: AppTheme.surface,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Business Intelligence',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.onSurface,
                  ),
                ),
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
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppTheme.surface,
      child: TabBar(
        controller: _tabController,
        labelColor: AppTheme.primary,
        unselectedLabelColor: AppTheme.muted,
        indicatorColor: AppTheme.primary,
        indicatorWeight: 3,
        labelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        tabs: const [
          Tab(
            icon: Icon(Icons.bar_chart_rounded, size: 18),
            text: 'Performance',
            iconMargin: EdgeInsets.only(bottom: 2),
          ),
          Tab(
            icon: Icon(Icons.psychology_rounded, size: 18),
            text: 'AI Recommendations',
            iconMargin: EdgeInsets.only(bottom: 2),
          ),
        ],
      ),
    );
  }

  // ── Performance Tab ────────────────────────────────────────
  Widget _buildPerformanceTab() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfitSalesChart(),
                const SizedBox(height: 20),
                _buildPeakHourHeatmap(),
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
    );
  }

  // ── AI Recommendations Tab ─────────────────────────────────
  Widget _buildAiRecommendationsTab() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF006978), Color(0xFF1565C0)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.psychology_rounded,
                        size: 32,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Personalized for Café Élite',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Based on your revenue data, market position, and local café trends',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildGrowthPredictionCard(),
                const SizedBox(height: 16),
                Text(
                  'Growth Recommendations',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) => Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                0,
                16,
                i == _recommendations.length - 1 ? 24 : 12,
              ),
              child: AiCardWidget(
                data: _recommendations[i],
                onToggle: () => _toggleExpanded(i),
              ),
            ),
            childCount: _recommendations.length,
          ),
        ),
      ],
    );
  }

  Widget _buildGrowthPredictionCard() {
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.trending_up_rounded,
                  color: AppTheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Growth Prediction',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.onSurface,
                      ),
                    ),
                    Text(
                      'Next 30 days forecast',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppTheme.muted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.successContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '+18.4%',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildPredictionStat('Revenue', '\$6,840', '+12%', true),
              const SizedBox(width: 12),
              _buildPredictionStat('Customers', '1,240', '+8%', true),
              const SizedBox(width: 12),
              _buildPredictionStat('Avg Order', '\$5.52', '+4%', true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionStat(
    String label,
    String value,
    String change,
    bool positive,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                color: AppTheme.muted,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.onSurface,
              ),
            ),
            Text(
              change,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: positive ? AppTheme.success : AppTheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── 1. Profit vs Sales Chart ───────────────────────────────
  Widget _buildProfitSalesChart() {
    final salesData = [4200.0, 4800.0, 4500.0, 5200.0, 4900.0, 5600.0, 5100.0];
    final profitData = [1260.0, 1440.0, 1350.0, 1560.0, 1470.0, 1680.0, 1530.0];
    final forecastData = [5100.0, 5400.0, 5800.0, 6100.0];

    return _SectionCard(
      title: 'Profit vs Sales',
      subtitle: 'Monthly · with AI Forecast',
      icon: Icons.show_chart_rounded,
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
                    final i = v.toInt();
                    if (i < 0 || i >= months.length) return const SizedBox();
                    return Text(
                      months[i],
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9,
                        color: AppTheme.muted,
                      ),
                    );
                  },
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
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
              LineChartBarData(
                spots: forecastData
                    .asMap()
                    .entries
                    .map(
                      (e) => FlSpot(
                        (e.key + salesData.length - 1).toDouble(),
                        e.value,
                      ),
                    )
                    .toList(),
                isCurved: true,
                color: AppTheme.primary,
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
    final hours = ['6AM', '8AM', '10AM', '12PM', '2PM', '4PM', '6PM', '8PM'];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final data = [
      [0.3, 0.8, 0.5, 0.6, 0.4, 0.3, 0.2, 0.1],
      [0.4, 0.9, 0.6, 0.7, 0.5, 0.4, 0.3, 0.2],
      [0.3, 0.7, 0.5, 0.8, 0.6, 0.4, 0.3, 0.1],
      [0.4, 0.8, 0.6, 0.9, 0.7, 0.5, 0.4, 0.2],
      [0.5, 1.0, 0.7, 0.8, 0.6, 0.5, 0.4, 0.3],
      [0.6, 0.7, 0.8, 1.0, 0.9, 0.8, 0.7, 0.5],
      [0.4, 0.5, 0.6, 0.9, 0.8, 0.7, 0.6, 0.4],
    ];

    return _SectionCard(
      title: 'Peak Hour Heatmap',
      subtitle: 'Busiest hours by day',
      icon: Icons.grid_view_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 32),
              ...hours.map(
                (h) => Expanded(
                  child: Text(
                    h,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 8,
                      color: AppTheme.muted,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ...List.generate(days.length, (di) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 32,
                    child: Text(
                      days[di],
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9,
                        color: AppTheme.muted,
                      ),
                    ),
                  ),
                  ...List.generate(hours.length, (hi) {
                    final intensity = data[di][hi];
                    return Expanded(
                      child: Container(
                        height: 22,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          color: Color.lerp(
                            AppTheme.primaryContainer,
                            AppTheme.primaryDark,
                            intensity,
                          ),
                          borderRadius: BorderRadius.circular(3),
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
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryContainer, AppTheme.primaryDark],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Text(
                'High',
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

  // ── 3. Retention Gauge ─────────────────────────────────────
  Widget _buildRetentionGauge() {
    return _SectionCard(
      title: 'Customer Retention',
      subtitle: 'Returning vs New customers',
      icon: Icons.people_alt_rounded,
      child: Row(
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: CustomPaint(
              painter: _GaugePainter(value: 0.68),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '68%',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
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
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRetentionRow(
                  'Returning Customers',
                  0.68,
                  AppTheme.primary,
                  '68%',
                ),
                const SizedBox(height: 10),
                _buildRetentionRow(
                  'New Customers',
                  0.32,
                  AppTheme.secondary,
                  '32%',
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.successContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '↑ 4% improvement vs last month',
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

  Widget _buildRetentionRow(
    String label,
    double value,
    Color color,
    String pct,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
            Text(
              pct,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: AppTheme.outlineVariant,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  // ── 4. Top Profit Makers ───────────────────────────────────
  Widget _buildTopProfitMakers() {
    final items = [
      {'name': 'Cold Brew', 'profit': '\$3.50/unit', 'rank': 1, 'pct': 0.92},
      {
        'name': 'Espresso Macchiato',
        'profit': '\$3.20/unit',
        'rank': 2,
        'pct': 0.84,
      },
      {'name': 'Matcha Latte', 'profit': '\$2.90/unit', 'rank': 3, 'pct': 0.76},
      {
        'name': 'Avocado Toast',
        'profit': '\$2.60/unit',
        'rank': 4,
        'pct': 0.68,
      },
      {'name': 'Flat White', 'profit': '\$2.40/unit', 'rank': 5, 'pct': 0.63},
    ];

    return _SectionCard(
      title: 'Top Profit Makers',
      subtitle: 'Ranked by net profit per unit',
      icon: Icons.emoji_events_rounded,
      child: Column(
        children: items.map((item) {
          final rank = item['rank'] as int;
          final pct = item['pct'] as double;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: rank == 1
                        ? const Color(0xFFFFD700)
                        : rank == 2
                        ? const Color(0xFFC0C0C0)
                        : rank == 3
                        ? const Color(0xFFCD7F32)
                        : AppTheme.outlineVariant,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$rank',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: rank <= 3 ? Colors.white : AppTheme.muted,
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
                        item['name'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.onSurface,
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: pct,
                          backgroundColor: AppTheme.outlineVariant,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.primary.withAlpha(180),
                          ),
                          minHeight: 4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  item['profit'] as String,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.success,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── 5. Menu Engineering ────────────────────────────────────
  Widget _buildMenuEngineering() {
    return _SectionCard(
      title: 'Menu Engineering Advice',
      subtitle: 'AI-powered menu optimization',
      icon: Icons.restaurant_menu_rounded,
      child: Column(
        children: [
          _buildMenuAdviceRow(
            Icons.arrow_upward_rounded,
            AppTheme.success,
            AppTheme.successContainer,
            'Promote',
            'Cold Brew & Matcha Latte',
            'High profit, growing demand',
          ),
          const SizedBox(height: 8),
          _buildMenuAdviceRow(
            Icons.remove_circle_outline_rounded,
            AppTheme.error,
            AppTheme.errorContainer,
            'Remove',
            'Vanilla Frappé',
            'Low sales, high ingredient cost',
          ),
          const SizedBox(height: 8),
          _buildMenuAdviceRow(
            Icons.price_change_rounded,
            AppTheme.warning,
            AppTheme.warningContainer,
            'Reprice',
            'Espresso (+5%)',
            'Boost monthly margin by ~\$340',
          ),
        ],
      ),
    );
  }

  Widget _buildMenuAdviceRow(
    IconData icon,
    Color color,
    Color bg,
    String action,
    String item,
    String reason,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
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
                        color: color.withAlpha(30),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        action,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        item,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  reason,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── 6. Sentiment Dashboard ─────────────────────────────────
  Widget _buildSentimentDashboard() {
    final sentiments = [
      {
        'emoji': '😍',
        'label': 'Excellent',
        'count': 42,
        'color': AppTheme.success,
      },
      {'emoji': '😊', 'label': 'Good', 'count': 28, 'color': AppTheme.primary},
      {
        'emoji': '😐',
        'label': 'Neutral',
        'count': 12,
        'color': AppTheme.warning,
      },
      {'emoji': '😞', 'label': 'Poor', 'count': 5, 'color': AppTheme.error},
    ];

    return _SectionCard(
      title: 'Customer Sentiment',
      subtitle: 'Based on recent Google & Social reviews',
      icon: Icons.sentiment_satisfied_alt_rounded,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: sentiments.map((s) {
          return Column(
            children: [
              Text(s['emoji'] as String, style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 4),
              Text(
                '${s['count']}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: s['color'] as Color,
                ),
              ),
              Text(
                s['label'] as String,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  color: AppTheme.muted,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ── 7. Investor Report ─────────────────────────────────────
  Widget _buildInvestorReport() {
    return _SectionCard(
      title: 'Investor Report Generator',
      subtitle: 'Full business summary PDF',
      icon: Icons.picture_as_pdf_rounded,
      child: Column(
        children: [
          if (_pdfDone)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.successContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppTheme.success,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Report generated successfully!',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.success,
                    ),
                  ),
                ],
              ),
            )
          else
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isGeneratingPdf ? null : _generateReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: _isGeneratingPdf
                    ? AnimatedBuilder(
                        animation: _pdfRotation,
                        builder: (_, __) => Transform.rotate(
                          angle: _pdfRotation.value,
                          child: const Icon(Icons.sync_rounded, size: 18),
                        ),
                      )
                    : const Icon(Icons.picture_as_pdf_rounded, size: 18),
                label: Text(
                  _isGeneratingPdf
                      ? 'Generating PDF...'
                      : 'Generate Investor Report',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
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
    final center = Offset(size.width / 2, size.height * 0.65);
    final radius = size.width * 0.42;
    const startAngle = math.pi;
    const sweepAngle = math.pi;

    final bgPaint = Paint()
      ..color = AppTheme.outlineVariant
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );

    final fgPaint = Paint()
      ..color = AppTheme.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle * value,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_GaugePainter old) => old.value != value;
}

// ── Section Card ───────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppTheme.primary, size: 18),
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
                        fontWeight: FontWeight.w600,
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
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
