import 'package:flutter/material.dart';

import '../../widgets/cards/container_card.dart';

class ActiveParkingsPage extends StatelessWidget {
  const ActiveParkingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    void addParking() {
      print('Ny parkering');
    }

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: const <Widget>[
          ContainerCard(
            icon: Icons.car_crash,
            title: 'active parking 1',
            text: 'This is an active parking',
          ),
          ContainerCard(
            icon: Icons.car_crash,
            title: 'active parking 2',
            text: 'This is an active parking',
          ),
          ContainerCard(
            icon: Icons.car_crash,
            title: 'active parking 3',
            text: 'This is an active parking',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addParking,
        label: const Text('Starta ny parkering'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.amber,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
