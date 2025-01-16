import 'package:flutter/material.dart';
import 'package:parking_shared/parking_shared.dart';

class ParkingsPage extends StatefulWidget {
  const ParkingsPage({super.key});

  @override
  _ParkingsPageState createState() => _ParkingsPageState();
}

class _ParkingsPageState extends State<ParkingsPage> {
  late Future<List<Parking>> _parkingsFuture;

  @override
  void initState() {
    super.initState();
    _reloadParkings();
  }

  void _reloadParkings() {
    setState(() {
      _parkingsFuture = getAllParkingsHandler();
    });
  }

  void deleteParkingDialog(Parking parking) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ta bort parkering'),
          content: Text(
              'Är du säker på att du vill ta bort parkeringen ${parking.id}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Avbryt'),
            ),
            ElevatedButton(
              onPressed: () {
                parkingRepository.delete(parking);
                Navigator.of(context).pop();
                _reloadParkings();
              },
              child: const Text('Radera'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    return Scaffold(
      body: FutureBuilder<List<Parking>>(
        future: _parkingsFuture,
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
                    onDelete: () {
                      deleteParkingDialog(parking);
                    },
                    isActive: true,
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
                    onDelete: () {
                      deleteParkingDialog(parking);
                    },
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
