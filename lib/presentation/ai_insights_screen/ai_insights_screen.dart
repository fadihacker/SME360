import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import './widgets/ai_card_widget.dart';

class AiInsightsScreen extends StatefulWidget {
  const AiInsightsScreen({super.key});

  @override
  State<AiInsightsScreen> createState() => _AiInsightsScreenState();
}

class _AiInsightsScreenState extends State<AiInsightsScreen> {
  // TODO: Replace with Riverpod/Bloc for production
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
          'Peak orders occur between 7:30–9:00 AM but average wait time is 6.2 minutes — 40% above the 4.5-minute customer satisfaction threshold. Adding one barista during peak hours reduces wait time and recovers lost sales.',
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
          'Cafés with rotating seasonal menus see 18% higher avg order values and generate social media buzz organically. A spring menu featuring 3–4 limited items can drive trial purchases and repeat visits.',
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
          'Your Google Business profile has 34% fewer photos and 60% fewer reviews than the top 3 local café competitors. Businesses that respond to all reviews and post weekly see a 28% increase in profile-driven foot traffic.',
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
          'There are 12 office buildings within 600m of Café Élite. A monthly corporate coffee subscription or catering package could generate \$800–\$1,500 in predictable recurring revenue per account.',
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
    _recommendations = List<Map<String, dynamic>>.from(
      _recommendationMaps.map((m) => Map<String, dynamic>.from(m)),
    );
  }

  void _toggleExpanded(int index) {
    setState(() {
      _recommendations[index]['isExpanded'] =
          !(_recommendations[index]['isExpanded'] as bool);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: AppTheme.background,
          elevation: 0,
          scrolledUnderElevation: 1,
          surfaceTintColor: AppTheme.primary,
          floating: true,
          snap: true,
          title: Text(
            'AI Insights',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.onSurface,
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.auto_awesome_rounded,
                    size: 14,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '5 recommendations',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Context banner
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
                const SizedBox(height: 20),
                Text(
                  'Growth Recommendations',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, i) {
            return Padding(
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
            );
          }, childCount: _recommendations.length),
        ),
      ],
    );
  }
}
