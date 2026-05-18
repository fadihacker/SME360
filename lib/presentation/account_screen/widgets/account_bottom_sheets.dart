import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/status_badge_widget.dart';

class AccountBottomSheets {
  static void show(BuildContext context, String sheetType) {
    switch (sheetType) {
      case 'user_profile':
        _showUserProfile(context);
        break;
      case 'business_details':
        _showBusinessDetails(context);
        break;
      case 'subscription':
        _showSubscription(context);
        break;
      case 'notifications':
        _showNotifications(context);
        break;
      case 'team':
        _showTeam(context);
        break;
      case 'export':
        _showExport(context);
        break;
      case 'currency_language':
        _showCurrencyLanguage(context);
        break;
      case 'activity_log':
        _showActivityLog(context);
        break;
      case 'security':
        _showSecurity(context);
        break;
    }
  }

  static void _showUserProfile(BuildContext context) {
    _showSheet(
      context,
      title: 'User Profile',
      icon: Icons.person_rounded,
      child: _UserProfileSheet(),
    );
  }

  static void _showBusinessDetails(BuildContext context) {
    _showSheet(
      context,
      title: 'Business Details',
      icon: Icons.store_rounded,
      child: const _BusinessDetailsSheet(),
    );
  }

  static void _showSubscription(BuildContext context) {
    _showSheet(
      context,
      title: 'Subscription Management',
      icon: Icons.credit_card_rounded,
      child: const _SubscriptionSheet(),
    );
  }

  static void _showNotifications(BuildContext context) {
    _showSheet(
      context,
      title: 'Notification Preferences',
      icon: Icons.notifications_rounded,
      child: _NotificationsSheet(),
    );
  }

  static void _showTeam(BuildContext context) {
    _showSheet(
      context,
      title: 'Team Management',
      icon: Icons.group_rounded,
      child: const _TeamSheet(),
    );
  }

  static void _showExport(BuildContext context) {
    _showSheet(
      context,
      title: 'Data Export',
      icon: Icons.download_rounded,
      child: const _ExportSheet(),
    );
  }

  static void _showCurrencyLanguage(BuildContext context) {
    _showSheet(
      context,
      title: 'Currency & Language',
      icon: Icons.language_rounded,
      child: _CurrencyLanguageSheet(),
    );
  }

  static void _showActivityLog(BuildContext context) {
    _showSheet(
      context,
      title: 'Activity Log',
      icon: Icons.history_rounded,
      child: const _ActivityLogSheet(),
    );
  }

  static void _showSecurity(BuildContext context) {
    _showSheet(
      context,
      title: 'Security & Password',
      icon: Icons.security_rounded,
      child: _SecuritySheet(),
    );
  }

  static void _showSheet(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, size: 20, color: AppTheme.primary),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        size: 22,
                        color: AppTheme.muted,
                      ),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              Container(height: 1, color: AppTheme.outlineVariant),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── User Profile Sheet ─────────────────────────────────────────
class _UserProfileSheet extends StatefulWidget {
  @override
  State<_UserProfileSheet> createState() => _UserProfileSheetState();
}

class _UserProfileSheetState extends State<_UserProfileSheet> {
  final _nameCtrl = TextEditingController(text: 'Sofia Espinoza');
  final _emailCtrl = TextEditingController(text: 'sme360@app.com');
  final _phoneCtrl = TextEditingController(text: '+1 (555) 248-3901');

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primary, AppTheme.secondary],
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Center(
                  child: Text(
                    'SE',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.surface, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _fieldLabel('Full Name'),
        const SizedBox(height: 8),
        _field(_nameCtrl, 'Enter full name', Icons.person_outline_rounded),
        const SizedBox(height: 16),
        _fieldLabel('Email Address'),
        const SizedBox(height: 8),
        _field(
          _emailCtrl,
          'Enter email',
          Icons.email_outlined,
          type: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        _fieldLabel('Phone Number'),
        const SizedBox(height: 8),
        _field(
          _phoneCtrl,
          'Enter phone',
          Icons.phone_outlined,
          type: TextInputType.phone,
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              'Save Changes',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _fieldLabel(String label) => Text(
    label,
    style: GoogleFonts.plusJakartaSans(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: AppTheme.onSurface,
    ),
  );

  Widget _field(
    TextEditingController ctrl,
    String hint,
    IconData icon, {
    TextInputType type = TextInputType.text,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: type,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        color: AppTheme.onSurface,
      ),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, size: 20, color: AppTheme.muted),
        filled: true,
        fillColor: AppTheme.surfaceVariant,
      ),
    );
  }
}

