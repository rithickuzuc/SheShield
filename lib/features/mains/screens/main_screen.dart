import 'package:flutter/material.dart';

import '../../activity/screens/activity_screen.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import '../../profile/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int currentIndex = 0;

  final List<Widget> screens = [

    const DashboardScreen(),

    const ActivityScreen(),

    const ProfileScreen(),

  ];

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: screens[currentIndex],

    bottomNavigationBar: NavigationBar(
      selectedIndex: currentIndex,

      onDestinationSelected: (index) {
        setState(() {
          currentIndex = index;
        });
      },

      destinations: const [

        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: "Home",
        ),

        NavigationDestination(
          icon: Icon(Icons.history_outlined),
          selectedIcon: Icon(Icons.history),
          label: "Activity",
        ),

        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: "Profile",
        ),
      ],
    ),
  );
}
}