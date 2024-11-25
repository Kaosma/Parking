import 'package:flutter/material.dart';

import '../../handlers/login/signout_user.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/cards/container_card.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    signOut() => signOutUser(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          const ContainerCard(
            icon: Icons.car_crash,
            title: 'different feature 1',
            text: 'This is a different feature',
          ),
          const ContainerCard(
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