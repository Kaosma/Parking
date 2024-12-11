import 'package:flutter/material.dart';
import 'package:parking_shared/parking_shared.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Parking>>(
        future: getAllParkingsHandler(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Ingen parkeringsdata hittad.'));
          }

          final int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
          final parkings = snapshot.data!;
          final activeParkings = parkings.where((parking) {
            return parking.startTime <= currentTime &&
                parking.endTime >= currentTime;
          }).length;

          var totalIncome = 0;
          parkings.where((parking) {
            return parking.startTime > currentTime ||
                parking.endTime < currentTime;
          }).forEach((parking) =>
              totalIncome = totalIncome + parking.calculateParkingPrice());

          final Map<String, int> usageCount = {};
          for (var parking in parkings) {
            final parkingSpaceId = parking.parkingSpace.id;
            usageCount[parkingSpaceId] = (usageCount[parkingSpaceId] ?? 0) + 1;
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

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 5,
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: ListTile(
                    leading: const Icon(Icons.car_repair, color: Colors.green),
                    title: const Text('Aktiva Parkeringar'),
                    subtitle: Text('$activeParkings parkeringar'),
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
                    leading: const Icon(Icons.location_on, color: Colors.green),
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
        },
      ),
    );
  }
}
