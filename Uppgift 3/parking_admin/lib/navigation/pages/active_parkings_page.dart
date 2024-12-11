import 'package:flutter/material.dart';
import 'package:parking_shared/parking_shared.dart';

class ActiveParkingsPage extends StatelessWidget {
  const ActiveParkingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    return Scaffold(
      body: FutureBuilder<List<Parking>>(
        future: getAllParkingsHandler(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Inga parkeringar hittade.'));
          }

          final activeParkings = snapshot.data!.where((parking) {
            return parking.startTime <= currentTime &&
                parking.endTime >= currentTime;
          }).toList();

          final inactiveParkings = snapshot.data!.where((parking) {
            return parking.startTime > currentTime ||
                parking.endTime < currentTime;
          }).toList();

          return ListView(
            padding: const EdgeInsets.all(8.0),
            children: [
              if (activeParkings.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Aktiva Parkeringar',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...activeParkings.map((parking) {
                  return ListCard(
                    icon: Icons.car_crash,
                    title:
                        '${parking.vehicle.registrationNumber}, ${parking.parkingSpace.address}',
                    text:
                        '${convertUnixToDateTime(parking.startTime)} - ${convertUnixToDateTime(parking.endTime)}',
                  );
                }).toList(),
              ],
              if (activeParkings.isNotEmpty && inactiveParkings.isNotEmpty)
                const Divider(),
              if (inactiveParkings.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Tidigare Parkeringar',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...inactiveParkings.map((parking) {
                  return ListCard(
                    icon: Icons.car_repair,
                    title:
                        '${parking.vehicle.registrationNumber}, ${parking.parkingSpace.address}',
                    text:
                        '${convertUnixToDateTime(parking.startTime)} - ${convertUnixToDateTime(parking.endTime)}',
                  );
                }).toList(),
              ],
            ],
          );
        },
      ),
    );
  }
}
