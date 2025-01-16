import 'package:flutter/material.dart';
import 'package:parking_shared/parking_shared.dart';

class ActiveParkingsPage extends StatefulWidget {
  final String userId;
  const ActiveParkingsPage({super.key, required this.userId});

  @override
  State<ActiveParkingsPage> createState() => _ActiveParkingsPageState();
}

class _ActiveParkingsPageState extends State<ActiveParkingsPage> {
  final formKey = GlobalKey<FormState>();

  Future<void> addParkingDialog(int timeNow) async {
    Vehicle? selectedVehicle;
    ParkingSpace? selectedParkingSpace;
    String startTimeString = '';
    String endTimeString = '';

    final List<Vehicle> vehicles = await getAllVehiclesHandler();
    final List<ParkingSpace> parkingSpaces = await getAllParkingSpacesHandler();
    final List<Parking> parkings = await getAllParkingsHandler();

    final activeParkings = parkings.where((parking) {
      return parking.startTime <= timeNow && parking.endTime >= timeNow;
    }).toList();

    final Set<String> activeParkingSpaceIds =
        activeParkings.map((parking) => parking.parkingSpace.id).toSet();

    final List<ParkingSpace> inactiveParkingSpaces =
        parkingSpaces.where((space) {
      return !activeParkingSpaceIds.contains(space.id);
    }).toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Starta ny parkering'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<Vehicle>(
                  value: selectedVehicle,
                  items: vehicles
                      .where((vehicle) => vehicle.owner.id == AppStrings.userId)
                      .map((vehicle) {
                    return DropdownMenuItem(
                      value: vehicle,
                      child: Text(
                          '${vehicle.type}, ${vehicle.registrationNumber}'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedVehicle = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Fordon',
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Välj ett fordon';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<ParkingSpace>(
                  value: selectedParkingSpace,
                  items: inactiveParkingSpaces.map((space) {
                    return DropdownMenuItem(
                      value: space,
                      child: Text(space.address),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedParkingSpace = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Parkeringsplats',
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Välj en parkeringsplats';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Starttid (Unix)',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    startTimeString = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ange en starttid';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Starttid måste vara ett heltal';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Sluttid (Unix)',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    endTimeString = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ange en sluttid';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Sluttid måste vara ett heltal';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Avbryt'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final int? startTime = int.tryParse(startTimeString);
                  final int? endTime = int.tryParse(endTimeString);

                  if (startTime != null && endTime != null) {
                    if (selectedVehicle != null &&
                        selectedParkingSpace != null) {
                      parkingRepository.add(Parking(
                        vehicle: selectedVehicle!,
                        parkingSpace: selectedParkingSpace!,
                        startTime: startTime,
                        endTime: endTime,
                      ));
                      Navigator.of(context).pop();
                    }
                  }
                }
              },
              child: const Text('Starta'),
            ),
          ],
        );
      },
    );
  }

  Future<void> editParkingDialog(Parking parking, int timeNow) async {
    Vehicle? selectedVehicle = parking.vehicle;
    ParkingSpace? selectedParkingSpace = parking.parkingSpace;
    String startTimeString = parking.startTime.toString();
    String endTimeString = parking.endTime.toString();

    final List<Vehicle> vehicles = await getAllVehiclesHandler();
    final List<Parking> parkings = await getAllParkingsHandler();
    final List<ParkingSpace> parkingSpaces = await getAllParkingSpacesHandler();

    final activeParkings = parkings.where((parking) {
      return parking.startTime <= timeNow && parking.endTime >= timeNow;
    }).toList();

    final Set<String> activeParkingSpaceIds =
        activeParkings.map((parking) => parking.parkingSpace.id).toSet();

    final List<ParkingSpace> inactiveParkingSpaces =
        parkingSpaces.where((space) {
      return !activeParkingSpaceIds.contains(space.id) ||
          space.id == parking.parkingSpace.id;
    }).toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Redigera parkering'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedVehicle?.id,
                  items: vehicles
                      .where((vehicle) => vehicle.owner.id == AppStrings.userId)
                      .map((vehicle) {
                    return DropdownMenuItem<String>(
                      value: vehicle.id,
                      child: Text(
                          '${vehicle.type}, ${vehicle.registrationNumber}'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedVehicle =
                          vehicles.firstWhere((vehicle) => vehicle.id == value);
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Fordon',
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Välj ett fordon';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedParkingSpace?.id,
                  items: inactiveParkingSpaces.map((space) {
                    return DropdownMenuItem<String>(
                      value: space.id,
                      child: Text(space.address),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedParkingSpace = parkingSpaces
                          .firstWhere((space) => space.id == value);
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Parkeringsplats',
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Välj en parkeringsplats';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: startTimeString,
                  decoration: const InputDecoration(
                    labelText: 'Starttid (Unix)',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    startTimeString = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ange en starttid';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Starttid måste vara ett heltal';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: endTimeString,
                  decoration: const InputDecoration(
                    labelText: 'Sluttid (Unix)',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    endTimeString = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ange en sluttid';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Sluttid måste vara ett heltal';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Avbryt'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final int? startTime = int.tryParse(startTimeString);
                  final int? endTime = int.tryParse(endTimeString);

                  if (startTime != null &&
                      endTime != null &&
                      selectedVehicle != null &&
                      selectedParkingSpace != null) {
                    setState(() {
                      parkingRepository.update(Parking(
                        vehicle: selectedVehicle!,
                        parkingSpace: selectedParkingSpace!,
                        startTime: startTime,
                        endTime: endTime,
                        id: parking.id,
                      ));
                    });
                    Navigator.of(context).pop();
                  }
                }
              },
              child: const Text('Spara'),
            ),
          ],
        );
      },
    );
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
                setState(() {
                  parkingRepository.delete(parking);
                });
                Navigator.of(context).pop();
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
    int getCurrentTime() {
      return DateTime.now().millisecondsSinceEpoch ~/ 1000;
    }

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

          final parkings = snapshot.data!.where(
              (parking) => parking.vehicle.owner.id == AppStrings.userId);

          final activeParkings = parkings.where((parking) {
            return parking.startTime <= getCurrentTime() &&
                parking.endTime >= getCurrentTime();
          }).toList();

          final inactiveParkings = parkings.where((parking) {
            return parking.startTime > getCurrentTime() ||
                parking.endTime < getCurrentTime();
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
                    onEdit: () {
                      editParkingDialog(parking, getCurrentTime());
                    },
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
                    onEdit: () {
                      editParkingDialog(parking, getCurrentTime());
                    },
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => addParkingDialog(getCurrentTime()),
        label: const Text('Starta ny parkering'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.amber,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
