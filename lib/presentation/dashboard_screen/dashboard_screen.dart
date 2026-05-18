import '../../core/app_export.dart';
import '../../widgets/app_navigation.dart';
import '../account_screen/account_screen.dart';
import '../business_intelligence_screen/business_intelligence_screen.dart';
import '../inventory_screen/inventory_screen.dart';
import '../marketing_screen/marketing_screen.dart';
import './widgets/ai_teaser_widget.dart';
import './widgets/dashboard_header_widget.dart';
import './widgets/health_score_widget.dart';
import './widgets/kpi_grid_widget.dart';
import './widgets/revenue_chart_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _navIndex = 0;

  final List<Widget> _screens = const [
    _DashboardContent(),
    InventoryScreen(),
    BusinessIntelligenceScreen(),
    MarketingScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    if (isTablet) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        body: SafeArea(
          child: Row(
            children: [
              AppNavigationRail(
                currentIndex: _navIndex,
                onDestinationSelected: (i) => setState(() => _navIndex = i),
              ),
              Container(width: 1, color: AppTheme.outlineVariant),
              Expanded(child: _screens[_navIndex]),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(child: _screens[_navIndex]),
      bottomNavigationBar: AppNavigation(
        currentIndex: _navIndex,
        onDestinationSelected: (i) => setState(() => _navIndex = i),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppTheme.primary,
      onRefresh: () async {
        await Future.delayed(const Duration(milliseconds: 800));
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DashboardHeaderWidget(),
                  const SizedBox(height: 20),
                  const HealthScoreWidget(),
                  const SizedBox(height: 20),
                  const KpiGridWidget(),
                  const SizedBox(height: 20),
                  const RevenueChartWidget(),
                  const SizedBox(height: 20),
                  const AiTeaserWidget(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
