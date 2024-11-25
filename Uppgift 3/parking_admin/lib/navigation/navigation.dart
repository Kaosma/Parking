import 'package:flutter/material.dart';
import 'package:parking_admin/navigation/pages/users_page.dart';

import 'pages/active_parkings_page.dart';
import 'pages/parking_spaces_page.dart';
import 'pages/settings_page.dart';

class AdminNavigation extends StatefulWidget {
  const AdminNavigation({super.key});

  @override
  State<AdminNavigation> createState() => _AdminNavigationState();
}

class _AdminNavigationState extends State<AdminNavigation> {
  int currentPageIndex = 0;

  final List<Widget> pages = const [
    ParkingSpacesPage(),
    ActiveParkingsPage(),
    UsersPage(),
    SettingsPage(),
  ];
  NavigationRailLabelType labelType = NavigationRailLabelType.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: currentPageIndex,
            indicatorColor: Colors.amber,
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            labelType: labelType,
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.local_parking),
                label: Text('Parkeringsplatser'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.directions_car),
                label: Text('Aktiva Parkeringar'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people),
                label: Text('Användare'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text('Inställningar'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          Expanded(child: Scaffold(body: pages[currentPageIndex])),
        ],
      ),
    );
  }
}
