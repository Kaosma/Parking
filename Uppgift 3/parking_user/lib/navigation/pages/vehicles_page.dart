import 'package:flutter/material.dart';
import 'package:parking_shared/parking_shared.dart';

class VehiclesPage extends StatefulWidget {
  final String userId;

  const VehiclesPage({super.key, required this.userId});

  @override
  _VehiclesPageState createState() => _VehiclesPageState();
}

class _VehiclesPageState extends State<VehiclesPage> {
  late Future<List<Vehicle>> _vehiclesFuture;

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  void _loadVehicles() {
    setState(() {
      _vehiclesFuture = getAllVehiclesHandler();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Person?>(
      future: getOwnerHandler(widget.userId),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (userSnapshot.hasError || userSnapshot.data == null) {
          return Scaffold(
            body: Center(
              child: Text('Error fetching user: ${userSnapshot.error}'),
            ),
          );
        }

        final owner = userSnapshot.data!;
        final formKey = GlobalKey<FormState>();

        void addVehicleDialog() {
          String registrationNumber = '';
          String vehicleType = '';

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Nytt fordon'),
                content: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Registreringsnummer',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Skriv in ett registreringsnummer';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          registrationNumber = value;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Fordonstyp',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Skriv in en fordonstyp';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          vehicleType = value;
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
                    child: const Text('Stäng'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        vehicleRepository.add(
                          Vehicle(registrationNumber, vehicleType, owner),
                        );
                        Navigator.of(context).pop();
                        _loadVehicles();
                      }
                    },
                    child: const Text('Lägg till'),
                  ),
                ],
              );
            },
          );
        }

        void editVehicleDialog(Vehicle vehicle) {
          String registrationNumber = vehicle.registrationNumber;
          String vehicleType = vehicle.type;

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Ändra fordon'),
                content: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        initialValue: registrationNumber,
                        decoration: const InputDecoration(
                          labelText: 'Registreringsnummer',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Skriv in ett registreringsnummer';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          registrationNumber = value;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: vehicleType,
                        decoration: const InputDecoration(
                          labelText: 'Fordonstyp',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Skriv in en fordonstyp';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          vehicleType = value;
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
                        vehicleRepository.update(
                          vehicle.id,
                          Vehicle(registrationNumber, vehicleType, owner,
                              vehicle.id),
                        );
                        Navigator.of(context).pop();
                        _loadVehicles();
                      }
                    },
                    child: const Text('Spara'),
                  ),
                ],
              );
            },
          );
        }

        void deleteVehicleDialog(Vehicle vehicle) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Ta bort fordon'),
                content: Text(
                  'Är du säker på att du vill ta bort fordon ${vehicle.registrationNumber}?',
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
                      vehicleRepository.delete(vehicle.id);
                      Navigator.of(context).pop();
                      _loadVehicles();
                    },
                    child: const Text('Ta bort'),
                  ),
                ],
              );
            },
          );
        }

        return Scaffold(
          body: FutureBuilder<List<Vehicle>>(
            future: _vehiclesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error fetching vehicles: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('Inga fordon hittade.'),
                );
              }

              final vehiclesList = snapshot.data!
                  .map((vehicle) => ListCard(
                        icon: Icons.car_crash,
                        title: vehicle.registrationNumber,
                        text: 'Typ: ${vehicle.type}',
                        onEdit: () => editVehicleDialog(vehicle),
                        onDelete: () => deleteVehicleDialog(vehicle),
                      ))
                  .toList();

              return ListView(
                padding: const EdgeInsets.all(8.0),
                children: vehiclesList,
              );
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: addVehicleDialog,
            label: const Text('Lägg till fordon'),
            icon: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
