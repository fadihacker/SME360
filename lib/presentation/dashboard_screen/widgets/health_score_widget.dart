import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../theme/app_theme.dart';

class HealthScoreWidget extends StatefulWidget {
  const HealthScoreWidget({super.key});

  @override
  State<HealthScoreWidget> createState() => _HealthScoreWidgetState();
}

class _HealthScoreWidgetState extends State<HealthScoreWidget>
    with SingleTickerProviderStateMixin {
  // TODO: Replace with Riverpod/Bloc for production
  late AnimationController _controller;
  late Animation<double> _scoreAnim;

  static const double _healthScore = 78.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scoreAnim = Tween<double>(
      begin: 0,
      end: _healthScore,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _scoreColor(double score) {
    if (score >= 80) return AppTheme.success;
    if (score >= 60) return AppTheme.primary;
    if (score >= 40) return AppTheme.warning;
    return AppTheme.error;
  }

  String _scoreLabel(double score) {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Needs Attention';
    return 'Critical';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF006978), Color(0xFF0097A7), Color(0xFF1565C0)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withAlpha(80),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            // Radial chart
            SizedBox(
              width: 110,
              height: 110,
              child: AnimatedBuilder(
                animation: _scoreAnim,
                builder: (context, _) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          startDegreeOffset: -90,
                          sectionsSpace: 0,
                          centerSpaceRadius: 38,
                          sections: [
                            PieChartSectionData(
                              value: _scoreAnim.value,
                              color: Colors.white,
                              radius: 14,
                              showTitle: false,
                            ),
                            PieChartSectionData(
                              value: 100 - _scoreAnim.value,
                              color: Colors.white.withAlpha(40),
                              radius: 10,
                              showTitle: false,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _scoreAnim.value.toInt().toString(),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                          Text(
                            '/ 100',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Business Health Score',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 6),
                  AnimatedBuilder(
                    animation: _scoreAnim,
                    builder: (context, _) => Text(
                      _scoreLabel(_scoreAnim.value),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Score breakdown pills
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _scorePill('Revenue', '+12%', true),
                      _scorePill('Retention', '68%', true),
                      _scorePill('Market Share', '-2%', false),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Updated Mar 31, 2026 · 2:51 PM',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _scorePill(String label, String value, bool positive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            positive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
            size: 11,
            color: positive ? const Color(0xFF80FFB8) : const Color(0xFFFFB3B3),
          ),
          const SizedBox(width: 4),
          Text(
            '$label $value',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
