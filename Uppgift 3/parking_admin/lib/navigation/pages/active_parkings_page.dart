import 'package:flutter/material.dart';

import '../../widgets/cards/list_card.dart';

class ActiveParkingsPage extends StatelessWidget {
  const ActiveParkingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          ListCard(
            icon: Icons.car_crash,
            title: 'active parking 1',
            text: 'This is a active parking',
          ),
          ListCard(
            icon: Icons.car_crash,
            title: 'active parking 2',
            text: 'This is a active parking',
          ),
        ],
      ),
    );
  }
}
