import 'package:flutter/material.dart';
import 'package:parking_user/navigation/pages/active_parking_page.dart';

import 'pages/more_page.dart';
import 'pages/vehicles_page.dart';

class UserNavigation extends StatefulWidget {
  const UserNavigation({super.key});

  @override
  State<UserNavigation> createState() => _UserNavigationState();
}

class _UserNavigationState extends State<UserNavigation> {
  int currentPageIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      const ActiveParkingsPage(),
      const VehiclesPage(),
      const MorePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.local_parking),
            label: 'Aktiva Parkeringar',
          ),
          NavigationDestination(
            icon: Icon(Icons.directions_car),
            label: 'Fordon',
          ),
          NavigationDestination(
            icon: Icon(Icons.more_horiz),
            label: 'Mer',
          )
        ],
      ),
      body: pages[currentPageIndex],
    );
  }
}
