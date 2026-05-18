import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_theme.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _showScannerOverlay = false;
  bool _scanComplete = false;
  late AnimationController _scanAnimController;
  late Animation<double> _scanLineAnim;

  @override
  void initState() {
    super.initState();
    _scanAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _scanLineAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_scanAnimController);
  }

  @override
  void dispose() {
    _scanAnimController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // ── Mock Data ──────────────────────────────────────────────
  final List<Map<String, dynamic>> _allStockItems = [
    {
      'name': 'Espresso Beans',
      'unit': '2 kg left',
      'level': 0.08,
      'alert': 'critical',
    },
    {
      'name': 'Whole Milk',
      'unit': '4 L left',
      'level': 0.15,
      'alert': 'critical',
    },
    {'name': 'Oat Milk', 'unit': '6 L left', 'level': 0.22, 'alert': 'low'},
    {
      'name': 'Vanilla Syrup',
      'unit': '1 bottle left',
      'level': 0.10,
      'alert': 'critical',
    },
    {
      'name': 'Caramel Sauce',
      'unit': '3 bottles left',
      'level': 0.30,
      'alert': 'low',
    },
    {'name': 'Sugar', 'unit': '5 kg left', 'level': 0.50, 'alert': 'ok'},
    {
      'name': 'Cups (12oz)',
      'unit': '120 pcs left',
      'level': 0.60,
      'alert': 'ok',
    },
    {
      'name': 'Syrups (Hazelnut)',
      'unit': '2 bottles left',
      'level': 0.18,
      'alert': 'low',
    },
    {
      'name': 'Cold Brew Concentrate',
      'unit': '3 L left',
      'level': 0.25,
      'alert': 'low',
    },
    {
      'name': 'Matcha Powder',
      'unit': '500 g left',
      'level': 0.45,
      'alert': 'ok',
    },
  ];

  final List<Map<String, dynamic>> _expiryItems = [
    {'name': 'Whole Milk', 'expiry': 'Expires in 1 day', 'urgent': true},
    {'name': 'Fresh Cream', 'expiry': 'Expires in 2 days', 'urgent': true},
    {'name': 'Oat Milk', 'expiry': 'Expires in 4 days', 'urgent': false},
    {
      'name': 'Yogurt (Parfait)',
      'expiry': 'Expires in 5 days',
      'urgent': false,
    },
    {
      'name': 'Sandwich Filling',
      'expiry': 'Expires in 6 days',
      'urgent': false,
    },
  ];

  final List<Map<String, dynamic>> _suppliers = [
    {
      'name': 'BeanMaster Co.',
      'category': 'Coffee Beans',
      'contact': '+1 (555) 201-4400',
      'rating': 4.8,
    },
    {
      'name': 'FreshDairy Direct',
      'category': 'Milk & Cream',
      'contact': '+1 (555) 309-7711',
      'rating': 4.5,
    },
    {
      'name': 'SyrupWorld',
      'category': 'Syrups & Sauces',
      'contact': '+1 (555) 412-8823',
      'rating': 4.2,
    },
    {
      'name': 'OatGood Supplies',
      'category': 'Plant-Based Milk',
      'contact': '+1 (555) 518-6634',
      'rating': 4.6,
    },
  ];

  final List<Map<String, dynamic>> _costAnalysis = [
    {'drink': 'Espresso', 'cost': 0.42, 'price': 3.50},
    {'drink': 'Cappuccino', 'cost': 0.88, 'price': 4.80},
    {'drink': 'Iced Latte', 'cost': 1.12, 'price': 5.50},
    {'drink': 'Matcha Latte', 'cost': 1.35, 'price': 6.00},
    {'drink': 'Cold Brew', 'cost': 0.95, 'price': 5.00},
  ];

  final List<Map<String, dynamic>> _benchmarkData = [
    {'item': 'Espresso Beans', 'ours': 18.50, 'market': 21.00},
    {'item': 'Whole Milk', 'ours': 2.80, 'market': 2.60},
    {'item': 'Oat Milk', 'ours': 3.90, 'market': 4.20},
    {'item': 'Vanilla Syrup', 'ours': 8.50, 'market': 9.80},
  ];

  final List<double> _weeklyConsumption = [12, 19, 15, 22, 28, 18, 24];
  final List<String> _weekDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  List<Map<String, dynamic>> get _filteredItems {
    if (_searchQuery.isEmpty) return _allStockItems;
    return _allStockItems
        .where(
          (item) => item['name'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ),
        )
        .toList();
  }

  void _openScanner() {
    setState(() {
      _showScannerOverlay = true;
      _scanComplete = false;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _showScannerOverlay) {
        setState(() => _scanComplete = true);
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() => _showScannerOverlay = false);
            _showScanSuccessSnackbar();
          }
        });
      }
    });
  }

  void _showScanSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              'Espresso Beans +5kg added to stock',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _generateAutoPurchase() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AutoPurchaseSheet(
        items: _allStockItems.where((i) => i['alert'] != 'ok').toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppTheme.background,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _openScanner,
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.qr_code_scanner_rounded, size: 22),
            label: Text(
              'Scan Product',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            elevation: 4,
          ),
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
                        const SizedBox(height: 16),
                        _buildSearchBar(),
                        const SizedBox(height: 20),
                        _buildLowStockAlerts(),
                        const SizedBox(height: 20),
                        _buildAiDemandCard(),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildWasteTracker()),
                            const SizedBox(width: 12),
                            Expanded(child: _buildUnitCostCard()),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildWeeklyConsumptionChart(),
                        const SizedBox(height: 20),
                        _buildPriceBenchmarkChart(),
                        const SizedBox(height: 20),
                        _buildExpiryMonitor(),
                        const SizedBox(height: 20),
                        _buildSupplierDirectory(),
                        const SizedBox(height: 20),
                        _buildAutoPurchaseButton(),
                        const SizedBox(height: 20),
                        _buildStockList(),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_showScannerOverlay) _buildScannerOverlay(),
      ],
    );
  }

  // ── Header ─────────────────────────────────────────────────
  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.inventory_2_rounded,
            color: AppTheme.primary,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Inventory',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.onSurface,
                ),
              ),
              Text(
                'Café Élite · Real-time stock',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.muted,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.errorContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: AppTheme.error,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                '5 Alerts',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.error,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Search Bar ─────────────────────────────────────────────
  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (v) => setState(() => _searchQuery = v),
      style: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        color: AppTheme.onSurface,
      ),
      decoration: InputDecoration(
        hintText: 'Search items — Milk, Syrups, Beans...',
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppTheme.muted,
          size: 20,
        ),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: AppTheme.muted,
                ),
                onPressed: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                },
              )
            : null,
        filled: true,
        fillColor: AppTheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primary, width: 2),
        ),
      ),
    );
  }

  // ── Low Stock Alerts ───────────────────────────────────────
  Widget _buildLowStockAlerts() {
    final alerts = _allStockItems.where((i) => i['alert'] != 'ok').toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(
          'Low Stock Alerts',
          Icons.notifications_active_rounded,
          AppTheme.error,
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 72,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: alerts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final item = alerts[i];
              final isCritical = item['alert'] == 'critical';
              final badgeColor = isCritical ? AppTheme.error : AppTheme.warning;
              final badgeBg = isCritical
                  ? AppTheme.errorContainer
                  : AppTheme.warningContainer;
              return Container(
                width: 150,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: badgeColor.withAlpha(77)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: badgeBg,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            isCritical ? '⚠ Critical' : '↓ Low',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: badgeColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      item['name'],
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      item['unit'],
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: badgeColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── AI Demand Forecasting ──────────────────────────────────
  Widget _buildAiDemandCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0097A7), Color(0xFF1565C0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(51),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'AI Demand Forecast',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(51),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Tomorrow',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '🌡 High demand for Iced Latte tomorrow due to 30°C weather forecast.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _aiChip(Icons.trending_up_rounded, '+38% orders expected'),
              const SizedBox(width: 8),
              _aiChip(Icons.inventory_rounded, 'Restock Oat Milk'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _aiChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(38),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withAlpha(64)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ── Waste Tracker ──────────────────────────────────────────
  Widget _buildWasteTracker() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Waste Tracker',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurface,
            ),
          ),
          Text(
            'Monthly',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: AppTheme.muted,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 28,
                sections: [
                  PieChartSectionData(
                    value: 12,
                    color: AppTheme.error,
                    title: '12%',
                    radius: 28,
                    titleStyle: GoogleFonts.plusJakartaSans(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: 88,
                    color: AppTheme.primaryContainer,
                    title: '',
                    radius: 24,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.error,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '12% wasted',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  color: AppTheme.muted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Unit Cost Analysis ─────────────────────────────────────
  Widget _buildUnitCostCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cost per Cup',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurface,
            ),
          ),
          Text(
            'Ingredient cost',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: AppTheme.muted,
            ),
          ),
          const SizedBox(height: 10),
          ..._costAnalysis.map((item) {
            final margin =
                ((item['price'] as double) - (item['cost'] as double)) /
                (item['price'] as double) *
                100;
            return Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item['drink'],
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppTheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${(item['cost'] as double).toStringAsFixed(2)}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.onSurface,
                        ),
                      ),
                      Text(
                        '${margin.toStringAsFixed(0)}% margin',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9,
                          color: AppTheme.success,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Weekly Consumption Chart ───────────────────────────────
  Widget _buildWeeklyConsumptionChart() {
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
          _sectionTitle(
            'Weekly Consumption',
            Icons.bar_chart_rounded,
            AppTheme.primary,
          ),
          const SizedBox(height: 4),
          Text(
            'Top ingredient usage this week (kg)',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: AppTheme.muted,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 35,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= _weekDays.length) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          _weekDays[idx],
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            color: AppTheme.muted,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) =>
                      FlLine(color: AppTheme.outlineVariant, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(_weeklyConsumption.length, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: _weeklyConsumption[i],
                        color: i == 4
                            ? AppTheme.primary
                            : AppTheme.primaryContainer,
                        width: 22,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Price Benchmark Chart ──────────────────────────────────
  Widget _buildPriceBenchmarkChart() {
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
          _sectionTitle(
            'Price Benchmark',
            Icons.compare_arrows_rounded,
            AppTheme.secondary,
          ),
          const SizedBox(height: 4),
          Text(
            'Our price vs. market average (per unit)',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: AppTheme.muted,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _legendDot(AppTheme.primary, 'Ours'),
              const SizedBox(width: 12),
              _legendDot(AppTheme.outline, 'Market'),
            ],
          ),
          const SizedBox(height: 12),
          ..._benchmarkData.map((item) {
            final ours = item['ours'] as double;
            final market = item['market'] as double;
            final maxVal = math.max(ours, market) * 1.2;
            final isCheaper = ours <= market;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item['item'],
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.onSurface,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isCheaper
                              ? AppTheme.successContainer
                              : AppTheme.errorContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          isCheaper ? '✓ Cheaper' : '↑ Pricier',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: isCheaper
                                ? AppTheme.success
                                : AppTheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  _benchmarkBar(
                    'Ours \$${ours.toStringAsFixed(2)}',
                    ours / maxVal,
                    AppTheme.primary,
                  ),
                  const SizedBox(height: 3),
                  _benchmarkBar(
                    'Mkt \$${market.toStringAsFixed(2)}',
                    market / maxVal,
                    AppTheme.outline,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _benchmarkBar(String label, double ratio, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              color: AppTheme.muted,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              backgroundColor: AppTheme.outlineVariant,
              color: color,
              minHeight: 8,
            ),
          ),
        ),
      ],
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: AppTheme.muted,
          ),
        ),
      ],
    );
  }

  // ── Expiry Monitor ─────────────────────────────────────────
  Widget _buildExpiryMonitor() {
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
          _sectionTitle(
            'Expiry Monitor',
            Icons.timer_outlined,
            AppTheme.warning,
          ),
          const SizedBox(height: 12),
          ..._expiryItems.map((item) {
            final urgent = item['urgent'] as bool;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: urgent
                    ? AppTheme.errorContainer.withAlpha(128)
                    : AppTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: urgent
                      ? AppTheme.error.withAlpha(77)
                      : AppTheme.outlineVariant,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    urgent
                        ? Icons.warning_amber_rounded
                        : Icons.access_time_rounded,
                    color: urgent ? AppTheme.error : AppTheme.muted,
                    size: 16,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item['name'],
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.onSurface,
                      ),
                    ),
                  ),
                  Text(
                    item['expiry'],
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: urgent ? AppTheme.error : AppTheme.muted,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Supplier Directory ─────────────────────────────────────
  Widget _buildSupplierDirectory() {
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
          _sectionTitle(
            'Supplier Directory',
            Icons.local_shipping_outlined,
            AppTheme.primary,
          ),
          const SizedBox(height: 12),
          ..._suppliers.map((s) => _supplierTile(s)),
        ],
      ),
    );
  }

  Widget _supplierTile(Map<String, dynamic> s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
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
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.storefront_rounded,
                  color: AppTheme.primary,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s['name'],
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.onSurface,
                      ),
                    ),
                    Text(
                      s['category'],
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppTheme.muted,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: Color(0xFFF59E0B),
                    size: 14,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${s['rating']}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showContactSnackbar(s['name'], 'Call'),
                  icon: const Icon(Icons.phone_rounded, size: 14),
                  label: const Text('Call'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primary,
                    side: const BorderSide(color: AppTheme.primary),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    textStyle: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showContactSnackbar(s['name'], 'Order'),
                  icon: const Icon(Icons.shopping_cart_rounded, size: 14),
                  label: const Text('Order'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 36),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    textStyle: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showContactSnackbar(String name, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$action request sent to $name',
          style: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.white),
        ),
        backgroundColor: AppTheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ── Auto-Purchase Button ───────────────────────────────────
  Widget _buildAutoPurchaseButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _generateAutoPurchase,
        icon: const Icon(Icons.auto_fix_high_rounded, size: 18),
        label: const Text('Generate Auto-Purchase Draft'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.secondary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ── Stock List (filtered) ──────────────────────────────────
  Widget _buildStockList() {
    final items = _filteredItems;
    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.outlineVariant),
        ),
        child: Center(
          child: Text(
            'No items found for "$_searchQuery"',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppTheme.muted,
            ),
          ),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: _sectionTitle(
              'All Stock Items',
              Icons.list_alt_rounded,
              AppTheme.primary,
            ),
          ),
          const Divider(height: 1, color: AppTheme.outlineVariant),
          ...items.asMap().entries.map((entry) {
            final i = entry.key;
            final item = entry.value;
            final level = item['level'] as double;
            final alert = item['alert'] as String;
            final barColor = alert == 'critical'
                ? AppTheme.error
                : alert == 'low'
                ? AppTheme.warning
                : AppTheme.success;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'],
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: level,
                                backgroundColor: AppTheme.outlineVariant,
                                color: barColor,
                                minHeight: 5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        item['unit'],
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: barColor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (i < items.length - 1)
                  const Divider(
                    height: 1,
                    indent: 16,
                    color: AppTheme.outlineVariant,
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  // ── Scanner Overlay ────────────────────────────────────────
  Widget _buildScannerOverlay() {
    return Positioned.fill(
      child: Material(
        color: Colors.black87,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () =>
                          setState(() => _showScannerOverlay = false),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Scan Product Barcode',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              const Spacer(),
              Center(
                child: _scanComplete
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppTheme.success,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Product Scanned!',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Espresso Beans +5kg',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      )
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 240,
                            height: 240,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppTheme.primary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          AnimatedBuilder(
                            animation: _scanLineAnim,
                            builder: (_, __) {
                              return Positioned(
                                top: _scanLineAnim.value * 220,
                                child: Container(
                                  width: 240,
                                  height: 2,
                                  color: AppTheme.primary.withAlpha(204),
                                ),
                              );
                            },
                          ),
                          Positioned(top: 0, left: 0, child: _cornerDecor()),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(math.pi),
                              child: _cornerDecor(),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationX(math.pi),
                              child: _cornerDecor(),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationZ(math.pi),
                              child: _cornerDecor(),
                            ),
                          ),
                        ],
                      ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Text(
                  _scanComplete
                      ? 'Adding to stock...'
                      : 'Point camera at product barcode',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: Colors.white60,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cornerDecor() {
    return Container(
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppTheme.primary, width: 3),
          left: BorderSide(color: AppTheme.primary, width: 3),
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────
  Widget _sectionTitle(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 6),
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.onSurface,
          ),
        ),
      ],
    );
  }
}

// ── Auto-Purchase Bottom Sheet ─────────────────────────────
class _AutoPurchaseSheet extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  const _AutoPurchaseSheet({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.auto_fix_high_rounded,
                color: AppTheme.secondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Auto-Purchase Draft',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Based on current low stock levels',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppTheme.muted,
            ),
          ),
          const SizedBox(height: 16),
          ...items.map((item) {
            final isCritical = item['alert'] == 'critical';
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    isCritical
                        ? Icons.priority_high_rounded
                        : Icons.arrow_upward_rounded,
                    color: isCritical ? AppTheme.error : AppTheme.warning,
                    size: 16,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item['name'],
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.onSurface,
                      ),
                    ),
                  ),
                  Text(
                    'Reorder 10 units',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.secondary,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Purchase draft sent to suppliers!',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: AppTheme.success,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.send_rounded, size: 16),
              label: const Text('Send to Suppliers'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.secondary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: GoogleFonts.plusJakartaSans(
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
