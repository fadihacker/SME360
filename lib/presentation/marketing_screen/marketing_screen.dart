import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

class MarketingScreen extends StatefulWidget {
  const MarketingScreen({super.key});

  @override
  State<MarketingScreen> createState() => _MarketingScreenState();
}

class _MarketingScreenState extends State<MarketingScreen>
    with SingleTickerProviderStateMixin {
  bool _smsSent = false;
  bool _emailSent = false;

  final List<Map<String, dynamic>> _vipCustomers = [
    {
      'name': 'Sophia Laurent',
      'visits': 28,
      'spent': '\$312',
      'avatar': 'SL',
      'badge': '👑',
    },
    {
      'name': 'Marcus Chen',
      'visits': 24,
      'spent': '\$278',
      'avatar': 'MC',
      'badge': '⭐',
    },
    {
      'name': 'Isabelle Moreau',
      'visits': 21,
      'spent': '\$245',
      'avatar': 'IM',
      'badge': '⭐',
    },
    {
      'name': 'James Okafor',
      'visits': 19,
      'spent': '\$218',
      'avatar': 'JO',
      'badge': '🏅',
    },
    {
      'name': 'Priya Sharma',
      'visits': 17,
      'spent': '\$196',
      'avatar': 'PS',
      'badge': '🏅',
    },
  ];

  final List<Map<String, dynamic>> _promotionCalendar = [
    {
      'title': 'Summer Iced Series Launch',
      'date': 'Jun 1 – Aug 31',
      'icon': Icons.wb_sunny_rounded,
      'color': Color(0xFFFF8F00),
      'items': 'Mango Cold Brew, Coconut Iced Latte, Citrus Fizz',
    },
    {
      'title': 'Back-to-School Boost',
      'date': 'Sep 1 – Sep 15',
      'icon': Icons.school_rounded,
      'color': Color(0xFF1565C0),
      'items': '20% off for students with valid ID',
    },
    {
      'title': 'Autumn Harvest Menu',
      'date': 'Oct 1 – Nov 30',
      'icon': Icons.eco_rounded,
      'color': Color(0xFF6D4C41),
      'items': 'Pumpkin Spice Latte, Apple Cider, Cinnamon Roll',
    },
    {
      'title': 'Holiday Festive Collection',
      'date': 'Dec 1 – Dec 31',
      'icon': Icons.celebration_rounded,
      'color': Color(0xFFC62828),
      'items': 'Peppermint Mocha, Gingerbread Latte, Hot Cocoa',
    },
  ];

  void _launchSms() async {
    setState(() => _smsSent = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _smsSent = false);
  }

  void _launchEmail() async {
    setState(() => _emailSent = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _emailSent = false);
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
                    const SizedBox(height: 20),
                    _buildLoyaltyTracker(),
                    const SizedBox(height: 20),
                    _buildCampaignBuilder(),
                    const SizedBox(height: 20),
                    _buildVipCustomers(),
                    const SizedBox(height: 20),
                    _buildReferralProgram(),
                    const SizedBox(height: 20),
                    _buildSocialMediaAnalytics(),
                    const SizedBox(height: 20),
                    _buildPromotionCalendar(),
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

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Marketing & Loyalty',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.onSurface,
                ),
              ),
              Text(
                'Café Élite · Grow your customer base',
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
              const Icon(Icons.campaign_rounded, color: Colors.white, size: 14),
              const SizedBox(width: 4),
              Text(
                'Active',
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

  // ── 1. Loyalty Program Tracker ─────────────────────────────
  Widget _buildLoyaltyTracker() {
    return _MarketingCard(
      title: 'Loyalty Program Tracker',
      subtitle: 'Élite Members overview',
      icon: Icons.card_giftcard_rounded,
      child: Column(
        children: [
          Row(
            children: [
              _buildLoyaltyStat(
                '👑',
                '1,284',
                'Elite Members',
                AppTheme.primary,
                AppTheme.primaryContainer,
              ),
              const SizedBox(width: 12),
              _buildLoyaltyStat(
                '⭐',
                '48,620',
                'Points Issued',
                AppTheme.secondary,
                AppTheme.secondaryContainer,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildLoyaltyStat(
                '🎁',
                '342',
                'Rewards Redeemed',
                AppTheme.success,
                AppTheme.successContainer,
              ),
              const SizedBox(width: 12),
              _buildLoyaltyStat(
                '📈',
                '26.6%',
                'Redemption Rate',
                AppTheme.warning,
                AppTheme.warningContainer,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: AppTheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Members spend 2.4× more than non-members on average',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppTheme.onSurfaceVariant,
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

  Widget _buildLoyaltyStat(
    String emoji,
    String value,
    String label,
    Color color,
    Color bg,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── 2. Smart Campaign Builder ──────────────────────────────
  Widget _buildCampaignBuilder() {
    return _MarketingCard(
      title: 'Smart Campaign Builder',
      subtitle: 'Launch targeted promotions instantly',
      icon: Icons.send_rounded,
      child: Column(
        children: [
          _buildCampaignButton(
            icon: Icons.sms_rounded,
            label: _smsSent
                ? '✓ SMS Campaign Launched!'
                : 'Launch SMS Discount',
            subtitle: 'Send 15% off to 1,284 members',
            color: AppTheme.primary,
            bg: AppTheme.primaryContainer,
            sent: _smsSent,
            onTap: _launchSms,
          ),
          const SizedBox(height: 10),
          _buildCampaignButton(
            icon: Icons.email_rounded,
            label: _emailSent
                ? '✓ Email Campaign Sent!'
                : 'Email Weekend Offer',
            subtitle: 'Weekend brunch special to all subscribers',
            color: AppTheme.secondary,
            bg: AppTheme.secondaryContainer,
            sent: _emailSent,
            onTap: _launchEmail,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.outlineVariant),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.schedule_rounded,
                  size: 16,
                  color: AppTheme.muted,
                ),
                const SizedBox(width: 8),
                Text(
                  'Next scheduled: Friday 6PM push notification',
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

  Widget _buildCampaignButton({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required Color bg,
    required bool sent,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: sent ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: sent ? AppTheme.successContainer : bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: sent ? AppTheme.success.withAlpha(80) : color.withAlpha(60),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: sent ? AppTheme.success : color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                sent ? Icons.check_rounded : icon,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: sent ? AppTheme.success : AppTheme.onSurface,
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
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: sent ? AppTheme.success : AppTheme.muted,
            ),
          ],
        ),
      ),
    );
  }

  // ── 3. Top VIP Customers ───────────────────────────────────
  Widget _buildVipCustomers() {
    return _MarketingCard(
      title: 'Top Customers',
      subtitle: 'Most frequent visitors this month',
      icon: Icons.star_rounded,
      child: Column(
        children: _vipCustomers.asMap().entries.map((entry) {
          final i = entry.key;
          final c = entry.value;
          return Padding(
            padding: EdgeInsets.only(
              bottom: i < _vipCustomers.length - 1 ? 10 : 0,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primary, AppTheme.secondary],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      c['avatar'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            c['name'] as String,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.onSurface,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            c['badge'] as String,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      Text(
                        '${c['visits']} visits this month',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: AppTheme.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    c['spent'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── 4. Referral Program ────────────────────────────────────
  Widget _buildReferralProgram() {
    return _MarketingCard(
      title: 'Referral Program',
      subtitle: 'Invite a Friend rewards',
      icon: Icons.group_add_rounded,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF006978), Color(0xFF1565C0)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Text('🎉', style: TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Invite a Friend',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'You get 500 pts · Friend gets a free coffee',
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
          const SizedBox(height: 12),
          Row(
            children: [
              _buildReferralStat('156', 'Referrals\nThis Month'),
              const SizedBox(width: 12),
              _buildReferralStat('89', 'Converted\nCustomers'),
              const SizedBox(width: 12),
              _buildReferralStat('57.1%', 'Conversion\nRate'),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primary,
                side: const BorderSide(color: AppTheme.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: const Icon(Icons.share_rounded, size: 16),
              label: Text(
                'Share Referral Link',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferralStat(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                color: AppTheme.muted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ── 5. Social Media Analytics ──────────────────────────────
  Widget _buildSocialMediaAnalytics() {
    return _MarketingCard(
      title: 'Social Media Analytics',
      subtitle: 'Instagram & Facebook engagement',
      icon: Icons.thumb_up_rounded,
      child: Column(
        children: [
          Row(
            children: [
              _buildSocialCard(
                '📸',
                'Instagram',
                '4,820',
                'Followers',
                '+12%',
                true,
                [0.4, 0.6, 0.5, 0.7, 0.8, 0.65, 0.9],
                AppTheme.primary,
              ),
              const SizedBox(width: 12),
              _buildSocialCard(
                '👍',
                'Facebook',
                '2,340',
                'Page Likes',
                '+6%',
                true,
                [0.5, 0.4, 0.6, 0.5, 0.7, 0.6, 0.75],
                AppTheme.secondary,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.trending_up_rounded,
                  size: 16,
                  color: AppTheme.success,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Best performing post: "Summer Iced Series" — 842 likes, 124 shares',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppTheme.onSurfaceVariant,
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

  Widget _buildSocialCard(
    String emoji,
    String platform,
    String count,
    String metric,
    String change,
    bool positive,
    List<double> trend,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withAlpha(15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(50)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 6),
                Text(
                  platform,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              count,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.onSurface,
              ),
            ),
            Text(
              metric,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                color: AppTheme.muted,
              ),
            ),
            const SizedBox(height: 6),
            // Mini trend bars
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: trend.map((v) {
                return Expanded(
                  child: Container(
                    height: 20 * v,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                      color: color.withAlpha(180),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: positive
                    ? AppTheme.successContainer
                    : AppTheme.errorContainer,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '$change this week',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: positive ? AppTheme.success : AppTheme.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── 6. Promotion Calendar ──────────────────────────────────
  Widget _buildPromotionCalendar() {
    return _MarketingCard(
      title: 'Promotion Calendar',
      subtitle: 'Upcoming seasonal drinks & events',
      icon: Icons.calendar_month_rounded,
      child: Column(
        children: _promotionCalendar.asMap().entries.map((entry) {
          final i = entry.key;
          final promo = entry.value;
          return Padding(
            padding: EdgeInsets.only(
              bottom: i < _promotionCalendar.length - 1 ? 10 : 0,
            ),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (promo['color'] as Color).withAlpha(12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: (promo['color'] as Color).withAlpha(50),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (promo['color'] as Color).withAlpha(25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      promo['icon'] as IconData,
                      color: promo['color'] as Color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          promo['title'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.onSurface,
                          ),
                        ),
                        Text(
                          promo['date'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: promo['color'] as Color,
                          ),
                        ),
                        Text(
                          promo['items'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: AppTheme.muted,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Marketing Card ─────────────────────────────────────────
class _MarketingCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;

  const _MarketingCard({
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