// ── Business Details Sheet ─────────────────────────────────────
class _BusinessDetailsSheet extends StatelessWidget {
  const _BusinessDetailsSheet();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoRow(Icons.store_rounded, 'Business Name', 'Café Élite'),
        _divider(),
        _infoRow(Icons.category_rounded, 'Business Type', 'Café / Coffee Shop'),
        _divider(),
        _infoRow(Icons.calendar_today_rounded, 'Established', '2019'),
        _divider(),
        _infoRow(
          Icons.location_on_rounded,
          'Address',
          '142 Maple Ave, Portland, OR 97201',
        ),
        _divider(),
        _infoRow(Icons.phone_rounded, 'Business Phone', '+1 (555) 320-4812'),
        _divider(),
        _infoRow(Icons.language_rounded, 'Website', 'cafeelite.com'),
        _divider(),
        _infoRow(Icons.people_rounded, 'Team Size', '8 employees'),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.verified_rounded,
                size: 18,
                color: AppTheme.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Business verified by SME360 · Profile 85% complete',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.edit_rounded, size: 18),
            label: Text(
              'Edit Business Details',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primary,
              side: const BorderSide(color: AppTheme.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppTheme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppTheme.muted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() =>
      const Divider(height: 1, color: AppTheme.outlineVariant, indent: 50);
}

// ── Subscription Sheet ─────────────────────────────────────────
class _SubscriptionSheet extends StatelessWidget {
  const _SubscriptionSheet();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Current plan card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF006978), Color(0xFF1565C0)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.workspace_premium_rounded,
                    size: 24,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'SME360 Pro',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  const StatusBadgeWidget(
                    label: 'Active',
                    status: BadgeStatus.success,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '\$49.00 / month',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Next renewal: April 30, 2026',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Plan Features',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        ...[
          'Unlimited AI business recommendations',
          'Advanced revenue analytics & forecasting',
          'Market share benchmarking vs local cafés',
          'Up to 5 team members',
          'PDF & CSV data exports',
          'Priority email support',
        ].map(
          (f) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: AppTheme.successContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 13,
                    color: AppTheme.success,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  f,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppTheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Mock payment info
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.outlineVariant),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.secondary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'VISA',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '•••• •••• •••• 4821',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.onSurface,
                      ),
                    ),
                    Text(
                      'Expires 08/28',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppTheme.muted,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Update',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.infoContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: AppTheme.info,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Mock payment service active. No real charges will occur.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppTheme.info,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.error,
              side: const BorderSide(color: AppTheme.error),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(
              'Cancel Subscription',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Notifications Sheet ────────────────────────────────────────
class _NotificationsSheet extends StatefulWidget {
  @override
  State<_NotificationsSheet> createState() => _NotificationsSheetState();
}

class _NotificationsSheetState extends State<_NotificationsSheet> {
  // TODO: Replace with Riverpod/Bloc for production
  final List<Map<String, dynamic>> _toggles = [
    {
      'label': 'Revenue Alerts',
      'subtitle': 'Notify when daily revenue drops >15%',
      'icon': Icons.attach_money_rounded,
      'value': true,
    },
    {
      'label': 'Weekly Business Digest',
      'subtitle': 'Every Monday at 8:00 AM',
      'icon': Icons.summarize_rounded,
      'value': true,
    },
    {
      'label': 'New AI Recommendations',
      'subtitle': 'When new insights are available',
      'icon': Icons.auto_awesome_rounded,
      'value': true,
    },
    {
      'label': 'Market Share Changes',
      'subtitle': 'When your share moves ±2%',
      'icon': Icons.pie_chart_rounded,
      'value': false,
    },
    {
      'label': 'Team Activity',
      'subtitle': 'When team members log in or export data',
      'icon': Icons.group_rounded,
      'value': false,
    },
    {
      'label': 'Subscription Reminders',
      'subtitle': '7 days before renewal',
      'icon': Icons.credit_card_rounded,
      'value': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _toggles.asMap().entries.map((entry) {
        final i = entry.key;
        final item = entry.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 4,
              ),
              secondary: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  item['icon'] as IconData,
                  size: 18,
                  color: AppTheme.primary,
                ),
              ),
              title: Text(
                item['label'] as String,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurface,
                ),
              ),
              subtitle: Text(
                item['subtitle'] as String,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppTheme.muted,
                ),
              ),
              value: item['value'] as bool,
              activeThumbColor: AppTheme.primary,
              onChanged: (v) => setState(() => _toggles[i]['value'] = v),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Team Sheet ─────────────────────────────────────────────────
class _TeamSheet extends StatelessWidget {
  const _TeamSheet();

  static const List<Map<String, dynamic>> _members = [
    {
      'name': 'Sofia Espinoza',
      'role': 'Owner',
      'email': 'sme360@app.com',
      'initials': 'SE',
      'status': 'active',
      'lastActive': 'Now',
    },
    {
      'name': 'Marcus Okonkwo',
      'role': 'Manager',
      'email': 'marcus@cafeelite.com',
      'initials': 'MO',
      'status': 'active',
      'lastActive': '2h ago',
    },
    {
      'name': 'Priya Nair',
      'role': 'Analyst',
      'email': 'priya@cafeelite.com',
      'initials': 'PN',
      'status': 'active',
      'lastActive': 'Yesterday',
    },
    {
      'name': 'James Whitfield',
      'role': 'Barista Lead',
      'email': 'james@cafeelite.com',
      'initials': 'JW',
      'status': 'pending',
      'lastActive': 'Invite sent',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_members.length} Members',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurface,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.warningContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '1 Pending',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.warning,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ..._members.map(
          (m) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: m['status'] == 'pending'
                      ? AppTheme.warning.withAlpha(80)
                      : AppTheme.outlineVariant,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: m['status'] == 'pending'
                            ? [
                                AppTheme.warning.withAlpha(60),
                                AppTheme.warning.withAlpha(30),
                              ]
                            : [AppTheme.primary, AppTheme.secondary],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        m['initials'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
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
                        Text(
                          m['name'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.onSurface,
                          ),
                        ),
                        Text(
                          '${m['role']} · ${m['email']}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: AppTheme.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      StatusBadgeWidget(
                        label: m['status'] == 'active' ? 'Active' : 'Pending',
                        status: m['status'] == 'active'
                            ? BadgeStatus.success
                            : BadgeStatus.warning,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        m['lastActive'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: AppTheme.muted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.person_add_rounded, size: 18),
            label: Text(
              'Invite Team Member',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Export Sheet ───────────────────────────────────────────────
class _ExportSheet extends StatelessWidget {
  const _ExportSheet();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Export Format',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        _exportOption(
          context,
          icon: Icons.picture_as_pdf_rounded,
          label: 'PDF Report',
          subtitle: 'Full business analytics report with charts',
          color: AppTheme.error,
          bgColor: AppTheme.errorContainer,
          badge: 'Recommended',
        ),
        const SizedBox(height: 10),
        _exportOption(
          context,
          icon: Icons.table_chart_rounded,
          label: 'CSV Data Export',
          subtitle: 'Raw data for Excel or Google Sheets',
          color: AppTheme.success,
          bgColor: AppTheme.successContainer,
          badge: null,
        ),
        const SizedBox(height: 20),
        Text(
          'Date Range',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              ['Last 7 days', 'Last 30 days', 'Last 90 days', 'Custom range']
                  .map(
                    (r) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: r == 'Last 30 days'
                            ? AppTheme.primaryContainer
                            : AppTheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: r == 'Last 30 days'
                              ? AppTheme.primary
                              : AppTheme.outlineVariant,
                        ),
                      ),
                      child: Text(
                        r,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: r == 'Last 30 days'
                              ? AppTheme.primary
                              : AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.download_rounded, size: 18),
            label: Text(
              'Generate & Download',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _exportOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required Color bgColor,
    String? badge,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.onSurface,
                      ),
                    ),
                    if (badge != null) ...[
                      const SizedBox(width: 8),
                      StatusBadgeWidget(label: badge, status: BadgeStatus.info),
                    ],
                  ],
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppTheme.muted,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: AppTheme.outline,
          ),
        ],
      ),
    );
  }
}

