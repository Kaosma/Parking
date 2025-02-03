import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_shared/parking_shared.dart';

class ParkingsPage extends StatefulWidget {
  const ParkingsPage({super.key});

  @override
  _ParkingsPageState createState() => _ParkingsPageState();
}

class _ParkingsPageState extends State<ParkingsPage> {
  @override
  void initState() {
    super.initState();
    _loadParkings();
  }

  void _loadParkings() {
    context.read<ParkingsBloc>().add(LoadParkings());
  }

  @override
  Widget build(BuildContext context) {
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
                  context
                      .read<ParkingsBloc>()
                      .add(DeleteParking(parking: parking));
                  Navigator.of(context).pop();
                },
                child: const Text('Radera'),
              ),
            ],
          );
        },
      );
    }

    final int currentTime = getCurrentTime();

    return Scaffold(
      body: BlocBuilder<ParkingsBloc, ParkingsState>(
        builder: (context, state) {
          if (state is ParkingsError) {
            return Center(
              child: Text('Error fetching parkings: ${state.message}'),
            );
          } else if (state is ParkingsLoaded) {
            final parkings = state.parkings;

            final activeParkings = parkings.where((parking) {
              return parking.startTime <= currentTime &&
                  parking.endTime >= currentTime;
            }).toList();

            final inactiveParkings = parkings.where((parking) {
              return parking.startTime > currentTime ||
                  parking.endTime < currentTime;
            }).toList();

            return ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                if (activeParkings.isNotEmpty) ...[
                  ...activeParkings.map((parking) {
                    return ListCard(
                      icon: Icons.car_repair,
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
                ] else ...[
                  const Center(
                    child: Text('Inga parkeringar hittade.'),
                  )
                ]
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
