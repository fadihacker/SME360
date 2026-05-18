import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../theme/app_theme.dart';

class RevenueChartWidget extends StatefulWidget {
  const RevenueChartWidget({super.key});

  @override
  State<RevenueChartWidget> createState() => _RevenueChartWidgetState();
}

class _RevenueChartWidgetState extends State<RevenueChartWidget>
    with SingleTickerProviderStateMixin {
  // TODO: Replace with Riverpod/Bloc for production
  late AnimationController _controller;
  late Animation<double> _animation;
  int _selectedFilter = 0; // 0=7D, 1=30D, 2=90D

  final List<String> _filters = ['7 Days', '30 Days', '90 Days'];

  // 7-day revenue data (realistic variance, not smooth upward)
  final List<FlSpot> _sevenDayData = const [
    FlSpot(0, 3.2),
    FlSpot(1, 4.1),
    FlSpot(2, 3.6),
    FlSpot(3, 4.8),
    FlSpot(4, 3.9),
    FlSpot(5, 5.2),
    FlSpot(6, 4.6),
  ];

  final List<FlSpot> _thirtyDayData = const [
    FlSpot(0, 3.0),
    FlSpot(1, 3.4),
    FlSpot(2, 2.8),
    FlSpot(3, 3.7),
    FlSpot(4, 4.1),
    FlSpot(5, 3.5),
    FlSpot(6, 4.4),
    FlSpot(7, 4.9),
    FlSpot(8, 3.8),
    FlSpot(9, 4.2),
    FlSpot(10, 4.7),
    FlSpot(11, 3.9),
    FlSpot(12, 5.1),
    FlSpot(13, 4.6),
    FlSpot(14, 4.3),
  ];

  final List<FlSpot> _ninetyDayData = const [
    FlSpot(0, 2.8),
    FlSpot(1, 3.2),
    FlSpot(2, 3.5),
    FlSpot(3, 4.0),
    FlSpot(4, 3.6),
    FlSpot(5, 4.3),
    FlSpot(6, 3.9),
    FlSpot(7, 4.8),
    FlSpot(8, 4.2),
    FlSpot(9, 4.6),
    FlSpot(10, 5.0),
    FlSpot(11, 4.4),
  ];

  final List<List<String>> _xLabels = [
    ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    [
      'W1',
      'W2',
      'W3',
      'W4',
      'W5',
      'W6',
      'W7',
      'W8',
      'W9',
      'W10',
      'W11',
      'W12',
      'W13',
      'W14',
      'W15',
    ],
    [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ],
  ];

  List<FlSpot> get _activeData {
    switch (_selectedFilter) {
      case 1:
        return _thirtyDayData;
      case 2:
        return _ninetyDayData;
      default:
        return _sevenDayData;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Revenue Trend',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.onSurface,
                      ),
                    ),
                    Text(
                      'Daily sales (USD thousands)',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppTheme.muted,
                      ),
                    ),
                  ],
                ),
              ),
              // Filter chips
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(_filters.length, (i) {
                  final selected = i == _selectedFilter;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedFilter = i);
                      _controller.reset();
                      _controller.forward();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(left: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppTheme.primary
                            : AppTheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _filters[i],
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: selected ? Colors.white : AppTheme.muted,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Chart
          SizedBox(
            height: isTablet ? 220 : 180,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, _) {
                return LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: 7,
                    clipData: const FlClipData.all(),
                    gridData: FlGridData(
                      drawVerticalLine: false,
                      horizontalInterval: 1,
                      getDrawingHorizontalLine: (_) => FlLine(
                        color: AppTheme.outlineVariant,
                        strokeWidth: 1,
                        dashArray: [4, 4],
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
                          interval: 2,
                          getTitlesWidget: (v, _) => Text(
                            '\$${v.toInt()}k',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              color: AppTheme.muted,
                            ),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (v, _) {
                            final labels = _xLabels[_selectedFilter];
                            final idx = v.toInt();
                            if (idx < 0 || idx >= labels.length) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                labels[idx],
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  color: AppTheme.muted,
                                ),
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
                    lineBarsData: [
                      LineChartBarData(
                        spots: _activeData
                            .map((s) => FlSpot(s.x, s.y * _animation.value))
                            .toList(),
                        isCurved: true,
                        curveSmoothness: 0.3,
                        color: AppTheme.primary,
                        barWidth: 2.5,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 3.5,
                              color: AppTheme.primary,
                              strokeWidth: 2,
                              strokeColor: Colors.white,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.primary.withAlpha(60),
                              AppTheme.primary.withAlpha(0),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: AppTheme.onSurface,
                        tooltipRoundedRadius: 8,
                        getTooltipItems: (spots) => spots
                            .map(
                              (s) => LineTooltipItem(
                                '\$${(s.y).toStringAsFixed(1)}k',
                                GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),
          // Summary row
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _summaryChip(
                Icons.arrow_upward_rounded,
                'Peak: Sat \$5.2k',
                AppTheme.success,
                AppTheme.successContainer,
              ),
              _summaryChip(
                Icons.arrow_downward_rounded,
                'Low: Mon \$3.2k',
                AppTheme.warning,
                AppTheme.warningContainer,
              ),
              _summaryChip(
                Icons.show_chart_rounded,
                'Avg: \$4.2k/day',
                AppTheme.primary,
                AppTheme.primaryContainer,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryChip(IconData icon, String label, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}