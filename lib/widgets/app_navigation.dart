import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  const AppNavigation({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      backgroundColor: AppTheme.surface,
      indicatorColor: AppTheme.primaryContainer,
      elevation: 4,
      shadowColor: Colors.black12,
      height: 68,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard_rounded),
          label: 'Dashboard',
        ),
        NavigationDestination(
          icon: Icon(Icons.inventory_2_outlined),
          selectedIcon: Icon(Icons.inventory_2_rounded),
          label: 'Inventory',
        ),
        NavigationDestination(
          icon: Icon(Icons.analytics_outlined),
          selectedIcon: Icon(Icons.analytics_rounded),
          label: 'Business Intel',
        ),
        NavigationDestination(
          icon: Icon(Icons.campaign_outlined),
          selectedIcon: Icon(Icons.campaign_rounded),
          label: 'Marketing',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline_rounded),
          selectedIcon: Icon(Icons.person_rounded),
          label: 'Account',
        ),
      ],
    );
  }
}

class AppNavigationRail extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  const AppNavigationRail({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      backgroundColor: AppTheme.surface,
      indicatorColor: AppTheme.primaryContainer,
      useIndicator: true,
      extended: MediaQuery.of(context).size.width >= 840,
      labelType: MediaQuery.of(context).size.width >= 840
          ? NavigationRailLabelType.none
          : NavigationRailLabelType.all,
      selectedLabelTextStyle: const TextStyle(
        color: AppTheme.primary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelTextStyle: const TextStyle(
        color: AppTheme.muted,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard_rounded),
          label: Text('Dashboard'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.inventory_2_outlined),
          selectedIcon: Icon(Icons.inventory_2_rounded),
          label: Text('Inventory'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.analytics_outlined),
          selectedIcon: Icon(Icons.analytics_rounded),
          label: Text('Business Intel'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.campaign_outlined),
          selectedIcon: Icon(Icons.campaign_rounded),
          label: Text('Marketing'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.person_outline_rounded),
          selectedIcon: Icon(Icons.person_rounded),
          label: Text('Account'),
        ),
      ],
    );
  }
}
