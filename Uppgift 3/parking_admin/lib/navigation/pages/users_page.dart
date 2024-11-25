import 'package:flutter/material.dart';

import '../../widgets/cards/list_card.dart';
import '../../widgets/rows/handle_users_row.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HandleUsersRow(),
          Expanded(
            child: ListView(
              children: const <Widget>[
                ListCard(
                  icon: Icons.person,
                  title: 'user 1',
                  text: 'This is a user',
                ),
                ListCard(
                  icon: Icons.person,
                  title: 'user 2',
                  text: 'This is a user',
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
