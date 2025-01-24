import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_shared/parking_shared.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
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
    return Scaffold(
      body: BlocBuilder<ParkingsBloc, ParkingsState>(
        builder: (context, state) {
          if (state is ParkingsError) {
            return Center(
              child: Text('Error fetching parkings: ${state.message}'),
            );
          } else if (state is ParkingsLoaded) {
            final int currentTime =
                DateTime.now().millisecondsSinceEpoch ~/ 1000;
            final parkings = state.parkings;
            final activeParkings = parkings.where((parking) {
              return parking.startTime <= currentTime &&
                  parking.endTime >= currentTime;
            });

            final inactiveParkings = parkings.where((parking) {
              return parking.startTime > currentTime ||
                  parking.endTime < currentTime;
            });

            var totalIncome = 0;
            for (var parking in inactiveParkings) {
              totalIncome = totalIncome + parking.calculateParkingPrice();
            }

            final Map<String, int> usageCount = {};
            for (var parking in parkings) {
              final parkingSpaceId = parking.parkingSpace.id;
              usageCount[parkingSpaceId] =
                  (usageCount[parkingSpaceId] ?? 0) + 1;
            }
            final sortedSpaces = usageCount.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));
            final topThreeIds =
                sortedSpaces.take(3).map((entry) => entry.key).toList();
            final topThreeSpaces = parkings
                .map((parking) => parking.parkingSpace)
                .where((space) => topThreeIds.contains(space.id))
                .toSet()
                .toList();
            if (parkings.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 5,
                      margin: const EdgeInsets.only(bottom: 16.0),
                      child: ListTile(
                        leading:
                            const Icon(Icons.car_repair, color: Colors.green),
                        title: const Text('Parkeringar'),
                        subtitle: Text(
                            '${activeParkings.length} aktiva parkeringar | ${inactiveParkings.length} tidigare parkeringar'),
                      ),
                    ),
                    Card(
                      elevation: 5,
                      margin: const EdgeInsets.only(bottom: 16.0),
                      child: ListTile(
                        leading:
                            const Icon(Icons.attach_money, color: Colors.green),
                        title: const Text('Sammanlagd inkomst'),
                        subtitle: Text('SEK $totalIncome'),
                      ),
                    ),
                    Card(
                      elevation: 5,
                      margin: const EdgeInsets.only(bottom: 16.0),
                      child: ListTile(
                        leading:
                            const Icon(Icons.location_on, color: Colors.green),
                        title: const Text('Mest använda parkeringsplatser'),
                        subtitle: Text(
                          topThreeSpaces.isEmpty
                              ? 'Ingen data'
                              : topThreeSpaces.join(', '),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: Text('Inga parkeringar hittade.'),
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
