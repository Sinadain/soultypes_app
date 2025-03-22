import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/main/dashboard_screen.dart';
import '../../presentation/screens/auth/sign_in_screen.dart';
import '../../presentation/screens/auth/sign_up_screen.dart';
import '../../presentation/screens/auth/welcome_screen.dart';
import '../../presentation/screens/discover/discover_soultype_screen.dart';
import '../../presentation/screens/discover/soul_languages_test_screen.dart';
import '../../presentation/screens/discover/big_five_test_screen.dart';
import '../../presentation/screens/discover/birth_details_screen.dart';
import '../../presentation/screens/discover/values_screen.dart';
import '../../presentation/screens/discover/goals_screen.dart';

class AppNavigation {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const WelcomeScreen()),
      GoRoute(
        path: '/signin',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/discover',
        builder: (context, state) => const DiscoverSoultypeScreen(),
      ),
      GoRoute(
        path: '/soul-languages-test',
        builder: (context, state) => const SoulLanguagesTestScreen(),
      ),
      GoRoute(
        path: '/big-five-test',
        builder: (context, state) => const BigFiveTestScreen(),
      ),
      GoRoute(
        path: '/birth-details',
        builder: (context, state) => const BirthDetailsScreen(),
      ),
      GoRoute(
        path: '/values',
        builder: (context, state) => const ValuesScreen(),
      ),
      GoRoute(path: '/goals', builder: (context, state) => const GoalsScreen()),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
  );

  static const List<NavigationItem> bottomNavItems = [
    NavigationItem(
      icon: Icons.dashboard,
      label: 'Dashboard',
      path: '/dashboard',
    ),
    NavigationItem(icon: Icons.search, label: 'Search', path: '/search'),
    NavigationItem(
      icon: Icons.people,
      label: 'Connections',
      path: '/connections',
    ),
    NavigationItem(icon: Icons.person, label: 'Profile', path: '/profile'),
  ];

  static Widget bottomNavigationBar(BuildContext context, int currentIndex) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      items:
          bottomNavItems
              .map(
                (item) => BottomNavigationBarItem(
                  icon: Icon(item.icon),
                  label: item.label,
                ),
              )
              .toList(),
      onTap: (index) {
        context.go(bottomNavItems[index].path);
      },
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String label;
  final String path;

  const NavigationItem({
    required this.icon,
    required this.label,
    required this.path,
  });
}
