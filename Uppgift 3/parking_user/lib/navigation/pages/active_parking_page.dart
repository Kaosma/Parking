import 'package:flutter/material.dart';
import 'package:parking_shared/parking_shared.dart';
import 'package:parking_user/utils/constants.dart';

import '../../widgets/cards/container_card.dart';

class ActiveParkingsPage extends StatelessWidget {
  const ActiveParkingsPage({super.key});

  Future<List<Parking>> getAllParkingsHandler(
      ParkingRepository repository) async {
    return await repository.getAll();
  }

  @override
  Widget build(BuildContext context) {
    var parkingRepository = ParkingRepository();
    void addParking() {
      print('Ny parkering');
    }

    return Scaffold(
      body: FutureBuilder<List<Parking>>(
        future: getAllParkingsHandler(parkingRepository),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error new: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No active parkings available.'));
          }

          final parkingsList = snapshot.data!
              .where((parking) => parking.vehicle.owner.id == AppStrings.userId)
              .map((parking) {
            return ContainerCard(
              icon: Icons.car_crash,
              title: 'Parking: ${parking.id}',
              text: 'Parking space: ${parking.parkingSpace.id}',
            );
          }).toList();

          return ListView(
            padding: const EdgeInsets.all(8.0),
            children: parkingsList,
          );
        },
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
