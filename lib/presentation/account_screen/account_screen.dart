import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import './widgets/account_bottom_sheets.dart';
import './widgets/account_profile_header_widget.dart';
import './widgets/account_section_group_widget.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // TODO: Replace with Riverpod/Bloc for production

  final List<Map<String, dynamic>> _identityItems = [
    {
      'icon': Icons.person_rounded,
      'label': 'User Profile',
      'subtitle': 'Name, email, phone',
      'color': AppTheme.primary,
      'bgColor': AppTheme.primaryContainer,
      'sheetType': 'user_profile',
    },
    {
      'icon': Icons.store_rounded,
      'label': 'Business Details',
      'subtitle': 'Café Élite · Café · Est. 2019',
      'color': AppTheme.secondary,
      'bgColor': AppTheme.secondaryContainer,
      'sheetType': 'business_details',
    },
  ];

  final List<Map<String, dynamic>> _managementItems = [
    {
      'icon': Icons.credit_card_rounded,
      'label': 'Subscription Management',
      'subtitle': 'SME360 Pro · Renews Apr 30, 2026',
      'color': AppTheme.success,
      'bgColor': AppTheme.successContainer,
      'sheetType': 'subscription',
      'badge': 'PRO',
      'badgeStatus': 'success',
    },
    {
      'icon': Icons.notifications_rounded,
      'label': 'Notification Preferences',
      'subtitle': 'Revenue alerts, weekly digest',
      'color': AppTheme.warning,
      'bgColor': AppTheme.warningContainer,
      'sheetType': 'notifications',
    },
    {
      'icon': Icons.group_rounded,
      'label': 'Team Management',
      'subtitle': '3 members · 1 pending invite',
      'color': AppTheme.info,
      'bgColor': AppTheme.infoContainer,
      'sheetType': 'team',
    },
    {
      'icon': Icons.download_rounded,
      'label': 'Data Export',
      'subtitle': 'PDF reports · CSV data',
      'color': AppTheme.primary,
      'bgColor': AppTheme.primaryContainer,
      'sheetType': 'export',
    },
  ];

  final List<Map<String, dynamic>> _preferencesItems = [
    {
      'icon': Icons.language_rounded,
      'label': 'Currency & Language',
      'subtitle': 'USD · English (US)',
      'color': AppTheme.secondary,
      'bgColor': AppTheme.secondaryContainer,
      'sheetType': 'currency_language',
    },
    {
      'icon': Icons.history_rounded,
      'label': 'Activity Log',
      'subtitle': 'Last login: Today, 2:51 PM',
      'color': AppTheme.muted,
      'bgColor': AppTheme.surfaceVariant,
      'sheetType': 'activity_log',
    },
    {
      'icon': Icons.security_rounded,
      'label': 'Security & Password',
      'subtitle': '2FA enabled · Last changed 30 days ago',
      'color': AppTheme.error,
      'bgColor': AppTheme.errorContainer,
      'sheetType': 'security',
    },
  ];

  void _openSheet(BuildContext context, String sheetType) {
    AccountBottomSheets.show(context, sheetType);
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

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
            'Account',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.onSurface,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.logout_rounded,
                size: 22,
                color: AppTheme.error,
              ),
              tooltip: 'Sign Out',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text(
                      'Sign Out',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    content: Text(
                      'Are you sure you want to sign out of SME360?',
                      style: GoogleFonts.plusJakartaSans(fontSize: 14),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppTheme.muted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.loginScreen,
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.error,
                          foregroundColor: Colors.white,
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
                          'Sign Out',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(width: 4),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: isTablet
                ? _buildTabletLayout(context)
                : _buildPhoneLayout(context),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneLayout(BuildContext context) {
    return Column(
      children: [
        const AccountProfileHeaderWidget(),
        const SizedBox(height: 20),
        AccountSectionGroupWidget(
          title: 'Identity',
          items: _identityItems,
          onItemTap: (sheetType) => _openSheet(context, sheetType),
        ),
        const SizedBox(height: 16),
        AccountSectionGroupWidget(
          title: 'Management',
          items: _managementItems,
          onItemTap: (sheetType) => _openSheet(context, sheetType),
        ),
        const SizedBox(height: 16),
        AccountSectionGroupWidget(
          title: 'Preferences',
          items: _preferencesItems,
          onItemTap: (sheetType) => _openSheet(context, sheetType),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Column(
      children: [
        const AccountProfileHeaderWidget(),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  AccountSectionGroupWidget(
                    title: 'Identity',
                    items: _identityItems,
                    onItemTap: (sheetType) => _openSheet(context, sheetType),
                  ),
                  const SizedBox(height: 16),
                  AccountSectionGroupWidget(
                    title: 'Preferences',
                    items: _preferencesItems,
                    onItemTap: (sheetType) => _openSheet(context, sheetType),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AccountSectionGroupWidget(
                title: 'Management',
                items: _managementItems,
                onItemTap: (sheetType) => _openSheet(context, sheetType),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