// ── Currency & Language Sheet ──────────────────────────────────
class _CurrencyLanguageSheet extends StatefulWidget {
  @override
  State<_CurrencyLanguageSheet> createState() => _CurrencyLanguageSheetState();
}

class _CurrencyLanguageSheetState extends State<_CurrencyLanguageSheet> {
  // TODO: Replace with Riverpod/Bloc for production
  String _selectedCurrency = 'USD';
  String _selectedLanguage = 'English (US)';
  String _selectedDateFormat = 'MM/DD/YYYY';

  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'CAD', 'AUD', 'JPY'];
  final List<String> _languages = [
    'English (US)',
    'English (UK)',
    'Spanish',
    'French',
    'German',
    'Portuguese',
  ];
  final List<String> _dateFormats = ['MM/DD/YYYY', 'DD/MM/YYYY', 'YYYY-MM-DD'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Currency'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _currencies
              .map(
                (c) => _selectChip(
                  c,
                  _selectedCurrency == c,
                  () => setState(() => _selectedCurrency = c),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 20),
        _sectionLabel('Language'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _languages
              .map(
                (l) => _selectChip(
                  l,
                  _selectedLanguage == l,
                  () => setState(() => _selectedLanguage = l),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 20),
        _sectionLabel('Date Format'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _dateFormats
              .map(
                (d) => _selectChip(
                  d,
                  _selectedDateFormat == d,
                  () => setState(() => _selectedDateFormat = d),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              'Save Preferences',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionLabel(String label) => Text(
    label,
    style: GoogleFonts.plusJakartaSans(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: AppTheme.onSurface,
    ),
  );

  Widget _selectChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primaryContainer : AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppTheme.primary : AppTheme.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? AppTheme.primary : AppTheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

// ── Activity Log Sheet ─────────────────────────────────────────
class _ActivityLogSheet extends StatelessWidget {
  const _ActivityLogSheet();

  static const List<Map<String, dynamic>> _logs = [
    {
      'action': 'Signed in',
      'detail': 'Portland, OR · Chrome on macOS',
      'time': 'Today, 2:51 PM',
      'icon': Icons.login_rounded,
      'type': 'auth',
    },
    {
      'action': 'Exported PDF Report',
      'detail': 'March 2026 Business Report',
      'time': 'Today, 11:22 AM',
      'icon': Icons.download_rounded,
      'type': 'export',
    },
    {
      'action': 'Updated Notification Settings',
      'detail': 'Enabled weekly digest',
      'time': 'Yesterday, 4:15 PM',
      'icon': Icons.notifications_rounded,
      'type': 'settings',
    },
    {
      'action': 'Team Member Invited',
      'detail': 'james@cafeelite.com · Barista Lead',
      'time': 'Mar 29, 2026 · 9:08 AM',
      'icon': Icons.person_add_rounded,
      'type': 'team',
    },
    {
      'action': 'Signed in',
      'detail': 'Portland, OR · Safari on iPhone',
      'time': 'Mar 28, 2026 · 7:43 PM',
      'icon': Icons.login_rounded,
      'type': 'auth',
    },
    {
      'action': 'Exported CSV Data',
      'detail': 'Revenue data — Last 90 days',
      'time': 'Mar 27, 2026 · 2:30 PM',
      'icon': Icons.table_chart_rounded,
      'type': 'export',
    },
    {
      'action': 'Business Details Updated',
      'detail': 'Phone number changed',
      'time': 'Mar 25, 2026 · 10:15 AM',
      'icon': Icons.store_rounded,
      'type': 'settings',
    },
    {
      'action': 'Password Changed',
      'detail': 'Security update',
      'time': 'Mar 1, 2026 · 3:00 PM',
      'icon': Icons.lock_rounded,
      'type': 'security',
    },
  ];

  Color _typeColor(String type) {
    switch (type) {
      case 'auth':
        return AppTheme.primary;
      case 'export':
        return AppTheme.success;
      case 'settings':
        return AppTheme.secondary;
      case 'team':
        return AppTheme.info;
      case 'security':
        return AppTheme.warning;
      default:
        return AppTheme.muted;
    }
  }

  Color _typeBg(String type) {
    switch (type) {
      case 'auth':
        return AppTheme.primaryContainer;
      case 'export':
        return AppTheme.successContainer;
      case 'settings':
        return AppTheme.secondaryContainer;
      case 'team':
        return AppTheme.infoContainer;
      case 'security':
        return AppTheme.warningContainer;
      default:
        return AppTheme.surfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _logs
          .map(
            (log) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: _typeBg(log['type'] as String),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(
                      log['icon'] as IconData,
                      size: 18,
                      color: _typeColor(log['type'] as String),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          log['action'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          log['detail'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: AppTheme.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    log['time'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppTheme.muted,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

// ── Security Sheet ─────────────────────────────────────────────
class _SecuritySheet extends StatefulWidget {
  @override
  State<_SecuritySheet> createState() => _SecuritySheetState();
}

class _SecuritySheetState extends State<_SecuritySheet> {
  // TODO: Replace with Riverpod/Bloc for production
  bool _twoFactorEnabled = true;
  bool _biometricEnabled = false;
  final _currentPwCtrl = TextEditingController();
  final _newPwCtrl = TextEditingController();
  final _confirmPwCtrl = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentPwCtrl.dispose();
    _newPwCtrl.dispose();
    _confirmPwCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Security status
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.successContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.shield_rounded,
                size: 20,
                color: AppTheme.success,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account is Secure',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.success,
                      ),
                    ),
                    Text(
                      '2FA enabled · Last password change: 30 days ago',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppTheme.success,
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
          'Security Settings',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 4,
                ),
                secondary: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.verified_user_rounded,
                    size: 18,
                    color: AppTheme.primary,
                  ),
                ),
                title: Text(
                  'Two-Factor Authentication',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
                subtitle: Text(
                  'SMS code on login',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppTheme.muted,
                  ),
                ),
                value: _twoFactorEnabled,
                activeThumbColor: AppTheme.primary,
                onChanged: (v) => setState(() => _twoFactorEnabled = v),
              ),
              Divider(height: 1, color: AppTheme.outlineVariant, indent: 64),
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 4,
                ),
                secondary: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.fingerprint_rounded,
                    size: 18,
                    color: AppTheme.primary,
                  ),
                ),
                title: Text(
                  'Biometric Login',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
                subtitle: Text(
                  'Fingerprint or Face ID',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppTheme.muted,
                  ),
                ),
                value: _biometricEnabled,
                activeThumbColor: AppTheme.primary,
                onChanged: (v) => setState(() => _biometricEnabled = v),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Change Password',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        _pwField(
          _currentPwCtrl,
          'Current password',
          _obscureCurrent,
          () => setState(() => _obscureCurrent = !_obscureCurrent),
        ),
        const SizedBox(height: 12),
        _pwField(
          _newPwCtrl,
          'New password',
          _obscureNew,
          () => setState(() => _obscureNew = !_obscureNew),
        ),
        const SizedBox(height: 12),
        _pwField(
          _confirmPwCtrl,
          'Confirm new password',
          _obscureConfirm,
          () => setState(() => _obscureConfirm = !_obscureConfirm),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              'Update Password',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Danger zone
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.errorContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.error.withAlpha(60)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.warning_rounded,
                    size: 16,
                    color: AppTheme.error,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Danger Zone',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.error,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Deleting your account will permanently remove all Café Élite data from SME360. This action cannot be undone.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppTheme.error,
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.error,
                  side: const BorderSide(color: AppTheme.error),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                child: Text(
                  'Delete Account',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _pwField(
    TextEditingController ctrl,
    String hint,
    bool obscure,
    VoidCallback toggle,
  ) {
    return TextFormField(
      controller: ctrl,
      obscureText: obscure,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        color: AppTheme.onSurface,
      ),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(
          Icons.lock_outline_rounded,
          size: 20,
          color: AppTheme.muted,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            size: 20,
            color: AppTheme.muted,
          ),
          onPressed: toggle,
        ),
        filled: true,
        fillColor: AppTheme.surfaceVariant,
      ),
    );
  }
}
