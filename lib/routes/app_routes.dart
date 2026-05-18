import 'package:flutter/material.dart';

import '../presentation/account_screen/account_screen.dart';
import '../presentation/business_intelligence_screen/business_intelligence_screen.dart';
import '../presentation/dashboard_screen/dashboard_screen.dart';
import '../presentation/inventory_screen/inventory_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/marketing_screen/marketing_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String loginScreen = '/login-screen';
  static const String dashboardScreen = '/dashboard-screen';
  static const String inventoryScreen = '/inventory-screen';
  static const String businessIntelligenceScreen =
      '/business-intelligence-screen';
  static const String marketingScreen = '/marketing-screen';
  static const String accountScreen = '/account-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LoginScreen(),
    loginScreen: (context) => const LoginScreen(),
    dashboardScreen: (context) => const DashboardScreen(),
    inventoryScreen: (context) => const InventoryScreen(),
    businessIntelligenceScreen: (context) => const BusinessIntelligenceScreen(),
    marketingScreen: (context) => const MarketingScreen(),
    accountScreen: (context) => const AccountScreen(),
  };
}
