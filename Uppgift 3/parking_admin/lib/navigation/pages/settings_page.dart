import 'package:flutter/material.dart';

import '../../widgets/cards/list_card.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          ListCard(
            icon: Icons.car_crash,
            title: 'settings feature 1',
            text: 'This is a settings feature',
          ),
          ListCard(
            icon: Icons.car_crash,
            title: 'settings feature 2',
            text: 'This is a settings feature',
          ),
        ],
      ),
    );
  }
}