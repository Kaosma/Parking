import 'package:flutter/material.dart';
import 'package:parking_shared/parking_shared.dart';

import '../../handlers/login/login_handler.dart';
import '../../widgets/buttons/primary_button.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    signOut() => signOutUser(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          const ListCard(
            icon: Icons.car_crash,
            title: 'different feature 1',
            text: 'This is a different feature',
          ),
          const ListCard(
            icon: Icons.car_crash,
            title: 'different feature 1',
            text: 'This is a different feature',
          ),
          PrimaryButton(
            text: 'Logga ut',
            onButtonPressed: signOut,
          )
        ],
      ),
    );
  }
}
