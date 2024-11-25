import 'package:flutter/material.dart';

import '../../widgets/buttons/primary_button.dart';
import '../../widgets/cards/container_card.dart';

class VehiclesPage extends StatelessWidget {
  const VehiclesPage({super.key});

  @override
  Widget build(BuildContext context) {
    addVehicle() => print('add vehicle');
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: const <Widget>[
          ContainerCard(
            icon: Icons.car_crash,
            title: 'vehicle 1',
            text: 'This is a vehicle',
          ),
          ContainerCard(
            icon: Icons.car_crash,
            title: 'vehicle 1',
            text: 'This is a vehicle',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addVehicle,
        label: const Text('Lägg till fordon'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.amber,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
